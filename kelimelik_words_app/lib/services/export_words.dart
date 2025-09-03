// <📜 ----- lib/services/export_words.dart ----->
/*
  📦 SQLite → JSON + CSV + XLSX dışa aktarma (Word modeli ile, mobil/desktop/web dışı)

  NE YAPAR?
  1) Tüm kelimeleri SQLite 'tan çeker (DbHelper).
  2) Bellekte alfabetik olarak (word alanına göre) sıralar.
  3) Üç çıktı üretir (ID YOK):
     • JSON (pretty)                  → fileNameJson
     • CSV (BOM ’lu/UTF-8)             → fileNameCsv         (buildWordsCsvNoId)
     • XLSX (AutoFilter + auto-fit)   → fileNameXlsx        (buildWordsXlsxNoId)
  4) Kaydetme/indirme JsonSaver ile yapılır (Downloads/kelimelik_words_app/…).

  BAĞIMLILIKLAR:
  - sqflite (DbHelper)
  - syncfusion_flutter_xlsio (word_export_formats.dart)
  - path_provider, share_plus, permission_handler, external_path (JsonSaver IO)
*/

// 📌 Dart paketleri
import 'dart:convert';
import 'dart:developer' show log;

// 📌 Proje bağımlılıkları
import '../constants/file_info.dart'; // fileNameJson/fileNameCsv/fileNameXlsx
import '../db/db_helper.dart'; // DbHelper.instance.getAllWords()
import '../models/word_model.dart';
import '../utils/json_saver.dart'; // JsonSaver.saveToDownloads / saveTextToDownloads / saveBytesToDownloads
import 'word_export_formats.dart'; // buildWordsCsvNoId / buildWordsXlsxNoId

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

/// SQLite ’ten kelimeleri alır ve JSON/CSV/XLSX olarak dışa aktarır.
Future<ExportResultX> exportWordsToJsonCsvXlsx({
  String subfolder = 'kelimelik_words_app',
  int? pageSize,
}) async {
  final sw = Stopwatch()..start();

  try {
    // 1) Tüm veriyi SQLite 'tan al
    //    📝 Projende metod adı farklıysa şurayı kendi ismine göre değiştir:
    //    örn: getAllRecords() / fetchAll() / getWords() vb.
    final List<Word> all = await DbHelper.instance.getRecords();

    // 2) Alfabetik sırala (Türkçe/Latin karakterler için basit karşılaştırma)
    all.sort(
      (a, b) =>
          (a.word ?? '').toLowerCase().compareTo((b.word ?? '').toLowerCase()),
    );

    // 3) JSON (pretty) — ID YOK
    final jsonList =
        all.map((w) => {'word': w.word, 'meaning': w.meaning}).toList();

    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);

    final jsonSavedAt = await JsonSaver.saveToDownloads(
      jsonStr,
      fileNameJson,
      subfolder: subfolder,
    );

    // 4) CSV — ID YOK
    final csvStr = buildWordsCsvNoId(all);
    final csvSavedAt = await JsonSaver.saveTextToDownloads(
      csvStr,
      fileNameCsv,
      contentType: 'text/csv; charset=utf-8',
      subfolder: subfolder,
    );

    // 5) XLSX — ID YOK
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
      name: 'exportWordsToJsonCsvXlsx',
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
      name: 'exportWordsToJsonCsvXlsx',
      error: e,
      stackTrace: st,
    );
    rethrow;
  }
}
