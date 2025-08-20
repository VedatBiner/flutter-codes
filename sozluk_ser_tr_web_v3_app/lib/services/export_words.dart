// <📜 ----- lib/services/export_words.dart ----->
/*
  📦 Firestore → JSON + CSV + XLSX dışa aktarma (Word modeli ile, web + mobil/desktop uyumlu)

  NE YAPAR?
  1) `collectionName` koleksiyonunu `withConverter<Word>` ile **tipli** okur.
  2) Firestore’dan doğrudan **alfabetik sıralı** şekilde çeker:
     - Birincil:  orderBy('sirpca')
     - İkincil:   orderBy(FieldPath.documentId)  (deterministik & sayfalama için)
     - Cursor:    startAfter([lastSirpca, lastId])
     - Büyük veride `pageSize` ile sayfalı okur.
     ⚠️ Bu birleşik sıralama için Firestore console bir kereye mahsus **composite index**
        isteyebilir; log’da çıkan linkten oluşturabilirsiniz.
  3) Aynı veriden üç çıktı üretir (💡 ID ALANI ÇIKARILDI):
     • JSON: pretty-print, **id yok** → `fileNameJson`
     • CSV : UTF-8 BOM + başlık, **id yok** → `fileNameCsv`
     • XLSX: tek sayfa, başlık **kalın & koyu mavi + beyaz**, **id yok** → `fileNameXlsx`
  4) Kaydetme/indirme:
     - Web: tarayıcı indirmesi (Blob)
     - Android/Desktop: **Downloads** (opsiyonel alt klasör)
     - iOS: **Belgeler + Paylaş** (Files ile Downloads’a aktarılabilir)

  GERİ DÖNÜŞ:
  - Üç dosyanın da kaydedildiği yol(lar) ve istatistikler: [jsonPath, csvPath, xlsxPath, count, elapsedMs]

  BAĞIMLILIKLAR:
  - cloud_firestore, excel:^4.x, (JsonSaver için) path_provider, share_plus, permission_handler, external_path
*/

import 'dart:convert';
import 'dart:developer' show log;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';

import '../constants/file_info.dart';
import '../models/word_model.dart';
import '../utils/json_saver.dart';

class ExportResultX {
  final String jsonPath;
  final String csvPath;
  final String xlsxPath;
  final int count;
  final int elapsedMs;
  const ExportResultX({
    required this.jsonPath,
    required this.csvPath,
    required this.xlsxPath,
    required this.count,
    required this.elapsedMs,
  });
}

Future<ExportResultX> exportWordsToJsonCsvXlsx({
  int pageSize = 1000,
  String? subfolder = 'kelimelik_words_app',
}) async {
  final sw = Stopwatch()..start();
  final List<Word> all = [];

  try {
    // Tipli koleksiyon referansı
    final col = FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<Word>(
          fromFirestore: Word.fromFirestore,
          toFirestore: (w, _) => w.toFirestore(),
        );

    // --- SIRPCA'YA GÖRE DOĞRUDAN SIRALI OKUMA (PAGİNASYONLU) ---
    Query<Word> base = col.orderBy('sirpca').orderBy(FieldPath.documentId);

    String? lastSirpca;
    String? lastId;

    while (true) {
      var q = base.limit(pageSize);

      // Cursor: hem sirpca hem id ile devam et
      if (lastSirpca != null && lastId != null) {
        q = q.startAfter([lastSirpca, lastId]);
      }

      final snap = await q.get();
      if (snap.docs.isEmpty) break;

      for (final d in snap.docs) {
        all.add(d.data());
      }

      // Son cursor değerlerini güncelle
      final lastDoc = snap.docs.last;
      lastSirpca = lastDoc.data().sirpca;
      lastId = lastDoc.id;

      if (snap.docs.length < pageSize) break; // son sayfa
    }

    // --- JSON (pretty) — ID YOK
    final jsonStr = const JsonEncoder.withIndent(
      '  ',
    ).convert(all.map((w) => w.toJson(includeId: false)).toList());
    final jsonSavedAt = await JsonSaver.saveToDownloads(
      jsonStr,
      fileNameJson,
      subfolder: subfolder,
    );

    // --- CSV (UTF-8 BOM + başlık) — ID YOK
    final csvStr = _buildCsv(all);
    final csvSavedAt = await JsonSaver.saveTextToDownloads(
      csvStr,
      fileNameCsv,
      contentType: 'text/csv; charset=utf-8',
      subfolder: subfolder,
    );

    // --- XLSX (başlık stili + otomatik sütun genişliği) — ID YOK
    final xlsxBytes = _buildXlsx(all);
    final xlsxSavedAt = await JsonSaver.saveBytesToDownloads(
      xlsxBytes,
      fileNameXlsx,
      mime: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      subfolder: subfolder,
    );

    sw.stop();
    log(
      '📦 Export (JSON+CSV+XLSX) tamam: ${all.length} kayıt, ${sw.elapsedMilliseconds} ms',
      name: collectionName,
    );

    return ExportResultX(
      jsonPath: jsonSavedAt,
      csvPath: csvSavedAt,
      xlsxPath: xlsxSavedAt,
      count: all.length,
      elapsedMs: sw.elapsedMilliseconds,
    );
  } catch (e, st) {
    sw.stop();
    log(
      '❌ Hata (exportWordsToJsonCsvXlsx): $e',
      name: collectionName,
      error: e,
      stackTrace: st,
      level: 1000,
    );
    rethrow;
  }
}

