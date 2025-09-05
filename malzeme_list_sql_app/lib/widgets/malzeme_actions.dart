// 📃 <----- malzeme_actions.dart ----->
//
// malzeme güncelleme ve silme metodu
// eski word_actions.dart
//

import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../models/malzeme_model.dart';
import '../services/notification_service.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/malzeme_dialog.dart';

/// 📌 malzeme güncelleme metodu
///
Future<void> editWord({
  required BuildContext context,
  required Malzeme word,
  required VoidCallback onUpdated,
}) async {
  final updated = await showDialog<Malzeme>(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        MalzemeDialog(malzeme: word), // ✅ doğru parametre adı: malzeme
  );

  if (updated != null) {
    await DbHelper.instance.updateRecord(updated);
    if (!context.mounted) return;
    onUpdated();

    NotificationService.showCustomNotification(
      context: context,
      title: 'Malzeme Güncellendi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: updated.malzeme, style: kelimeAddText),
            const TextSpan(
              text: ' malzemesi güncellendi.',
              style: normalBlackText,
            ),
          ],
        ),
      ),
      icon: Icons.check_circle,
      iconColor: Colors.green,
      progressIndicatorColor: Colors.green,
      progressIndicatorBackground: Colors.green.shade100,
    );
  }
}

/// 📌 malzeme silme metodu
///
Future<void> confirmDelete({
  required BuildContext context,
  required Malzeme word,
  required VoidCallback onDeleted,
}) async {
  final confirm = await showConfirmationDialog(
    context: context,
    title: 'Malzemeyi Sil',
    content: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: word.malzeme, style: kelimeText),
          const TextSpan(
            text: ' malzemesini silmek istiyor musunuz?',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    ),
    confirmText: 'Sil',
    cancelText: 'İptal',
    confirmColor: deleteButtonColor,
  );

  if (confirm == true) {
    await DbHelper.instance.deleteRecord(word.id!);
    if (!context.mounted) return;
    onDeleted();

    NotificationService.showCustomNotification(
      context: context,
      title: 'Malzeme Silindi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: word.malzeme, style: kelimeText),
            const TextSpan(text: ' malzemesi silindi.', style: normalBlackText),
          ],
        ),
      ),
      icon: Icons.delete,
      iconColor: Colors.red,
      progressIndicatorColor: Colors.red,
      progressIndicatorBackground: Colors.red.shade100,
    );
  }
}
