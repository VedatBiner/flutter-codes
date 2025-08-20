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
     - iOS: **Belgeler + Paylaş** (Files ile Downloads ’a aktarılabilir)

  GERİ DÖNÜŞ:
  - Üç dosyanın da kaydedildiği yol(lar) ve istatistikler: [jsonPath, csvPath, xlsxPath, count, elapsedMs]

  BAĞIMLILIKLAR:
  - cloud_firestore, excel:^4.x, (JsonSaver için) path_provider, share_plus, permission_handler, external_path
*/

import 'dart:convert';
import 'dart:developer' show log;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

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

// -- XLSX üretimi (Syncfusion XlsIO: AutoFilter + başlık stili + auto-fit) — ID YOK
Uint8List _buildXlsx(List<Word> list) {
  final wb = xlsio.Workbook();
  final sheet = wb.worksheets[0];

  // Başlıklar (id yok)
  final headers = ['sirpca', 'turkce', 'userEmail'];

  // 1) Başlık satırı
  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  // 2) Başlık stili
  final headerStyle = wb.styles.add('header');
  headerStyle.bold = true;
  headerStyle.fontColor = '#FFFFFFFF';
  headerStyle.backColor = '#FF0D47A1'; // Material Blue 900
  headerStyle.hAlign = xlsio.HAlignType.center;
  headerStyle.vAlign = xlsio.VAlignType.center;

  final headerRange = sheet.getRangeByIndex(1, 1, 1, headers.length);
  headerRange.cellStyle = headerStyle;

  // 3) Veri satırları
  for (int r = 0; r < list.length; r++) {
    final w = list[r];
    sheet.getRangeByIndex(r + 2, 1).setText(w.sirpca);
    sheet.getRangeByIndex(r + 2, 2).setText(w.turkce);
    sheet.getRangeByIndex(r + 2, 3).setText(w.userEmail);
  }

  // Son satır (1 başlık + data)
  final lastRow = 1 + list.length;

  // 4) AutoFilter → ilk 3 kolon (A:C) — index tabanlı
  sheet.autoFilters.filterRange = sheet.getRangeByIndex(1, 1, lastRow, 3);

  // 5) Auto-fit → index tabanlı aralıkta
  sheet.getRangeByIndex(1, 1, lastRow, 3).autoFitColumns();

  // (Opsiyonel) başlık yüksekliği:
  // sheet.getRangeByIndex(1, 1, 1, 3).rowHeight = 22;

  final bytes = wb.saveAsStream();
  wb.dispose();
  return Uint8List.fromList(bytes);
}
