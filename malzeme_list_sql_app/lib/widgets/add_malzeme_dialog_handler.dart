// 📃 <----- add_malzeme_dialog_handler.dart ----->
//
// eski add_word_dialog_handler
// Malzeme varsa mesaj verip uyarıyor
// Malzeme yoksa listeye ekliyor.

import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../models/malzeme_model.dart';
import 'malzeme_dialog.dart';
import 'notification_service.dart';

Future<void> showAddMalzemeDialog(
  BuildContext context,
  VoidCallback onMalzemeAdded,
  VoidCallback onCancelSearch, // arama kutusunu kapatmak için
) async {
  onCancelSearch(); // arama kutusunu kapat

  final result = await showDialog<Malzeme>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const MalzemeDialog(),
  );

  if (result != null) {
    final existing = await DbHelper.instance.getWord(result.malzeme);

    if (existing != null) {
      /// ✅ Eğer malzeme zaten varsa: Uyarı bildirimi göster
      if (!context.mounted) return;

      /// 📌 Notification göster - Malzeme var
      ///
      NotificationService.showCustomNotification(
        context: context,
        title: 'Uyarı Mesajı',
        message: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: result.malzeme,
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
    onMalzemeAdded();

    /// ✅ Başarılı ekleme bildirimi göster
    if (!context.mounted) return;

    /// 📌 Notification göster - Malzeme eklendi
    ///
    NotificationService.showCustomNotification(
      context: context,
      title: 'Malzeme Ekleme İşlemi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: result.malzeme, style: kelimeAddText),
            const TextSpan(text: ' malzemesi eklendi.', style: normalBlackText),
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
