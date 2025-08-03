// 📃 lib/utils/backup_notification_helper.dart
//
// 1️⃣  İç (app_flutter) kopya
// 2️⃣  Dış “Downloads/sozluk_ser_tr_sql” kopya  ➜  izin varsa
// 3️⃣  Sonuç yollarını kısa dosya-adı şeklinde bildirimde göster
//
// ———————————————————————————————————————————————————————

// 📌 Flutter hazır paketleri

// 📌 Dart hazır paketleri
import 'dart:developer';
import 'dart:io';

/// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../constants/text_constants.dart';
import '../widgets/notification_service.dart';
import 'csv_backup_helper.dart';
import 'excel_backup_helper.dart';
import 'json_backup_helper.dart';
import 'storage_permission_helper.dart';

/// 📌 JSON + CSV yedeği oluşturur ve kullanıcıya bildirim gösterir.
/// Dönen değer: (tamJsonYolu, tamCsvYolu)
Future<(String, String, String)> createAndNotifyBackup(
  BuildContext context,
) async {
  /// 🔍 Metodun gerçekten çağrıldığını görmek için hemen bir log atalım
  log(
    '🔄 backup_notification_helper çalıştı',
    name: 'Backup Notification Helper',
  );

  /* 🔑  Linter uyarısı olmasın diye context ’i hemen sakla */
  final rootCtx = Navigator.of(context, rootNavigator: true).context;

  /* 1️⃣  Uygulama-içi yedekler  ─────────────────────────── */
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

  ///* 2️⃣  Downloads/sozluk_ser_tr_sql kopyası (izin varsa) ─── */
  String jsonPathDownload = '-';
  String csvPathDownload = '-';
  String excelPathDownload = '-';

  try {
    if (Platform.isAndroid && await ensureStoragePermission()) {
      Directory? downloadsDir = await getDownloadsDirectory();
      downloadsDir ??= await getExternalStorageDirectory();
      downloadsDir ??= await getApplicationDocumentsDirectory();

      final backupDir = Directory(p.join(downloadsDir.path, appName));
      await backupDir.create(recursive: true);

      /// JSON
      jsonPathDownload = p.join(backupDir.path, fileNameJson);
      await File(jsonPathInApp).copy(jsonPathDownload);

      /// CSV
      csvPathDownload = p.join(backupDir.path, fileNameCsv);
      await File(csvPathInApp).copy(csvPathDownload);

      /// Excel
      excelPathDownload = p.join(backupDir.path, 'kelimelik_backup.xlsx');
      await File(excelPathInApp).copy(excelPathDownload);

      log(
        '✅  Download kopyaları oluşturuldu.',
        name: 'Backup Notification Helper',
      );
      log('   • JSON: $jsonPathDownload', name: 'Backup Notification Helper');
      log('   • CSV:   $csvPathDownload', name: 'Backup Notification Helper');
      log('   • Excel: $excelPathDownload', name: 'Backup Notification Helper');
    } else {
      log(
        '⚠️  Depolama izni alınamadı – Download kopyası atlandı.',
        name: 'Backup Notification Helper',
      );
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

  ///* 3️⃣ Bildirim: sadece dosya adlarını göster
  WidgetsBinding.instance.addPostFrameCallback((_) {
    NotificationService.showCustomNotification(
      context: rootCtx, // ← güvenli
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
            const TextSpan(text: '  •  '),
            const TextSpan(text: '\n\nDownloads :\n', style: kelimeAddText),
            TextSpan(text: p.basename(jsonPathDownload)),
            const TextSpan(text: '  •  '),
            TextSpan(text: p.basename(csvPathDownload)),
            const TextSpan(text: '  •  '),
            TextSpan(text: p.basename(excelPathDownload)),
            const TextSpan(text: '  •  '),
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
