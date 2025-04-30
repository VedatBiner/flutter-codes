// 📃 <----- backup_notification_helper.dart ----->
//
// Tek adımda:
//   1) createJsonBackup & createCsvBackup yardımcılarını çağırır,
//   2) yolları döner, 3) kök context ile Toast gösterir.
//
// Kullanım (örnek – Drawer içinde):
//
//   onTap: () async {
//     await createAndNotifyBackup(context);
//     Navigator.of(context).maybePop();
//   },

import 'package:flutter/material.dart';

import '../constants/text_constants.dart';
import '../utils/csv_backup_helper.dart';
import '../utils/json_backup_helper.dart';
import '../widgets/notification_service.dart';

/// 📌 JSON + CSV yedeği oluşturur ve kullanıcıya bildirim gösterir.
///
/// * [context] → Bulunduğunuz widget context ’i (Drawer, sayfa vb.).
/// * Dönen değer, (`jsonPath`, `csvPath`) ikilisidir.
Future<(String, String)> createAndNotifyBackup(BuildContext context) async {
  /// 1️⃣  Yedekleri oluştur
  final jsonPath = await createJsonBackup(context);
  final csvPath = await createCsvBackup(context);

  /// 2️⃣  Kök context – MediaQuery / Overlay garanti olsun
  final rootCtx = Navigator.of(context, rootNavigator: true).context;

  /// 3️⃣  Elegant Notification
  WidgetsBinding.instance.addPostFrameCallback((_) {
    NotificationService.showCustomNotification(
      context: rootCtx,
      title: 'JSON/CSV Yedeği Oluşturuldu',
      message: RichText(
        text: TextSpan(
          children: [
            const TextSpan(text: "JSON yedeği : ", style: kelimeAddText),
            TextSpan(text: ' $jsonPath', style: normalBlackText),
            const TextSpan(text: "\nCSV yedeği : ", style: kelimeAddText),
            TextSpan(text: ' $csvPath', style: normalBlackText),
          ],
        ),
      ),
      icon: Icons.download,
      iconColor: Colors.blue,
      progressIndicatorColor: Colors.blue,
      progressIndicatorBackground: Colors.blue.shade100,
    );
  });

  return (jsonPath, csvPath);
}
