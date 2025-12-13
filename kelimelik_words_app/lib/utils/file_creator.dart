// 📃 <----- lib/utils/file_creator.dart ----->
//
// Incremental Sync + JSON + Excel + Download kopyalama
// -----------------------------------------------------------
// Yeni akış:
//   1️⃣ Asset CSV → Device CSV senkronizasyonu
//      (createOrUpdateDeviceCsvFromAsset)
//   2️⃣ CSV ↔ SQL Incremental Sync (syncCsvWithDatabase)
//       • Eksik kelimeler eklenir
//       • Anlamı değişen kelimeler güncellenir
//       • Kullanıcının eklediği kelimeler SİLİNMEZ
//   3️⃣ CSV → JSON (her zaman yeniden oluşturulur)
//   4️⃣ CSV → Excel (her zaman yeniden oluşturulur)
//   5️⃣ Benchmark raporu (fc_report.dart)
//   6️⃣ Tüm dosyaları Download/{appName} dizinine kopyalama
//   7️⃣ Notification gösterme
// -----------------------------------------------------------

import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../widgets/bottom_banner_helper.dart';
import '../widgets/show_notification_handler.dart';
import 'external_copy.dart';
import 'fc_files/csv_helper.dart';
import 'fc_files/excel_helper.dart';
import 'fc_files/fc_report.dart';
import 'fc_files/json_helper.dart';
import 'fc_files/sync_helper.dart';

const tag = "file_creator";

Future<void> initializeAppDataFlow(BuildContext context) async {
  final sw = Stopwatch()..start();
  log("🚀 initializeAppDataFlow başladı", name: tag);

  // 📂 Uygulamanın Documents dizini (GEÇİCİ üretim alanı)
  final dir = await getApplicationDocumentsDirectory();

  // 🔹 Bu dosyalar SADECE burada üretilir
  final jsonFull = join(dir.path, fileNameJson);
  final csvFull = join(dir.path, fileNameCsv);
  final excelFull = join(dir.path, fileNameXlsx);
  final sqlFull = join(dir.path, fileNameSql);

  if (!context.mounted) return;

  final bannerCtrl = showLoadingBanner(
    context,
    message: "Lütfen bekleyiniz,\nveriler senkronize ediliyor...",
  );

  try {
    // ----------------------------------------------------------
    // 1️⃣ Asset CSV → Device CSV senkronizasyonu
    // ----------------------------------------------------------
    final csvSync = await createOrUpdateDeviceCsvFromAsset();
    log("📄 CSV Sync: changed=${csvSync.needsRebuild}", name: tag);

    // ----------------------------------------------------------
    // 2️⃣ CSV ↔ SQL Incremental Sync
    // ----------------------------------------------------------
    await syncCsvWithDatabase();

    // ----------------------------------------------------------
    // 3️⃣ CSV → JSON (güncel dosya)
    // ----------------------------------------------------------
    await createJsonFromAssetCsv();

    // ----------------------------------------------------------
    // 4️⃣ CSV → Excel (güncel dosya)
    // ----------------------------------------------------------
    await createExcelFromAssetCsvSyncfusion();

    // ----------------------------------------------------------
    // 5️⃣ Benchmark + Tutarlılık Raporu
    // ----------------------------------------------------------
    await runFullDataReport(
      csvToJsonMs: 0,
      jsonToSqlMs: 0,
      totalPipelineMs: 0,
      insertDurations: const [],
    );

    // ----------------------------------------------------------
    // 6️⃣ Download/{appName} dizinine KOPYALA
    // ⚠️ Uygulama içi klasör OLUŞTURULMAZ
    // ----------------------------------------------------------
    await copyBackupToDownload(
      files: [jsonFull, csvFull, excelFull, sqlFull],
      folderName: appName, // kelimelik_words_app
    );

    // ----------------------------------------------------------
    // 7️⃣ Notification göster
    // ----------------------------------------------------------
    if (!context.mounted) return;

    showCreateDbNotification(
      context,
      sqlFull,
      csvFull,
      excelFull,
      jsonFull,
      '', // ZIP artık yok
    );

    sw.stop();
    log(
      "✅ initializeAppDataFlow tamamlandı: ${sw.elapsedMilliseconds} ms",
      name: tag,
    );
  } finally {
    bannerCtrl.close();
  }
}
