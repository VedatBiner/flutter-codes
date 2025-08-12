// 📃 <----- add_word_dialog_handler.dart ----->
//
// Kelime varsa mesaj verip uyarıyor
// Kelime yoksa Firestore'a ekliyor (SQLite kaldırıldı)

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/text_constants.dart';
import '../models/word_model.dart';
import '../services/notification_service.dart';
import '../services/word_service.dart';
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
    // 🔍 Firestore ’da aynı (sirpca, userEmail) var mı?
    final exists = await WordService.instance.wordExists(
      sirpca: result.sirpca,
      userEmail: result.userEmail,
    );

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
        progressIndicatorBackground: Colors.orangeAccent,
      );
      return;
    }

    // ✅ Yeni kelimeyi Firestore ’a ekle
    await WordService.instance.addWord(result);

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
      iconColor: Colors.blue,
      progressIndicatorColor: Colors.blue,
      progressIndicatorBackground: Colors.blueAccent,
    );
  }
}
