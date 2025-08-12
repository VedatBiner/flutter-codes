// 📃 <----- word_actions.dart ----->
// kelime güncelleme ve silme metodu

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../models/word_model.dart';
import '../services/notification_service.dart';
import '../services/word_service.dart';
import '../utils/confirmation_dialog.dart';
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
    // 🔹 Firestore üzerinde güncelle (id yoksa sirpca+userEmail ile bulunur)
    await WordService.instance.updateWord(
      updated,
      userEmail: updated.userEmail,
      oldSirpca: word.sirpca, // sirpca değişmişse eşleşme için
    );

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
      progressIndicatorBackground: Colors.greenAccent,
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
    // 🔹 Firestore silme (id varsa id ile; yoksa sirpca+userEmail ile)
    await WordService.instance.deleteWord(word, userEmail: word.userEmail);

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
      progressIndicatorBackground: Colors.redAccent,
    );
  }
}
