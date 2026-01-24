// 📃 <----- lib/widgets/show_notification_handler.dart ----->

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';

import '../constants/text_constants.dart';
import '../services/notification_service.dart';

void showBackupNotification(
  BuildContext context,
  String jsonPath,
  String csvPath,
  String excelPath,
) {
  ElegantNotification.success(
    title: const Text("Yedekleme Başarılı"),
    description: Text(
      "Aşağıdaki dosyalar oluşturuldu:\n\n"
      "• $jsonPath\n"
      "• $csvPath\n"
      "• $excelPath",
    ),
    onDismiss: () {},
  ).show(context);
}

void showShareFilesNotification(BuildContext rootCtx) {
  return NotificationService.showCustomNotification(
    context: rootCtx,
    title: ' ',
    message: RichText(
      text: const TextSpan(
        style: normalBlackText,
        children: [
          TextSpan(
            text: '\nDosyalar paylaşılmıştır ... \n\n',
            style: kelimeAddText,
          ),
        ],
      ),
    ),
    icon: Icons.download_for_offline_outlined,
    iconColor: Colors.green,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade100,
    width: 260,
    height: 200,
  );
}