// 📃 <----- show_word_dialog_handler.dart ----->

import 'dart:developer';

import 'package:flutter/material.dart';

import '../constants/text_constants.dart';
import '../models/word_model.dart';
import '../services/notification_service.dart';
import '../services/word_service.dart';
import '../widgets/body_widgets/edit_word_dialog.dart';
import '../widgets/word_dialog.dart';

/// ADD: Yeni kelime ekleme diyaloğu (var olan kodun)
Future<void> showWordDialogHandler(
  BuildContext context,
  VoidCallback onWordAdded,
) async {
  final result = await showDialog<Word>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const WordDialog(),
  );

  if (result != null) {
    /// ❓Kelime varsa bildirim göster
    final exists = await WordService.wordExists(result.sirpca);
    if (exists) {
      if (!context.mounted) return;
      NotificationService.showCustomNotification(
        context: context,
        title: 'Uyarı Mesajı',
        message: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: result.sirpca, style: kelimeExistText),
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

    /// 📌 Kelime yoksa ekle
    await WordService.addWord(result);
    log('Kelime eklendi: ${result.sirpca}', name: 'ADD_WORD');

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

/// 📌 Var olan kelimeyi güncelle
Future<void> showEditWordDialogHandler(
  BuildContext context, {
  required Word word,
  required Future<void> Function() onRefetch,
}) async {
  final ok = await editWordDialog(
    context: context,
    word: word,
    onRefetch: onRefetch, // güncelleme ve refetch içeride
  );

  if (!context.mounted || !ok) return;

  // ✅ Bildirim artık burada
  NotificationService.showCustomNotification(
    context: context,
    title: 'Kelime Güncelleme İşlemi',
    message: RichText(
      text: TextSpan(
        children: [
          // Not: editWordDialog true/false döndürüyor, burada eski kelime adını gösteriyoruz.
          // İstersen updated kelime adını da döndürtecek şekilde dialogu değiştirebilirsin.
          TextSpan(text: word.sirpca, style: kelimeUpdateText),
          const TextSpan(
            text: ' kelimesi güncellenmiştir',
            style: normalBlackText,
          ),
        ],
      ),
    ),
    icon: Icons.check_circle,
    iconColor: Colors.green.shade700,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade200,
  );
}
