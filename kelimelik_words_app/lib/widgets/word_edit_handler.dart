// 📃 <----- word_edit_handler.dart ----->
// kelime güncelleme metodu
//
import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/text_constants.dart';
import 'package:kelimelik_words_app/db/word_database.dart';
import 'package:kelimelik_words_app/models/word_model.dart';
import 'package:kelimelik_words_app/widgets/notification_service.dart';
import 'package:kelimelik_words_app/widgets/word_dialog.dart';

Future<void> handleEditWord({
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
    await WordDatabase.instance.updateWord(updated);
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
