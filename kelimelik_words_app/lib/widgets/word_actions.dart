// 📃 <----- word_actions.dart ----->
// kelime güncelleme ve silme metodu
//
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../models/word_model.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/notification_service.dart';
import '../widgets/word_dialog.dart';

/// 📌 kelime güncelleme metodu
///
Future<void> editWord({
  required BuildContext context,
  required Word word,
  required VoidCallback onUpdated,
}) async {
  final updated = await showDialog<Word>(
    context: context,
    barrierDismissible: false,
    builder: (_) => WordDialog(word: word),
  );

  if (updated != null) {
    await DbHelper.instance.updateRecord(updated);
    if (!context.mounted) return;
    onUpdated();

    NotificationService.showCustomNotification(
      context: context,
      title: 'Kelime Güncellendi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: updated.word, style: kelimeAddText),
            const TextSpan(
              text: ' kelimesi güncellendi.',
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

/// 📌 kelime silme metodu
///
Future<void> confirmDelete({
  required BuildContext context,
  required Word word,
  required VoidCallback onDeleted,
}) async {
  final confirm = await showConfirmationDialog(
    context: context,
    title: 'Kelimeyi Sil',
    content: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: word.word, style: kelimeText),
          const TextSpan(
            text: ' kelimesini silmek istiyor musunuz?',
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
      title: 'Kelime Silindi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: word.word, style: kelimeText),
            const TextSpan(text: ' kelimesi silindi.', style: normalBlackText),
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
