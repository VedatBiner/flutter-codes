// <📜 ----- lib/services/export_words.dart ----->
/*
  📦 Firestore → JSON + CSV + XLSX dışa aktarma (Word modeli ile, web + mobil/desktop uyumlu)

  NE YAPAR?
  1) `collectionName` koleksiyonunu `withConverter<Word>` ile **tipli** okur.
  2) `FieldPath.documentId` ile **sayfalı** olarak TÜM belgeleri çeker (pageSize).
  3) Aynı veriyle üç çıktı üretir:
     • JSON: pretty-print, dosya adı `fileNameJson`
     • CSV : UTF-8 BOM + başlık, dosya adı `fileNameCsv`
     • XLSX: tek sayfa, başlık satırı + satırlar, dosya adı `fileNameXlsx`
  4) Web: tarayıcı indirmesi | Android/Desktop: **Downloads** | iOS: **Belgeler + Paylaş**

  GERİ DÖNÜŞ:
  - Üç dosyanın da kaydedildiği tam yolları ve istatistikleri döndürür.

  NOT:
  - XLSX üretimi için `excel` paketini kullanır.
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
    final col = FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<Word>(
          fromFirestore: Word.fromFirestore,
          toFirestore: (w, _) => w.toFirestore(),
        );

    Query<Word> base = col.orderBy(FieldPath.documentId);
    String? lastId;

    while (true) {
      var q = base.limit(pageSize);
      if (lastId != null) q = q.startAfter([lastId]);

      final snap = await q.get();
      if (snap.docs.isEmpty) break;

      for (final d in snap.docs) {
        all.add(d.data());
      }

      lastId = snap.docs.last.id;
      if (snap.docs.length < pageSize) break;
    }

    // --- JSON
    final jsonStr = const JsonEncoder.withIndent(
      '  ',
    ).convert(all.map((w) => w.toJson(includeId: true)).toList());
    final jsonSavedAt = await JsonSaver.saveToDownloads(
      jsonStr,
      fileNameJson,
      subfolder: subfolder,
    );

    // --- CSV
    final csvStr = _buildCsv(all);
    final csvSavedAt = await JsonSaver.saveTextToDownloads(
      csvStr,
      fileNameCsv,
      contentType: 'text/csv; charset=utf-8',
      subfolder: subfolder,
    );

    // --- XLSX
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

// -- CSV üretimi (UTF-8 BOM + başlık satırı)
String _buildCsv(List<Word> list) {
  final headers = ['id', 'sirpca', 'turkce', 'userEmail'];
  final sb = StringBuffer();
  sb.write('\uFEFF'); // Excel uyumu için BOM
  sb.writeln(headers.map(_csvEscape).join(','));
  for (final w in list) {
    final row = [
      w.id ?? '',
      w.sirpca,
      w.turkce,
      w.userEmail,
    ].map(_csvEscape).join(',');
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

// -- XLSX üretimi (excel ^4.x: CellValue + otomatik sütun genişliği + başlık stili)
Uint8List _buildXlsx(List<Word> list) {
  final excel = Excel.createExcel();
  final String sheetName = excel.getDefaultSheet() ?? 'Sheet1';
  final sheet = excel.sheets[sheetName]!;

  // Başlıklar
  final headers = ['id', 'sirpca', 'turkce', 'userEmail'];

  // En uzun metin ölçümleri (başlık uzunluklarıyla başlat)
  final maxLens = List<int>.from(headers.map((h) => h.length));

  // 1) Başlık satırı
  sheet.appendRow([
    TextCellValue('id'),
    TextCellValue('sirpca'),
    TextCellValue('turkce'),
    TextCellValue('userEmail'),
  ]);

  // 2) Başlık stili (kalın + koyu mavi arkaplan + beyaz yazı)
  final headerStyle = CellStyle(
    bold: true,
    fontColorHex: ExcelColor.fromHexString('#FFFFFFFF'),
    backgroundColorHex: ExcelColor.fromHexString('#FF0D47A1'),
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );
  for (int c = 0; c < headers.length; c++) {
    final cell = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0),
    );
    cell.cellStyle = headerStyle;
  }

  // 3) Veri satırları + max uzunluk güncelle
  for (final w in list) {
    final c0 = w.id ?? '';
    final c1 = w.sirpca;
    final c2 = w.turkce;
    final c3 = w.userEmail;

    sheet.appendRow([
      TextCellValue(c0),
      TextCellValue(c1),
      TextCellValue(c2),
      TextCellValue(c3),
    ]);

    if (c0.length > maxLens[0]) maxLens[0] = c0.length;
    if (c1.length > maxLens[1]) maxLens[1] = c1.length;
    if (c2.length > maxLens[2]) maxLens[2] = c2.length;
    if (c3.length > maxLens[3]) maxLens[3] = c3.length;
  }

  // 4) Sütun genişliği: yeni API setColumnWidth(...)
  for (int col = 0; col < maxLens.length; col++) {
    final width = (maxLens[col] + 2).clamp(10, 60); // min 10, max 60
    sheet.setColumnWidth(col, width.toDouble());
    // İstersen gerçek "auto fit" denemesi:
    // sheet.setColumnAutoFit(col);
  }

  // (Opsiyonel) başlık satır yüksekliği:
  // sheet.setRowHeight(0, 22);

  final bytes = excel.encode()!;
  return Uint8List.fromList(bytes);
}
