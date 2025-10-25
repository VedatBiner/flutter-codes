// <📜 ----- lib/services/export_words.dart ----->
/*
  📦 SQLite → JSON + CSV + XLSX (+ DB .sqlite) dışa aktarma

  NE YAPAR?
  1) Tüm kelimeleri SQLite 'tan çeker (DbHelper).
  2) Bellekte alfabetik olarak (word alanına göre) sıralar.
  3) Üç çıktı üretir (ID YOK):
     • JSON (pretty)                  → fileNameJson
     • CSV (UTF-8/BOM)                → fileNameCsv         (buildWordsCsvNoId)
     • XLSX (AutoFilter + auto-fit)   → fileNameXlsx        (buildWordsXlsxNoId)
  4) Ek olarak **SQLite .db dosyasını** da aynı klasöre kopyalar → fileNameSql
  5) Kaydetme/indirme JsonSaver ile yapılır (Downloads/<appName>/…).

  BAĞIMLILIKLAR:
  - sqflite (DbHelper & getDatabasesPath)
  - syncfusion_flutter_xlsio (word_export_formats.dart)
  - path_provider, share_plus, permission_handler, external_path (JsonSaver IO)
  - path (dosya adları)
*/

// 📌 Dart paketleri
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

// 📌 3rd party
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' show getDatabasesPath;

// 📌 Proje bağımlılıkları
import '../constants/file_info.dart'; // fileNameJson/fileNameCsv/fileNameXlsx/fileNameSql
import '../db/db_helper.dart'; // DbHelper.instance.getRecords()
import '../models/item_model.dart';
import '../utils/json_saver.dart';
import 'export_items_formats.dart'; // JsonSaver.saveToDownloads / saveTextToDownloads / saveBytesToDownloads

class ExportItems {
  final String jsonPath;
  final String csvPath;
  final String xlsxPath;
  final String sqlPath;
  final int count;
  final int elapsedMs;
  const ExportItems({
    required this.jsonPath,
    required this.csvPath,
    required this.xlsxPath,
    required this.sqlPath,
    required this.count,
    required this.elapsedMs,
  });
}

/// SQLite ’ten kelimeleri alır ve JSON/CSV/XLSX olarak dışa aktarır.
/// Ek olarak veritabanı dosyasını (fileNameSql) da aynı klasöre kopyalar.
Future<ExportItems> exportItemsToFileFormats({
  String subfolder = appName,
  int? pageSize, // geriye dönük uyumluluk için (kullanılmıyor)
}) async {
  final sw = Stopwatch()..start();

  try {
    // 1) Tüm veriyi SQLite 'tan al
    //    📝 Projende metod adı farklıysa şurayı kendi ismine göre değiştir:
    //    örn: getAllRecords() / fetchAll() / getWords() vb.
    final List<Word> all = await DbHelper.instance.getRecords();

    // 2) Alfabetik sırala
    all.sort((a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()));

    // 3) JSON (pretty) — ID YOK
    final jsonList = all
        .map((w) => {'word': w.word, 'meaning': w.meaning})
        .toList();

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

    // 6) SQLite DB dosyasını da aynı klasöre yedekle (fileNameSql)
    String sqlSavedAt = '-';
    try {
      // 6.a) Önce DbHelper 'tan AÇIK DB ’nin gerçek yolunu almaya çalış
      //      (DbHelper.instance.database eğer Database döndürüyorsa)
      String? dbPath;
      try {
        final db = await DbHelper.instance.database; // <- DbHelper ’ında varsa
        dbPath = db.path; // gerçek path
      } catch (_) {
        dbPath = null;
      }

      // 6.b) Olmazsa klasik fallback: getDatabasesPath() + fileNameSql
      if (dbPath == null) {
        final dbDir = await getDatabasesPath();
        dbPath = p.join(dbDir, fileNameSql);
      }

      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        // (Opsiyonel) WAL/SHM dosyalarını da kopyala — tutarlı yedek için faydalı
        final walFile = File('$dbPath-wal');
        final shmFile = File('$dbPath-shm');

        // Ana .db
        final dbBytes = await dbFile.readAsBytes();
        sqlSavedAt = await JsonSaver.saveBytesToDownloads(
          dbBytes,
          fileNameSql, // ör: "kelimelik.db"
          mime: 'application/octet-stream',
          subfolder: subfolder,
        );

        // WAL (varsa)
        if (await walFile.exists()) {
          final walBytes = await walFile.readAsBytes();
          await JsonSaver.saveBytesToDownloads(
            walBytes,
            '$fileNameSql-wal',
            mime: 'application/octet-stream',
            subfolder: subfolder,
          );
        }

        // SHM (varsa)
        if (await shmFile.exists()) {
          final shmBytes = await shmFile.readAsBytes();
          await JsonSaver.saveBytesToDownloads(
            shmBytes,
            '$fileNameSql-shm',
            mime: 'application/octet-stream',
            subfolder: subfolder,
          );
        }
      } else {
        log(
          '⚠️ DB dosyası bulunamadı: $dbPath',
          name: 'exportWordsToJsonCsvXlsx',
        );
      }
    } catch (e) {
      log('⚠️ DB yedeği alınamadı: $e', name: 'Export_items');
    }

    sw.stop();
    log(
      '📦 Export tamamlandı: ${all.length} kayıt, ${sw.elapsedMilliseconds} ms',
      name: 'Export_items',
    );

    return ExportItems(
      jsonPath: jsonSavedAt,
      csvPath: csvSavedAt,
      xlsxPath: xlsxSavedAt,
      sqlPath: sqlSavedAt, // <-- artık tanımlı
      count: all.length,
      elapsedMs: sw.elapsedMilliseconds,
    );
  } catch (e, st) {
    sw.stop();
    log(
      '❌ Hata (exportWordsToJsonCsvXlsx): $e',
      name: 'Export_items',
      error: e,
      stackTrace: st,
    );
    rethrow;
  }
}
