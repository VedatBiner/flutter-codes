// 📃 <----- lib/utils/file_creator.dart ----->
// Tam Pipeline + Rebuild sistemi + Notification + ZIP

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

Future<void> initializeAppDataFlow(BuildContext context) async {
  final sw = Stopwatch()..start();
  log("🚀 initializeAppDataFlow başladı", name: tag);

  // ----------------------------------------------------------
  // 📌 Tüm dosya yollarını tek seferde hesapla
  // ----------------------------------------------------------
  final directory = await getApplicationDocumentsDirectory();
  final jsonFull = join(directory.path, fileNameJson);
  final csvFull = join(directory.path, fileNameCsv);
  final excelFull = join(directory.path, fileNameXlsx);
  final sqlFull = join(directory.path, fileNameSql);
  final zipFull = join(directory.path, fileNameZip);

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
      await DbHelper.instance.closeDb();

      if (await dbFile.exists()) {
        await dbFile.delete();
        log("🗑 DB silindi: $sqlFull", name: tag);
      }

      for (final p in [jsonFull, excelFull]) {
        final f = File(p);
        if (await f.exists()) {
          await f.delete();
          log("🗑 Silindi: $p", name: tag);
        }
      }

      await createJsonFromAssetCsv();
      await createExcelFromAssetCsvSyncfusion();
      await importJsonToDatabaseFast();

      await runFullDataReport(
        csvToJsonMs: 0,
        jsonToSqlMs: 0,
        totalPipelineMs: 0,
        insertDurations: [],
      );

      final zipOut = await createZipArchive();

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
      bannerCtrl.close(); // ✔ kapanmazsa banner sonsuza kadar kalır
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

      if (!context.mounted) return;

      showCreateDbNotification(
        context,
        jsonFull,
        csvFull,
        excelFull,
        sqlFull,
        zipFull,
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

    if (!context.mounted) return;

    showCreateDbNotification(
      context,
      jsonFull,
      csvFull,
      excelFull,
      sqlFull,
      zipFull,
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
