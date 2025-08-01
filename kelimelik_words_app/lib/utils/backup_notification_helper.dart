// 📃 lib/utils/backup_notification_helper.dart
//
// 1️⃣  Uygulama-içi JSON, CSV, Excel yedekleri oluşturur
// 2️⃣  (İzin varsa) Downloads/kelimelik_words altına JSON, CSV & Excel kopyalar
// 3️⃣  Bildirimde sadece dosya-adlarını gösterir

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/text_constants.dart';
import '../widgets/notification_service.dart';
import 'csv_backup_helper.dart';
import 'excel_backup_helper.dart';
import 'json_backup_helper.dart';
import 'storage_permission_helper.dart';

/// 📌 JSON + CSV + Excel yedeği oluşturur ve kullanıcıya bildirir.
/// Dönen değer: (downloadsJsonPath, downloadsCsvPath, downloadsExcelPath)
Future<(String, String, String)> createAndNotifyBackup(
  BuildContext context,
) async {
  /// 🔍 Metodun gerçekten çağrıldığını görmek için hemen bir log atalım
  log(
    '🔄 backup_notification_helper çalıştı',
    name: 'Backup Notification Helper',
  );

  /// 🔑 Linter uyarısı olmasın diye root context ’i hemen alıyoruz
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

      final backupDir = Directory(p.join(downloadsDir.path, 'kelimelik_words'));
      await backupDir.create(recursive: true);

      /// JSON
      jsonPathDownload = p.join(backupDir.path, 'kelimelik_backup.json');
      await File(jsonPathInApp).copy(jsonPathDownload);

      /// CSV
      csvPathDownload = p.join(backupDir.path, 'kelimelik_backup.csv');
      await File(csvPathInApp).copy(csvPathDownload);

      /// Excel
      excelPathDownload = p.join(backupDir.path, 'kelimelik_backup.xlsx');
      await File(excelPathInApp).copy(excelPathDownload);

      log(
        '✅ Downloads kopyaları oluşturuldu:',
        name: 'Backup Notification Helper',
      );
      log('   • JSON: $jsonPathDownload', name: 'Backup Notification Helper');
      log('   • CSV:   $csvPathDownload', name: 'Backup Notification Helper');
      log('   • Excel: $excelPathDownload', name: 'Backup Notification Helper');
    } else {
      log(
        '⚠️ Depolama izni alınamadı – Downloads kopyası atlandı.',
        name: 'BackupHelper',
      );
    }
  } catch (e) {
    log('⚠️ Downloads dizinine kopyalanamadı: $e', name: 'BackupHelper');
    jsonPathDownload = '-';
    csvPathDownload = '-';
    excelPathDownload = '-';
  }

  /// 3️⃣ Bildirim: sadece dosya adlarını göster
  WidgetsBinding.instance.addPostFrameCallback((_) {
    NotificationService.showCustomNotification(
      context: rootCtx,
      title: 'Yedek Oluşturuldu',
      message: RichText(
        text: TextSpan(
          style: normalBlackText,
          children: [
            const TextSpan(text: 'Uygulama içi :\n', style: kelimeAddText),
            TextSpan(text: p.basename(jsonPathInApp)),
            const TextSpan(text: '  •  '),
            TextSpan(text: p.basename(csvPathInApp)),
            const TextSpan(text: '  •  '),
            TextSpan(text: p.basename(excelPathInApp)),
            const TextSpan(text: '\n\nDownloads :\n', style: kelimeAddText),
            TextSpan(text: p.basename(jsonPathDownload)),
            const TextSpan(text: '  •  '),
            TextSpan(text: p.basename(csvPathDownload)),
            const TextSpan(text: '  •  '),
            TextSpan(text: p.basename(excelPathDownload)),
          ],
        ),
      ),
      icon: Icons.download_for_offline_outlined,
      iconColor: Colors.green,
      progressIndicatorColor: Colors.green,
      progressIndicatorBackground: Colors.green.shade100,
    );
  });

  return (jsonPathDownload, csvPathDownload, excelPathDownload);
}
