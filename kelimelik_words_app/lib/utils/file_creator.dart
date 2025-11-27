// 📃 <----- lib/utils/file_creator.dart ----->
//
// Tam Pipeline + Rebuild sistemi + Notification + ZIP
// -----------------------------------------------------------
// Akış:
//   1️⃣ CSV Sync → createOrUpdateDeviceCsvFromAsset()
//   2️⃣ Eğer needsRebuild = true → TAM REBUILD
//   3️⃣ CSV → JSON
//   4️⃣ CSV → Excel
//   5️⃣ JSON → SQL
//   6️⃣ Raporlama
//   7️⃣ ZIP oluşturma
//   8️⃣ Notification gösterme
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../utils/zip_helper.dart';
import '../widgets/show_notification_handler.dart';
import 'fc_files/csv_helper.dart';
import 'fc_files/excel_helper.dart';
import 'fc_files/json_helper.dart';
import 'fc_files/sql_helper.dart';

const tag = "file_creator";

Future<void> initializeAppDataFlow(BuildContext context) async {
  // const tag = "file_creator";
  final sw = Stopwatch()..start();

  log("🚀 initializeAppDataFlow başladı", name: tag);

  // 0️⃣ Tüm dosya yollarını tek yerde hesapla
  final directory = await getApplicationDocumentsDirectory();
  final jsonFull = join(directory.path, fileNameJson);
  final csvFull = join(directory.path, fileNameCsv);
  final excelFull = join(directory.path, fileNameXlsx);
  final sqlFull = join(directory.path, fileNameSql);
  final zipFull = join(directory.path, fileNameZip);

  // 1️⃣ CSV Sync
  final csvSync = await createOrUpdateDeviceCsvFromAsset();

  // DB mevcut mu?
  final dbFile = File(sqlFull);
  final dbExists = await dbFile.exists();
  final recordCount = dbExists ? await DbHelper.instance.countRecords() : 0;

  // ----------------------------------------------------------
  // 🛠 REBUILD — CSV cihazdaki ile uyuşmuyorsa
  // ----------------------------------------------------------
  if (csvSync.needsRebuild) {
    log(
      "⚠️ REBUILD → Asset CSV farklı, tüm veriler yeniden oluşturulacak",
      name: tag,
    );

    /// 📌 DB kapat ve sil
    await DbHelper.instance.closeDb();
    if (await dbFile.exists()) {
      await dbFile.delete();
      log("🗑 DB silindi: $sqlFull", name: tag);
    }

    /// 📌 JSON & Excel sil
    for (final p in [jsonFull, excelFull]) {
      final f = File(p);
      if (await f.exists()) {
        await f.delete();
        log("🗑 Silindi: $p", name: tag);
      }
    }

    /// 📌 Yeniden üretim
    await createJsonFromAssetCsv();
    await createExcelFromAssetCsvSyncfusion();
    await importJsonToDatabaseFast();
    await _runConsistencyReport();

    /// 📌 ZIP oluştur
    final createdZip = await createZipArchive();

    /// 📌 Notification
    showCreateDbNotification(
      context,
      jsonFull,
      csvFull,
      excelFull,
      sqlFull,
      createdZip,
    );

    sw.stop();
    log("⏱ REBUILD tamamlandı: ${sw.elapsedMilliseconds} ms", name: tag);
    return;
  }

  // ----------------------------------------------------------
  // ✔ Normal mod (REBUILD yok)
  // ----------------------------------------------------------
  if (dbExists && recordCount > 0) {
    log("🟢 DB zaten dolu ($recordCount kayıt).", name: tag);

    await _runConsistencyReport();
    final zipPath = await createZipArchive();

    // Notification
    showCreateDbNotification(
      context,
      jsonFull,
      csvFull,
      excelFull,
      sqlFull,
      zipPath,
    );

    sw.stop();
    log(
      "⏱ initializeAppDataFlow bitti: ${sw.elapsedMilliseconds} ms",
      name: tag,
    );
    return;
  }

  // ----------------------------------------------------------
  // ✔ İlk kurulum (DB yok)
  // ----------------------------------------------------------
  log("⚠️ İlk kurulum başlıyor…", name: tag);

  await createJsonFromAssetCsv();
  await createExcelFromAssetCsvSyncfusion();
  await importJsonToDatabaseFast();
  await _runConsistencyReport();

  final zipPath = await createZipArchive();

  showCreateDbNotification(
    context,
    jsonFull,
    csvFull,
    excelFull,
    sqlFull,
    zipPath,
  );

  sw.stop();
  log(
    "✅ initializeAppDataFlow tamamlandı: ${sw.elapsedMilliseconds} ms",
    name: tag,
  );
}

// ======================================================================
// 📊 Raporlama
// ======================================================================
Future<void> _runConsistencyReport() async {
  // const tag = "consistency";

  final directory = await getApplicationDocumentsDirectory();
  final csvPath = join(directory.path, fileNameCsv);
  final jsonPath = join(directory.path, fileNameJson);

  /// 📜 CSV
  final csvRaw = await File(csvPath).readAsString();
  final csvLines = csvRaw
      .replaceAll("\r\n", "\n")
      .replaceAll("\r", "\n")
      .split("\n")
      .where((e) => e.trim().isNotEmpty)
      .toList();
  final csvCount = csvLines.length - 1;

  /// 📜 JSON
  final jsonList = jsonDecode(await File(jsonPath).readAsString()) as List;
  final jsonCount = jsonList.length;

  /// 📜 SQL
  final sqlCount = await DbHelper.instance.countRecords();

  log(logLine, name: tag);
  log("📊 CSV: $csvCount | JSON: $jsonCount | SQL: $sqlCount", name: tag);
  log(
    csvCount == jsonCount && jsonCount == sqlCount
        ? "✅ TUTARLI"
        : "❌ TUTARSIZLIK VAR",
    name: tag,
  );
  log(logLine, name: tag);
}
