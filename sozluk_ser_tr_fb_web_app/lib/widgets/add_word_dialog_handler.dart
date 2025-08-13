// 📃 <----- add_word_dialog_handler.dart ----->
// Kelime varsa mesaj verip uyarıyor
// Kelime yoksa hem Firestore 'a ekliyor + YEREL JSON CACHE'i güncelliyor
//
// Notlar:
// - Var mı kontrolü: WordService.wordExists(sirpca, userEmail)
// - Ekleme: WordService.addWord -> dönen docId ile modeli copyWith(id)
// - Cache: LocalCacheService.readAll / writeAll
//   * Aynı (sirpca + userEmail) varsa replace edilir (dup önlenir)
//   * Sırpça'ya göre sıralanır (serbian_alphabet)
//
// Bu handler sadece **ekleme** akışını yönetir; UI tazelemesi için
// parent'tan gelen onWordAdded() callback'i çağrılır.

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

import '../constants/serbian_alphabet.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/text_constants.dart';
import '../models/word_model.dart';
import '../services/local_cache_service.dart';
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

  if (result == null) return;

  // 1) Aynı (sirpca + userEmail) var mı?
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

  // 2) Firestore'a ekle → id döner
  final newId = await WordService.instance.addWord(result);
  final created = result.copyWith(id: newId);

  // 3) Yerel JSON cache'i güncelle (mobil: Documents/*.json, web: localStorage)
  final cached = await LocalCacheService.readAll();

  // (sirpca + userEmail) anahtarına göre varsa replace, yoksa ekle
  final idx = cached.indexWhere(
    (w) => w.sirpca == created.sirpca && w.userEmail == created.userEmail,
  );
  if (idx >= 0) {
    cached[idx] = created;
  } else {
    cached.add(created);
  }

  // Sırpça'ya göre sıralama
  cached.sort((a, b) {
    int i = 0;
    final aS = a.sirpca;
    final bS = b.sirpca;
    while (i < aS.length && i < bS.length) {
      final ai = serbianAlphabet.indexOf(aS[i].toUpperCase());
      final bi = serbianAlphabet.indexOf(bS[i].toUpperCase());
      if (ai != bi) return ai.compareTo(bi);
      i++;
    }
    return aS.length.compareTo(bS.length);
  });

  await LocalCacheService.writeAll(cached);

  // 4) UI tarafına haber ver
  onWordAdded();

  if (!context.mounted) return;

  // 5) Bildirim
  NotificationService.showCustomNotification(
    context: context,
    title: 'Kelime Ekleme İşlemi',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: created.sirpca, style: kelimeAddText),
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
