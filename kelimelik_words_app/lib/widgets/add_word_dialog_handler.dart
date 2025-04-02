// 📃 <----- add_word_dialog.dart ----->

import 'package:flutter/material.dart';

import '../db/word_database.dart';
import '../models/word_model.dart';
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
    builder: (_) => const WordDialog(),
  );

  if (result != null) {
    final existing = await WordDatabase.instance.getWord(result.word);

    if (existing != null) {
      // ✅ Eğer kelime zaten varsa: Uyarı bildirimi göster
      if (!context.mounted) return;
      NotificationService.showCustomNotification(
        context: context,
        title: 'Uyarı',
        message: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: result.word,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.orange,
                ),
              ),
              const TextSpan(
                text: ' zaten var!',
                style: TextStyle(color: Colors.black),
              ),
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

    await WordDatabase.instance.insertWord(result);
    onWordAdded();

    // ✅ Başarılı ekleme bildirimi göster
    if (!context.mounted) return;
    NotificationService.showCustomNotification(
      context: context,
      title: 'Kelime Ekleme İşlemi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: result.word,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            const TextSpan(
              text: ' kelimesi eklendi.',
              style: TextStyle(color: Colors.black),
            ),
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
