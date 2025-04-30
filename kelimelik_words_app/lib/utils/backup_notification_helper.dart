// 📃 lib/utils/backup_notification_helper.dart
//
// 1️⃣  İç (app_flutter) kopya
// 2️⃣  Dış “Downloads/kelimelik_words” kopya  ➜  izin varsa
// 3️⃣  Sonuç yollarını kısa dosya-adı şeklinde bildirimde göster
//
// ———————————————————————————————————————————————————————

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/text_constants.dart';
import '../widgets/notification_service.dart';
import 'csv_backup_helper.dart';
import 'json_backup_helper.dart';
import 'storage_permission_helper.dart'; // ⬅️ yeni

/// 📌 JSON + CSV yedeği oluşturur ve kullanıcıya bildirim gösterir.
/// Dönen değer: (tamJsonYolu, tamCsvYolu)
Future<(String, String)> createAndNotifyBackup(BuildContext context) async {
  /* 🔑  Linter uyarısı olmasın diye context ’i hemen sakla */
  final rootCtx = Navigator.of(context, rootNavigator: true).context;

  /* 1️⃣  Uygulama-içi yedekler  ─────────────────────────── */
  final jsonPathInApp = await createJsonBackup();
  final csvPathInApp = await createCsvBackup();

  /* 2️⃣  Downloads/kelimelik_words kopyası (izin varsa) ─── */
  String jsonPathDownload = '-';
  String csvPathDownload = '-';

  try {
    if (Platform.isAndroid && await ensureStoragePermission()) {
      Directory? downloadsDir = await getDownloadsDirectory();
      downloadsDir ??= await getExternalStorageDirectory();
      downloadsDir ??= await getApplicationDocumentsDirectory();

      final backupDir = Directory(p.join(downloadsDir.path, 'kelimelik_words'));
      await backupDir.create(recursive: true);

      jsonPathDownload = p.join(backupDir.path, 'kelimelik_backup.json');
      csvPathDownload = p.join(backupDir.path, 'kelimelik_backup.csv');

      await File(jsonPathInApp).copy(jsonPathDownload);
      await File(csvPathInApp).copy(csvPathDownload);

      log('✅  Download kopyaları oluşturuldu.');
    } else {
      log('⚠️  Depolama izni alınamadı – Download kopyası atlandı.');
    }
  } catch (e) {
    log('⚠️  Download dizinine kopyalanamadı: $e');
    jsonPathDownload = '-';
    csvPathDownload = '-';
  }

  /* 3️⃣  Bildirim  ──────────────────────────────────────── */
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
            const TextSpan(text: '\n\nDownloads :\n', style: kelimeAddText),
            TextSpan(text: p.basename(jsonPathDownload)),
            const TextSpan(text: '  •  '),
            TextSpan(text: p.basename(csvPathDownload)),
          ],
        ),
      ),
      icon: Icons.download_for_offline_outlined,
      iconColor: Colors.green,
      progressIndicatorColor: Colors.green,
      progressIndicatorBackground: Colors.green.shade100,
    );
  });

  return (jsonPathDownload, csvPathDownload);
}
