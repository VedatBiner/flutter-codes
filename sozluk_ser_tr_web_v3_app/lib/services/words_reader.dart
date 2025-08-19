// <📜 ----- words_reader.dart ----->
/*
  📖 Firestore tek seferlik okuma (Word modeli ile)

  NE YAPAR?
  1) `file_info.dart` içindeki `collectionName` koleksiyonu için
     `withConverter<Word>` ile **tipli** bir referans kurar.
  2) Koleksiyonun **aggregate count** (toplam belge sayısı) değerini çeker ve `log()` yazar.
  3) İlk belgeyi örnek olarak getirir, `Word` nesnesine dönüştürür ve alanlarını `log()` eder.
  4) UI’da göstermek üzere kısa bir **durum metni** döndürür.
     - Başarılı: "Okuma tamam. Console ’a yazıldı."
     - Hata:     "Hata: <mesaj>"

  NOTLAR:
  - Bu fonksiyon yalnızca **okuma** yapar, UI/Gerçek dosya işlemleri **burada yoktur**.
  - Ağ/DNS geçici sorunları yaşarsanız (UNAVAILABLE vb.), üst katmanda retry/backoff ekleyebilirsiniz.
*/

// 📌 Dart hazır paketleri
import 'dart:developer' show log;

/// 📌 Flutter hazır paketleri
import 'package:cloud_firestore/cloud_firestore.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../models/word_model.dart';

Future<String> readWordsOnce() async {
  try {
    // Model ile tipli referans (withConverter)
    final col = FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<Word>(
          fromFirestore: Word.fromFirestore,
          toFirestore: (w, _) => w.toFirestore(),
        );

    log('📥 "$collectionName" (model) okunuyor ...', name: collectionName);

    // Aggregate count
    final agg = await col.count().get();
    log('✅ Toplam kayıt sayısı : ${agg.count}', name: collectionName);

    // Örnek belge
    final snap = await col.limit(1).get();
    if (snap.docs.isNotEmpty) {
      final Word w = snap.docs.first.data();
      log(
        '🔎 Örnek: ${w.id} -> ${w.sirpca} ➜ ${w.turkce} (userEmail: ${w.userEmail})',
        name: collectionName,
      );
    } else {
      log('ℹ️ Koleksiyonda belge yok.', name: collectionName);
    }

    return 'Okuma tamam. Console ’a yazıldı.';
  } catch (e, st) {
    log(
      '❌ Hata ($collectionName okuma): $e',
      name: collectionName,
      error: e,
      stackTrace: st,
      level: 1000,
    );
    return 'Hata: $e';
  }
}
