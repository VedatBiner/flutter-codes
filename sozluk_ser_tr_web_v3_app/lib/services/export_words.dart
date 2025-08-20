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
     ⚠️ Composite index gerekebilir (konsoldaki linkten bir kez oluşturun).
  3) Üç çıktı üretir (ID yok):
     • JSON (pretty)  → `fileNameJson`
     • CSV (BOM’lu)   → `fileNameCsv`  → buildWordsCsvNoId(...)
     • XLSX (AutoFilter + auto-fit) → `fileNameXlsx` → buildWordsXlsxNoId(...)
  4) Kaydetme/indirme JsonSaver ile yapılır.

  BAĞIMLILIKLAR:
  - cloud_firestore
  - syncfusion_flutter_xlsio (word_export_formats.dart içinde kullanılıyor)
  - path_provider, share_plus, permission_handler, external_path (JsonSaver IO)
*/

import 'dart:convert';
import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/file_info.dart';
import '../models/word_model.dart';
import '../utils/json_saver.dart';
import 'word_export_formats.dart'; // <-- CSV & XLSX burada

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

    // SIRPCA'YA GÖRE DOĞRUDAN SIRALI OKUMA (PAGİNASYONLU)
    Query<Word> base = col.orderBy('sirpca').orderBy(FieldPath.documentId);

    String? lastSirpca;
    String? lastId;

    while (true) {
      var q = base.limit(pageSize);

      if (lastSirpca != null && lastId != null) {
        q = q.startAfter([lastSirpca, lastId]);
      }

      final snap = await q.get();
      if (snap.docs.isEmpty) break;

      for (final d in snap.docs) {
        all.add(d.data());
      }

      final lastDoc = snap.docs.last;
      lastSirpca = lastDoc.data().sirpca;
      lastId = lastDoc.id;

      if (snap.docs.length < pageSize) break;
    }

    // JSON (pretty) — ID YOK
    final jsonStr = const JsonEncoder.withIndent(
      '  ',
    ).convert(all.map((w) => w.toJson(includeId: false)).toList());
    final jsonSavedAt = await JsonSaver.saveToDownloads(
      jsonStr,
      fileNameJson,
      subfolder: subfolder,
    );

    // CSV — ID YOK
    final csvStr = buildWordsCsvNoId(all);
    final csvSavedAt = await JsonSaver.saveTextToDownloads(
      csvStr,
      fileNameCsv,
      contentType: 'text/csv; charset=utf-8',
      subfolder: subfolder,
    );

    // XLSX — ID YOK
    final xlsxBytes = buildWordsXlsxNoId(all);
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