// -- CSV üretimi (UTF-8 BOM + başlık satırı) — ID YOK
String _buildCsv(List<Word> list) {
  final headers = ['sirpca', 'turkce', 'userEmail'];
  final sb = StringBuffer();
  sb.write('\uFEFF'); // Excel uyumu için BOM
  sb.writeln(headers.map(_csvEscape).join(','));

  for (final w in list) {
    final row = [w.sirpca, w.turkce, w.userEmail].map(_csvEscape).join(',');
    sb.writeln(row);
  }
  return sb.toString();
}

String _csvEscape(String v) {
  final needsQuotes =
      v.contains(',') ||
      v.contains('"') ||
      v.contains('\n') ||
      v.contains('\r');
  var out = v.replaceAll('"', '""');
  return needsQuotes ? '"$out"' : out;
}

// -- XLSX üretimi (excel ^4.x: CellValue + otomatik sütun genişliği + başlık stili) — ID YOK
Uint8List _buildXlsx(List<Word> list) {
  final excel = Excel.createExcel();
  final String sheetName = excel.getDefaultSheet() ?? 'Sheet1';
  final sheet = excel.sheets[sheetName]!;

  // Başlıklar ve en-uzun metin ölçümü için başlangıç uzunlukları (id yok)
  final headers = ['sirpca', 'turkce', 'userEmail'];
  final maxLens = List<int>.from(headers.map((h) => h.length));

  // 1) Başlık satırı
  sheet.appendRow([
    TextCellValue('sirpca'),
    TextCellValue('turkce'),
    TextCellValue('userEmail'),
  ]);

  // 2) Başlık stili: koyu mavi arkaplan + beyaz yazı + kalın + ortalı
  final headerStyle = CellStyle(
    bold: true,
    fontColorHex: ExcelColor.fromHexString('#FFFFFFFF'), // beyaz
    backgroundColorHex: ExcelColor.fromHexString(
      '#FF0D47A1',
    ), // koyu mavi (Material Blue 900)
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );
  for (int c = 0; c < headers.length; c++) {
    final cell = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0),
    );
    cell.cellStyle = headerStyle;
  }

  // 3) Veri satırları + en uzun uzunlukları güncelle
  for (final w in list) {
    final c1 = w.sirpca;
    final c2 = w.turkce;
    final c3 = w.userEmail;

    sheet.appendRow([TextCellValue(c1), TextCellValue(c2), TextCellValue(c3)]);

    if (c1.length > maxLens[0]) maxLens[0] = c1.length;
    if (c2.length > maxLens[1]) maxLens[1] = c2.length;
    if (c3.length > maxLens[2]) maxLens[2] = c3.length;
  }

  // 4) Sütun genişlikleri: karakter sayısı + padding (yaklaşık)
  for (int col = 0; col < maxLens.length; col++) {
    final width = (maxLens[col] + 2).clamp(10, 60); // min 10, max 60
    sheet.setColumnWidth(col, width.toDouble());
    // Alternatif: sheet.setColumnAutoFit(col);
  }

  // (Opsiyonel) başlık satır yüksekliği:
  // sheet.setRowHeight(0, 22);

  final bytes = excel.encode()!;
  return Uint8List.fromList(bytes);
}
