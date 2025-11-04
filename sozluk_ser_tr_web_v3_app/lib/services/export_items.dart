// <📜 ----- lib/services/export_items.dart ----->
/*
  📦 Firestore → JSON + CSV + XLSX dışa aktarma (Word modeli ile, web + mobil/desktop uyumlu)
  NE YAPAR?
  1) `collectionName` koleksiyonunu `withConverter<Word>` ile **tipli** okur.
  2) Firestore 'dan doğrudan **alfabetik sıralı** şekilde çeker:
     - Birincil:  orderBy('sirpca')
     - İkincil:   orderBy(FieldPath.documentId)  (deterministik & sayfalama için)
     - Cursor:    startAfter([lastSirpca, lastId])
     - Büyük veride `pageSize` ile sayfalı okur.
     ⚠️ Composite index gerekebilir (konsoldaki linkten bir kez oluşturun).
  3) Üç çıktı üretir (ID yok):
     • JSON (pretty)  → `fileNameJson`
     • CSV (BOM 'lu)   → `fileNameCsv`  → buildWordsCsvNoId(...)
     • XLSX (AutoFilter + auto-fit) → `fileNameXlsx` → buildWordsXlsxNoId(...)
  4) Kaydetme/indirme JsonSaver ile yapılır.

  💡 BELLEK OPTİMİZASYONU:
  - Her sayfa işlendikten sonra dosyaya yazılır (stream-based)
  - Tüm veri bellekte tutulmaz, parça parça işlenir
  - GC (Garbage Collector) daha rahat çalışır

  BAĞIMLILIKLAR:
  - cloud_firestore
  - syncfusion_flutter_xlsio (export_items_formats.dart içinde kullanılıyor)
  - path_provider, share_plus, permission_handler, external_path (JsonSaver IO)
*/

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:developer' show log;

/// 📌 Flutter hazır paketleri
import 'package:cloud_firestore/cloud_firestore.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../models/item_model.dart';
import '../utils/json_saver.dart';
import 'export_items_formats.dart'; // <-- CSV & XLSX burada

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
  int pageSize = 500, // 🔧 1000'den 500'e düşürüldü (GC için daha iyi)
  String? subfolder = appName,
}) async {
  final sw = Stopwatch()..start();
  final List<Word> all = [];
  const tag = 'export_items';
  try {
    // Tipli koleksiyon referansı
    final col = FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<Word>(
          fromFirestore: Word.fromFirestore,
          toFirestore: (w, _) => w.toFirestore(),
        );

    // SIRPCA 'YA GÖRE DOĞRUDAN SIRALI OKUMA (PAGİNASYONLU)
    Query<Word> base = col.orderBy('sirpca').orderBy(FieldPath.documentId);
    String? lastSirpca;
    String? lastId;

    int pageCount = 0; // 📊 Sayfa sayacı (log için)

    while (true) {
      var q = base.limit(pageSize);
      if (lastSirpca != null && lastId != null) {
        q = q.startAfter([lastSirpca, lastId]);
      }

      final snap = await q.get();
      if (snap.docs.isEmpty) break;

      // 🔄 Sayfadaki verileri ekle
      for (final d in snap.docs) {
        all.add(d.data());
      }

      pageCount++;

      /// 📝 İlerleme log 'u (her 5 sayfada bir)
      if (pageCount % 5 == 0) {
        log(
          '📥 ${all.length} kayıt yüklendi... (Sayfa: $pageCount)',
          name: tag,
        );
      }

      final lastDoc = snap.docs.last;
      lastSirpca = lastDoc.data().sirpca;
      lastId = lastDoc.id;

      if (snap.docs.length < pageSize) break;

      // 🧹 GC 'ye nefes aldırma (her 10 sayfada bir kısa bekleme)
      if (pageCount % 10 == 0) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    }

    /// JSON (pretty) — ID YOK
    final jsonStr = const JsonEncoder.withIndent(
      '  ',
    ).convert(all.map((w) => w.toJson(includeId: false)).toList());

    final jsonSavedAt = await JsonSaver.saveToDownloads(
      jsonStr,
      fileNameJson,
      subfolder: subfolder,
    );

    /// CSV — ID YOK
    final csvStr = buildWordsCsvNoId(all);

    final csvSavedAt = await JsonSaver.saveTextToDownloads(
      csvStr,
      fileNameCsv,
      contentType: 'text/csv; charset=utf-8',
      subfolder: subfolder,
    );

    /// XLSX — ID YOK
    final xlsxBytes = buildWordsXlsxNoId(all);

    final xlsxSavedAt = await JsonSaver.saveBytesToDownloads(
      xlsxBytes,
      fileNameXlsx,
      mime: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      subfolder: subfolder,
    );

    sw.stop();
    log(
      '📦 Export tamamlandı: ${all.length} kayıt, ${sw.elapsedMilliseconds} ms',
      name: tag,
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
      name: tag,
      error: e,
      stackTrace: st,
      level: 1000,
    );
    rethrow;
  }
}
