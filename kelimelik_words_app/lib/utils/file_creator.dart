// 📃 <----- lib/utils/file_creator.dart ----->
//
// Tam Pipeline + Incremental Sync + Notification + ZIP
// -----------------------------------------------------------
// Yeni akış:
//   1️⃣ CSV Sync → createOrUpdateDeviceCsvFromAsset()
//   2️⃣ CSV ↔ SQL Incremental Sync → syncCsvWithDatabase()
//       • Eksik kelimeler eklenir
//       • Anlamı değişen kelimeler güncellenir
//       • Kullanıcının eklediği kelimeler SİLİNMEZ
//   3️⃣ CSV → JSON (her zaman yeniden oluşturulur)
//   4️⃣ CSV → Excel (her zaman yeniden oluşturulur)
//   5️⃣ Benchmark + Duplicate Report (fc_report.dart)
//   6️⃣ ZIP oluşturma (JSON + CSV + XLSX + SQL)
//   7️⃣ Notification gösterme
// -----------------------------------------------------------

import 'dart:developer';

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
import 'fc_files/sync_helper.dart';
import 'fc_files/zip_helper.dart';

const tag = "file_creator";

/// ------------------------------------------------------------
/// Tüm Pipeline için TEK giriş noktası
/// ------------------------------------------------------------
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

  // ZIP içine girecek dosyalar
  final backupFiles = <String>[jsonFull, csvFull, excelFull, sqlFull];

  if (!context.mounted) return;

  // Alt banner
  final bannerCtrl = showLoadingBanner(
    context,
    message: "Lütfen bekleyiniz,\nveriler senkronize ediliyor...",
  );

  try {
    // ----------------------------------------------------------
    // 1️⃣ Asset CSV → Device CSV senkronizasyonu
    // ----------------------------------------------------------
    final csvSync = await createOrUpdateDeviceCsvFromAsset();
    log("📄 CSV Sync tamamlandı. changed=${csvSync.needsRebuild}", name: tag);

    // ----------------------------------------------------------
    // 2️⃣ CSV ↔ SQL Incremental Sync
    // ----------------------------------------------------------
    final syncResult = await syncCsvWithDatabase();

    // Toplam kayıt sayısını bir de doğrudan DB 'den loglayalım
    final dbCount = await DbHelper.instance.countRecords();
    log("📦 DB toplam kayıt (sync sonrası): $dbCount", name: tag);

    // ----------------------------------------------------------
    // 3️⃣ CSV → JSON (her zaman güncel üret)
    // ----------------------------------------------------------
    await createJsonFromAssetCsv();

    // ----------------------------------------------------------
    // 4️⃣ CSV → Excel (her zaman güncel üret)
    // ----------------------------------------------------------
    await createExcelFromAssetCsvSyncfusion();

    // ----------------------------------------------------------
    // 5️⃣ Raporlama & Benchmark (şimdilik süre değerleri 0)
    // ----------------------------------------------------------
    await runFullDataReport(
      csvToJsonMs: 0,
      jsonToSqlMs: 0,
      totalPipelineMs: 0,
      insertDurations: const [],
    );

    // ----------------------------------------------------------
    // 6️⃣ ZIP oluştur (JSON + CSV + XLSX + SQL)
    // ----------------------------------------------------------
    final zipOut = await createZipArchive(
      outputDir: directory.path,
      files: backupFiles,
    );

    // ----------------------------------------------------------
    // 7️⃣ Notification göster (ZIP yolu ile birlikte)
    // ----------------------------------------------------------
    if (!context.mounted) return;

    showCreateDbNotification(
      context,
      jsonFull,
      csvFull,
      excelFull,
      sqlFull,
      zipOut,
      // extraMessage:
      //     "CSV↔SQL Sync → +${syncResult.inserted} insert, "
      //     "+${syncResult.updated} update, "
      //     "Toplam DB: $dbCount",
    );

    sw.stop();
    log(
      "✅ initializeAppDataFlow tamamlandı: ${sw.elapsedMilliseconds} ms",
      name: tag,
    );
    log(logLine, name: tag);
  } finally {
    // Banner her durumda kapatılsın
    bannerCtrl.close();
  }
}
