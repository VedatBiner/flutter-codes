// 📃 lib/utils/backup_notification_helper.dart
//
// 1️⃣  İç (app_flutter) kopya
// 2️⃣  Dış “Downloads/malzeme” kopya  ➜  izin varsa
// 3️⃣  Sonuç yollarını kısa dosya-adı şeklinde bildirimde göster
//
// ———————————————————————————————————————————————————————

// 📌 Flutter hazır paketleri

// 📌 Flutter hazır paketleri
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../widgets/show_malzeme_dialog_handler.dart';
import 'csv_backup_helper.dart';
import 'excel_backup_helper.dart';
import 'json_backup_helper.dart';
import 'storage_permission_helper.dart'; // ⬅️ yeni

/// 📌 JSON + CSV + Excel yedeği oluşturur ve ve kullanıcıya bildirir.
/// Dönen değer: (tamJsonYolu, tamCsvYolu)
Future<(String, String, String)> backupNotificationHelper(
  BuildContext context,
) async {
  /// 🔍 Metodun gerçekten çağrıldığını görmek için hemen bir log atalım
  log(
    '🔄 backup_notification_helper çalıştı',
    name: 'Backup Notification Helper',
  );

  /* 🔑  Linter uyarısı olmasın diye context ’i hemen sakla */
  final rootCtx = Navigator.of(context, rootNavigator: true).context;

  /// 1️⃣ Uygulama-içi yedekler
  final jsonPathInApp = await createJsonBackup();
  final csvPathInApp = await createCsvBackup();
  final excelPathInApp = await createExcelBackup();

  log(
    '📤 JSON yedeği başarıyla oluşturuldu.',
    name: 'Backup Notification Helper',
  );
  log('📁 JSON Dosya yolu: $jsonPathInApp', name: 'Backup Notification Helper');

  log(
    '📤 CSV yedeği başarıyla oluşturuldu.',
    name: 'Backup Notification Helper',
  );
  log('📁 CSV dosya yolu: $csvPathInApp', name: 'Backup Notification Helper');

  log(
    '📤 Excel yedeği başarıyla oluşturuldu.',
    name: 'Backup Notification Helper',
  );
  log(
    '📁 Excel dosya yolu: $excelPathInApp',
    name: 'Backup Notification Helper',
  );

  log('✅ In-App kopyaları oluşturuldu:', name: 'Backup Notification Helper');
  log('   • JSON in-app: $jsonPathInApp', name: 'Backup Notification Helper');
  log('   • CSV  in-app: $csvPathInApp', name: 'Backup Notification Helper');
  log('   • Excel in-app: $excelPathInApp', name: 'Backup Notification Helper');

  /// 2️⃣ Downloads/kelimelik_words kopyaları (izin varsa)
  String jsonPathDownload = '-';
  String csvPathDownload = '-';
  String excelPathDownload = '-';

  try {
    if (Platform.isAndroid && await ensureStoragePermission()) {
      Directory? downloadsDir = await getDownloadsDirectory();
      downloadsDir ??= await getExternalStorageDirectory();
      downloadsDir ??= await getApplicationDocumentsDirectory();

      final backupDir = Directory(p.join(downloadsDir.path, 'malzeme'));
      await backupDir.create(recursive: true);

      /// JSON
      jsonPathDownload = p.join(backupDir.path, fileNameJson);
      await File(jsonPathInApp).copy(jsonPathDownload);

      /// CSV
      csvPathDownload = p.join(backupDir.path, fileNameCsv);
      await File(csvPathInApp).copy(csvPathDownload);

      /// Excel
      excelPathDownload = p.join(backupDir.path, 'malzeme_backup.xlsx');
      await File(excelPathInApp).copy(excelPathDownload);

      log(
        '✅  Download kopyaları oluşturuldu.',
        name: 'Backup Notification Helper',
      );
      log('   • JSON: $jsonPathDownload', name: 'Backup Notification Helper');
      log('   • CSV:   $csvPathDownload', name: 'Backup Notification Helper');
      log('   • Excel: $excelPathDownload', name: 'Backup Notification Helper');
    } else {
      log('⚠️  Depolama izni alınamadı – Download kopyası atlandı.');
    }
  } catch (e) {
    log(
      '⚠️  Download dizinine kopyalanamadı: $e',
      name: 'Backup Notification Helper',
    );
    jsonPathDownload = '-';
    csvPathDownload = '-';
    excelPathDownload = '-';
  }

  /// 3️⃣ Bildirim: sadece dosya adlarını göster
  showBackupResultNotification(
    rootCtx: rootCtx,
    jsonPathInApp: jsonPathInApp,
    csvPathInApp: csvPathInApp,
    excelPathInApp: excelPathInApp,
    jsonPathDownload: jsonPathDownload,
    csvPathDownload: csvPathDownload,
    excelPathDownload: excelPathDownload,
    width: 280,
    height: 260,
  );

  return (jsonPathDownload, csvPathDownload, excelPathDownload);
}
