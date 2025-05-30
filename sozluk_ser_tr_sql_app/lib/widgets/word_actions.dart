// 📃 <----- word_actions.dart ----->
// kelime güncelleme ve silme metodu
//
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../models/word_model.dart';
import '../services/word_service.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/notification_service.dart';
import '../widgets/word_dialog.dart';

// 📜 kelime güncelleme metodu
//
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
    // 🔹 SQLite ve Firestore üzerinde güncelle
    await WordDatabase.instance.updateWord(updated);
    await WordService.updateWord(updated);

    if (!context.mounted) return;
    onUpdated();

    NotificationService.showCustomNotification(
      context: context,
      title: 'Kelime Güncellendi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: updated.sirpca, style: kelimeAddText),
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

// 📜 kelime silme metodu
//
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
          TextSpan(text: word.sirpca, style: kelimeText),
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
    // 🔹 SQLite silme – id null ise sirpca’dan bul
    if (word.id != null) {
      await WordDatabase.instance.deleteWord(word.id!);
    } else {
      final dbWord = await WordDatabase.instance.getWord(word.sirpca);
      if (dbWord != null) {
        await WordDatabase.instance.deleteWord(dbWord.id!);
      }
    }

    // 🔹 Firestore silme
    await WordService.deleteWord(word);

    if (!context.mounted) return;
    onDeleted();

    NotificationService.showCustomNotification(
      context: context,
      title: 'Kelime Silindi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: word.sirpca, style: kelimeText),
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
