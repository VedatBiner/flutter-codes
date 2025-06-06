// 📃 <----- add_word_dialog_handler.dart ----->
// Kelime varsa mesaj verip uyarıyor
// Kelime yoksa hem SQLite 'a hem Firestore 'a ekliyor

import 'package:flutter/material.dart';

import '../constants/text_constants.dart';
import '../models/word_model.dart';
import '../services/word_service.dart'; // 👈 yeni eklendi
import 'notification_service.dart';
import 'word_dialog.dart';

Future<void> showAddWordDialog(
  BuildContext context,
  VoidCallback onWordAdded,
  VoidCallback onCancelSearch, // arama kutusunu kapatmak için
) async {
  onCancelSearch(); // arama kutusunu kapat
  final result = await showDialog<Word>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const WordDialog(),
  );

  if (result != null) {
    final exists = await WordService.wordExists(result.sirpca);

    if (exists) {
      // ✅ Eğer kelime zaten varsa: Uyarı bildirimi göster
      if (!context.mounted) return;

      NotificationService.showCustomNotification(
        context: context,
        title: 'Uyarı Mesajı',
        message: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: result.sirpca,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.orange,
                ),
              ),
              const TextSpan(text: ' zaten var!', style: normalBlackText),
            ],
          ),
        ),
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.orange,
        progressIndicatorColor: Colors.orange,
        progressIndicatorBackground: Colors.orange.shade100,
      );
      return;
    }

    // ✅ Yeni kelimeyi hem SQLite hem Firestore ’a ekle
    await WordService.addWord(result);

    onWordAdded();

    if (!context.mounted) return;

    NotificationService.showCustomNotification(
      context: context,
      title: 'Kelime Ekleme İşlemi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: result.sirpca, style: kelimeAddText),
            const TextSpan(text: ' kelimesi eklendi.', style: normalBlackText),
          ],
        ),
      ),
      icon: Icons.check_circle,
      iconColor: Colors.blue.shade700,
      progressIndicatorColor: Colors.blue,
      progressIndicatorBackground: Colors.blue.shade200,
    );
  }
}
