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
//   6️⃣ Benchmark + Duplicate Report (fc_report.dart)
//   7️⃣ ZIP oluşturma
//   8️⃣ Notification gösterme
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../widgets/bottom_banner_helper.dart';
import '../widgets/show_notification_handler.dart';
import 'fc_files/csv_helper.dart';
import 'fc_files/excel_helper.dart';
import 'fc_files/fc_report.dart';
import 'fc_files/json_helper.dart';
import 'fc_files/sql_helper.dart';
import 'fc_files/zip_helper.dart';

const tag = "file_creator";

/// ------------------------------------------------------------
/// Tüm Pipeline için tek fonksiyon
/// ------------------------------------------------------------
Future<void> initializeAppDataFlow(BuildContext context) async {
  final sw = Stopwatch()..start();
  log("🚀 initializeAppDataFlow başladı", name: tag);

  // ----------------------------------------------------------
  // 📌 Tüm dosya yollarını tek seferde hesapla
  // ----------------------------------------------------------
  final directory = await getApplicationDocumentsDirectory();
  final basePath = directory.path;

  final jsonFull = join(basePath, fileNameJson);
  final csvFull = join(basePath, fileNameCsv);
  final excelFull = join(basePath, fileNameXlsx);
  final sqlFull = join(basePath, fileNameSql);
  // final zipFull = join(basePath, fileNameZip); // ZIP yolu artık createZipArchive içinden geliyor

  // ZIP'e girecek dosya listesi
  final List<String> backupFiles = [jsonFull, csvFull, excelFull, sqlFull];

  // ----------------------------------------------------------
  // 1️⃣ CSV Sync
  // ----------------------------------------------------------
  final csvSync = await createOrUpdateDeviceCsvFromAsset();

  final dbFile = File(sqlFull);
  final dbExists = await dbFile.exists();
  final recordCount = dbExists ? await DbHelper.instance.countRecords() : 0;

  // ----------------------------------------------------------
  // 🛠 REBUILD GEREKİYOR
  // ----------------------------------------------------------
  if (csvSync.needsRebuild) {
    log(
      "⚠️ REBUILD → Asset CSV farklı, tüm veriler yeniden oluşturulacak",
      name: tag,
    );

    if (!context.mounted) return;

    final bannerCtrl = showLoadingBanner(
      context,
      message: "Lütfen bekleyiniz,\nVeriler oluşturuluyor...",
    );

    try {
      // DB kapat + sil
      await DbHelper.instance.closeDb();

      if (await dbFile.exists()) {
        await dbFile.delete();
        log("🗑 DB silindi: $sqlFull", name: tag);
      }

      // Eski JSON & Excel'i sil
      for (final p in [jsonFull, excelFull]) {
        final f = File(p);
        if (await f.exists()) {
          await f.delete();
          log("🗑 Silindi: $p", name: tag);
        }
      }

      // Yeniden üretim
      await createJsonFromAssetCsv();
      await createExcelFromAssetCsvSyncfusion();
      await importJsonToDatabaseFast();

      // Benchmark + rapor (şimdilik dummy değerler)
      await runFullDataReport(
        csvToJsonMs: 0,
        jsonToSqlMs: 0,
        totalPipelineMs: 0,
        insertDurations: [],
      );

      /// ✔ ZIP oluştur — yeni imzaya göre (outputDir + files)
      final zipOut = await createZipArchive(
        outputDir: basePath,
        files: backupFiles,
      );

      if (!context.mounted) return;

      showCreateDbNotification(
        context,
        jsonFull,
        csvFull,
        excelFull,
        sqlFull,
        zipOut,
      );
    } finally {
      bannerCtrl.close();
    }

    sw.stop();
    log("⏱ REBUILD tamamlandı: ${sw.elapsedMilliseconds} ms", name: tag);
    return;
  }

  // ----------------------------------------------------------
  // ✔ Normal mod (DB dolu)
  // ----------------------------------------------------------
  if (dbExists && recordCount > 0) {
    log("🟢 DB zaten dolu ($recordCount kayıt).", name: tag);

    if (!context.mounted) return;

    final bannerCtrl = showLoadingBanner(
      context,
      message: "Lütfen bekleyiniz,\nveriler hazırlanıyor...",
    );

    try {
      await runFullDataReport(
        csvToJsonMs: 0,
        jsonToSqlMs: 0,
        totalPipelineMs: 0,
        insertDurations: [],
      );

      /// ✔ ZIP oluştur — yeni imza
      final zipOut = await createZipArchive(
        outputDir: basePath,
        files: backupFiles,
      );

      if (!context.mounted) return;

      showCreateDbNotification(
        context,
        jsonFull,
        csvFull,
        excelFull,
        sqlFull,
        zipOut,
      );
    } finally {
      bannerCtrl.close();
    }

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

  if (!context.mounted) return;

  final bannerCtrl = showLoadingBanner(
    context,
    message: "Lütfen bekleyiniz,\nveriler okunuyor...",
  );

  try {
    await createJsonFromAssetCsv();
    await createExcelFromAssetCsvSyncfusion();
    await importJsonToDatabaseFast();

    await runFullDataReport(
      csvToJsonMs: 0,
      jsonToSqlMs: 0,
      totalPipelineMs: 0,
      insertDurations: [],
    );

    /// ✔ ZIP oluştur — yeni imza
    final zipOut = await createZipArchive(
      outputDir: basePath,
      files: backupFiles,
    );

    if (!context.mounted) return;

    showCreateDbNotification(
      context,
      jsonFull,
      csvFull,
      excelFull,
      sqlFull,
      zipOut,
    );
  } finally {
    bannerCtrl.close();
  }

  sw.stop();
  log(
    "✅ initializeAppDataFlow tamamlandı: ${sw.elapsedMilliseconds} ms",
    name: tag,
  );
  log(logLine, name: tag);
}
