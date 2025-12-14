// 📃 <----- lib/utils/file_creator.dart ----->
//
// Incremental Sync + JSON + Excel (ZIP YOK)
// -----------------------------------------------------------
// HEDEF DİZİN (TEK VE SABİT):
//   aa.vb.kelimelik_words_app/app_flutter/kelimelik_backups
//
// AKIŞ:
//   1️⃣ Asset CSV → Device CSV senkronizasyonu
//   2️⃣ CSV ↔ SQL Incremental Sync
//   3️⃣ CSV → JSON
//   4️⃣ CSV → Excel (formatlı)
//   5️⃣ Dosyaları kelimelik_backups dizinine kopyala
//   6️⃣ Notification göster
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../widgets/bottom_banner_helper.dart';
import '../widgets/show_notification_handler.dart';
import 'fc_files/csv_helper.dart';
import 'fc_files/excel_helper.dart';
import 'fc_files/fc_report.dart';
import 'fc_files/json_helper.dart';
import 'fc_files/sync_helper.dart';

const tag = "file_creator";

Future<void> initializeAppDataFlow(BuildContext context) async {
  final sw = Stopwatch()..start();
  log("🚀 initializeAppDataFlow başladı", name: tag);

  // ----------------------------------------------------------
  // 📂 app_flutter dizini
  // ----------------------------------------------------------
  final appDir = await getApplicationDocumentsDirectory();

  // ----------------------------------------------------------
  // 📦 SADECE TEK BACKUP DİZİNİ
  // ----------------------------------------------------------
  final backupDir = Directory(join(appDir.path, 'kelimelik_backups'));

  if (!await backupDir.exists()) {
    await backupDir.create(recursive: true);
  }

  log("📂 Backup dizini: ${backupDir.path}", name: tag);

  // ----------------------------------------------------------
  // 📄 Hedef dosyalar (TEK YER)
  // ----------------------------------------------------------
  final csvTarget = join(backupDir.path, fileNameCsv);
  final jsonTarget = join(backupDir.path, fileNameJson);
  final excelTarget = join(backupDir.path, fileNameXlsx);
  final sqlTarget = join(backupDir.path, fileNameSql);

  if (!context.mounted) return;

  final bannerCtrl = showLoadingBanner(
    context,
    message: "Lütfen bekleyiniz,\nyedek hazırlanıyor...",
  );

  try {
    // ----------------------------------------------------------
    // 1️⃣ CSV senkronizasyonu
    // ----------------------------------------------------------
    await createOrUpdateDeviceCsvFromAsset();

    // ----------------------------------------------------------
    // 2️⃣ CSV ↔ SQL Incremental Sync
    // ----------------------------------------------------------
    await syncCsvWithDatabase();

    // ----------------------------------------------------------
    // 3️⃣ CSV → JSON
    // ----------------------------------------------------------
    await createJsonFromAssetCsv();

    // ----------------------------------------------------------
    // 4️⃣ CSV → Excel (formatlı)
    // ----------------------------------------------------------
    await createExcelFromAssetCsvSyncfusion();

    // ----------------------------------------------------------
    // 5️⃣ RAPOR
    // ----------------------------------------------------------
    await runFullDataReport(
      csvToJsonMs: 0,
      jsonToSqlMs: 0,
      totalPipelineMs: 0,
      insertDurations: const [],
    );

    // ----------------------------------------------------------
    // 6️⃣ DOSYALARI SADECE kelimelik_backups DİZİNİNE KOPYALA
    // ----------------------------------------------------------
    Future<void> copyIfExists(String from, String to) async {
      final f = File(from);
      if (await f.exists()) {
        await f.copy(to);
        log("✅ Kopyalandı: $to", name: tag);
      }
    }

    await copyIfExists(join(appDir.path, fileNameCsv), csvTarget);
    await copyIfExists(join(appDir.path, fileNameJson), jsonTarget);
    await copyIfExists(join(appDir.path, fileNameXlsx), excelTarget);
    await copyIfExists(join(appDir.path, fileNameSql), sqlTarget);

    // ----------------------------------------------------------
    // 7️⃣ Notification
    // ----------------------------------------------------------
    if (!context.mounted) return;

    showCreateDbNotification(
      context,
      sqlTarget,
      csvTarget,
      excelTarget,
      jsonTarget,
      "", // ZIP YOK
    );

    sw.stop();
    log(
      "✅ initializeAppDataFlow tamamlandı: ${sw.elapsedMilliseconds} ms",
      name: tag,
    );
  } catch (e, st) {
    log("❌ initializeAppDataFlow hatası: $e", name: tag, stackTrace: st);
    rethrow;
  } finally {
    bannerCtrl.close();
  }

  // 7️⃣ Download dizinine kopyala + temp klasörü sil
  await copyBackupsToDownloadAndCleanup();
}

Future<void> copyBackupsToDownloadAndCleanup() async {
  // 📂 app_flutter dizini
  final docsDir = await getApplicationDocumentsDirectory();

  // 📦 Geçici backup dizini
  final tempBackupDir = Directory(join(docsDir.path, 'kelimelik_backups'));

  if (!await tempBackupDir.exists()) return;

  // 📥 Download hedefi
  final downloadDir = Directory(
    '/storage/emulated/0/Download/kelimelik_words_app',
  );

  if (!await downloadDir.exists()) {
    await downloadDir.create(recursive: true);
  }

  // 🔄 Dosyaları kopyala
  final files = tempBackupDir.listSync().whereType<File>();

  for (final file in files) {
    final targetPath = join(downloadDir.path, basename(file.path));
    await file.copy(targetPath);
  }

  // 🧹 Geçici dizini TAMAMEN sil
  await tempBackupDir.delete(recursive: true);
}
