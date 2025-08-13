// 📃 <----- word_actions.dart ----->
//
// kelime güncelleme ve silme metodu
//
// Bu sürümde:
// - SQLite bağımlılıkları kaldırıldı.
// - Firestore işlemleri için WordService kullanılıyor.
// - Başarılı güncelle/sil sonrası YEREL JSON CACHE (mobil: Documents/*.json, web: localStorage)
//   güncelleniyor ki fihrist görünümü ve hızlı açılış senaryosu tutarlı kalsın.
//
// Cache güncelleme mantığı:
// - Güncelle: id ile bul → yoksa (oldSirpca + userEmail) veya (sirpca + userEmail) ile bul → replace et.
// - Sil: id ile bulup sil → yoksa (sirpca + userEmail) ile bulup sil.
// - Ardından Sırpça'ya göre sıralayıp yaz.
//
// Not: Arama/görünüm tazelemesi için parent’tan gelen onUpdated/onDeleted callback’leri çağrılır.

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../constants/serbian_alphabet.dart';
import '../constants/text_constants.dart';
import '../models/word_model.dart';
import '../services/local_cache_service.dart';
import '../services/notification_service.dart';
import '../services/word_service.dart';
import '../utils/confirmation_dialog.dart';
import '../widgets/word_dialog.dart';

// İçeride kullanım için küçük Sırpça karşılaştırıcı (fihrist sırası)
int _compareSerbian(String a, String b) {
  int i = 0;
  while (i < a.length && i < b.length) {
    final ai = serbianAlphabet.indexOf(a[i].toUpperCase());
    final bi = serbianAlphabet.indexOf(b[i].toUpperCase());
    if (ai != bi) return ai.compareTo(bi);
    i++;
  }
  return a.length.compareTo(b.length);
}

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
    // 🔹 Firestore üzerinde güncelle
    await WordService.instance.updateWord(
      updated,
      userEmail: updated.userEmail,
      oldSirpca: word.sirpca, // sirpca değişmiş olabilir
    );

    // 🔹 Yerel JSON CACHE güncelle
    final cached = await LocalCacheService.readAll();

    // 1) Önce id ile dene
    int idx = -1;
    if (updated.id != null && updated.id!.isNotEmpty) {
      idx = cached.indexWhere((w) => w.id == updated.id);
    }
    // 2) id bulunamadıysa eski sirpca + userEmail ya da yeni sirpca + userEmail ile dene
    if (idx < 0) {
      idx = cached.indexWhere(
        (w) =>
            (w.sirpca == word.sirpca && w.userEmail == word.userEmail) ||
            (w.sirpca == updated.sirpca && w.userEmail == updated.userEmail),
      );
    }

    if (idx >= 0) {
      cached[idx] = updated;
    } else {
      // cache’te yoksa ekleyelim (senkron bozulmasın)
      cached.add(updated);
    }

    // Sırpça’ya göre sırala ve yaz
    cached.sort((a, b) => _compareSerbian(a.sirpca, b.sirpca));
    await LocalCacheService.writeAll(cached);

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
    // 🔹 Firestore silme
    await WordService.instance.deleteWord(word, userEmail: word.userEmail);

    // 🔹 Yerel JSON CACHE’ten çıkar
    final cached = await LocalCacheService.readAll();

    // 1) id ile silmeyi dene
    int idx = -1;
    if (word.id != null && word.id!.isNotEmpty) {
      idx = cached.indexWhere((w) => w.id == word.id);
    }
    // 2) id yoksa (sirpca + userEmail) ile arayıp sil
    if (idx < 0) {
      idx = cached.indexWhere(
        (w) => w.sirpca == word.sirpca && w.userEmail == word.userEmail,
      );
    }

    if (idx >= 0) {
      cached.removeAt(idx);
      // tekrar sırala ve yaz (opsiyonel ama tutarlılık için güzel)
      cached.sort((a, b) => _compareSerbian(a.sirpca, b.sirpca));
      await LocalCacheService.writeAll(cached);
    }

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
