import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../db/db_helper.dart';
import '../models/word_model.dart';

class WordService {
  /// 📌 Hem SQLite hem Firestore ’a ekleme
  static Future<void> addWord(Word word) async {
    // 1. SQLite ’a ekle
    await WordDatabase.instance.insertWord(word);

    // 2. Firestore ’a ekle
    try {
      await FirebaseFirestore.instance
          .collection('kelimeler')
          .add(word.toMap());
      log("✅ Firestore ’a eklendi: ${word.sirpca}");
    } catch (e) {
      log("❌ Firestore ekleme hatası: $e");
    }
  }

  // Gerekirse silme, güncelleme de eklenebilir
}
