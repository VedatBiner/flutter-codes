// 📃 <----- word_service.dart ----->
// Bu sınıf, kelime ekleme, silme ve güncelleme işlemlerini
// hem SQLite hem Firestore için yönetir.

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../db/db_helper.dart';
import '../models/word_model.dart';

class WordService {
  /// 📌 SQLite ve Firestore 'a yeni kelime ekler
  static Future<void> addWord(Word word) async {
    // 🔹 SQLite
    await WordDatabase.instance.insertWord(word);

    // 🔹 Firestore
    try {
      await FirebaseFirestore.instance
          .collection('kelimeler')
          .add(word.toMap());
      log("✅ Firestore ’a eklendi: ${word.sirpca}");
    } catch (e) {
      log("❌ Firestore ekleme hatası: $e");
    }
  }

  /// 📌 SQLite ve Firestore 'dan kelimeyi siler (Sırpça adına göre)
  static Future<void> deleteWord(Word word) async {
    /// 🔹 SQLite verisini sil
    await WordDatabase.instance.deleteWord(word.id!);

    /// 🔹 Firestore (sirpca alanına göre eşleşeni sil)
    try {
      final query =
          await FirebaseFirestore.instance
              .collection('kelimeler')
              .where('sirpca', isEqualTo: word.sirpca)
              .get();

      for (var doc in query.docs) {
        await doc.reference.delete();
        log("🗑️ Firestore ’dan silindi: ${word.sirpca}");
      }
    } catch (e) {
      log("❌ Firestore silme hatası: $e");
    }
  }

  /// 📌 SQLite ve Firestore 'da kelimeyi günceller
  static Future<void> updateWord(Word word) async {
    // 🔹 SQLite
    await WordDatabase.instance.updateWord(word);

    // 🔹 Firestore (sirpca’ya göre güncelleme)
    try {
      final query =
          await FirebaseFirestore.instance
              .collection('kelimeler')
              .where('sirpca', isEqualTo: word.sirpca)
              .get();

      for (var doc in query.docs) {
        await doc.reference.update(word.toMap());
        log("✏️ Firestore ’da güncellendi: ${word.sirpca}");
      }
    } catch (e) {
      log("❌ Firestore güncelleme hatası: $e");
    }
  }

  /// 📌 SQLite içinde bu kelime var mı? (sırpça adına göre kontrol)
  static Future<bool> wordExists(String sirpca) async {
    final word = await WordDatabase.instance.getWord(sirpca);
    return word != null;
  }
}
