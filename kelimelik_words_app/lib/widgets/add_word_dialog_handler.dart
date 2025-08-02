// 📃 <----- add_word_dialog.dart ----->
// Kelime varsa mesaj verip uyarıyor
// Kelime yoksa listeye ekliyor.

import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
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
    barrierDismissible: false,
    builder: (_) => const WordDialog(),
  );

  if (result != null) {
    final existing = await DbHelper.instance.getWord(result.word);

    if (existing != null) {
      /// ✅ Eğer kelime zaten varsa: Uyarı bildirimi göster
      if (!context.mounted) return;

      /// 📌 Notification göster - Kelime var
      ///
      NotificationService.showCustomNotification(
        context: context,
        title: 'Uyarı Mesajı',
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

    await DbHelper.instance.insertRecord(result);
    onWordAdded();

    /// ✅ Başarılı ekleme bildirimi göster
    if (!context.mounted) return;

    /// 📌 Notification göster - Kelime eklendi
    ///
    NotificationService.showCustomNotification(
      context: context,
      title: 'Kelime Ekleme İşlemi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: result.word, style: kelimeAddText),
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
