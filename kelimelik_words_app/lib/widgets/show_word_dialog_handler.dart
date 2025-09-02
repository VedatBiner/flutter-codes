// 📃 <----- show_add_word_dialog_handler.dart ----->
// Kelime varsa mesaj verip uyarıyor
// Kelime yoksa listeye ekliyor.

import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../models/word_model.dart';
import 'notification_service.dart';
import 'word_dialog.dart';

/// 📌 Notification göster - Kelime Silindi
///
void showDeleteNotification(BuildContext context, Word word) {
  return NotificationService.showCustomNotification(
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

/// 📌 Notification göster - Kelime güncellendi
///
void showUpdateNotification(BuildContext context, Word updated) {
  return NotificationService.showCustomNotification(
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

/// 📌 Notification göster - Kelime eklendi
///
void showAddNotification(BuildContext context, Word result) {
  return NotificationService.showCustomNotification(
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

/// 📌 Notification göster - Kelime var
///
void showExistNotification(BuildContext context, Word result) {
  return NotificationService.showCustomNotification(
    context: context,
    title: 'Uyarı Mesajı',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: result.word, style: kelimeExistText),
          const TextSpan(text: ' zaten var!', style: normalBlackText),
        ],
      ),
    ),
    icon: Icons.warning_amber_rounded,
    iconColor: Colors.orange,
    progressIndicatorColor: Colors.orange,
    progressIndicatorBackground: Colors.orange.shade100,
  );
}

Future<void> showWordDialogHandler(
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
      showExistNotification(context, result);
      return;
    }

    await DbHelper.instance.insertRecord(result);
    onWordAdded();

    /// ✅ Başarılı ekleme bildirimi göster
    if (!context.mounted) return;

    /// 📌 Notification göster - Kelime eklendi
    showAddNotification(context, result);
  }
}
