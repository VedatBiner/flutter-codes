// 📃 <----- word_service.dart ----->
// Bu sınıf, kelime ekleme, silme ve güncelleme işlemlerini
// hem SQLite hem Firestore için yönetir.

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../db/db_helper.dart';
import '../models/word_model.dart';

class WordService {
  /// -----------------------------------------------------------------
  /// 📌 SQLite ve Firestore 'a yeni kelime ekler
  /// -----------------------------------------------------------------
  static Future<void> addWord(Word word) async {
    /// 🔹 SQLite 'a ekle
    final rowId = await DbHelper.instance.insertRecord(word);
    log("💾 (id = $rowId): ${word.sirpca} Kelimesi, SQLite ’e eklendi.");

    // 🔄 id alanı null ise güncelle (UI ’de sonraki işlemler sorunsuz çalışır)
    if (word.id == null && rowId > 0) {
      word = word.copyWith(id: rowId); // copyWith() varsa id ’yi set et
    }

    /// 🔹 Firestore 'a ekle
    try {
      await FirebaseFirestore.instance
          .collection('kelimeler')
          .add(word.toMap());
      log("✅ ${word.sirpca} Kelimesi, Firestore ’a eklendi.");
    } catch (e) {
      log("❌ Firestore ekleme hatası: $e");
    }

    /// 🔄 Toplam sayıları logla
    await _logTotals();
  }

  /// -----------------------------------------------------------------
  /// 📌 SQLite ve Firestore 'dan kelimeyi siler (Sırpça adına göre)
  /// -----------------------------------------------------------------
  static Future<void> deleteWord(Word word) async {
    bool sqliteDeleted = false; // 🔄 silindi mi?

    /// 🔹 SQLite verisini sil
    if (word.id != null) {
      await DbHelper.instance.deleteRecord(word.id!);
      sqliteDeleted = true;
    } else {
      /// ❓ id null ise sirpca adına göre sorgula
      final dbWord = await DbHelper.instance.getWord(word.sirpca);
      if (dbWord != null) {
        await DbHelper.instance.deleteRecord(dbWord.id!);
        sqliteDeleted = true;
      }
    }

    if (sqliteDeleted) {
      log("💾 ${word.sirpca} Kelimesi, SQLite ’ten silindi.");
    }

    /// 🔹 Firestore (sirpca alanına göre eşleşeni sil)
    try {
      final query =
          await FirebaseFirestore.instance
              .collection('kelimeler')
              .where('sirpca', isEqualTo: word.sirpca)
              .get();

      for (var doc in query.docs) {
        await doc.reference.delete();
        log("🗑️ ${word.sirpca} Kelimesi, Firestore ’dan silindi.");
      }
    } catch (e) {
      log("❌ Firestore silme hatası: $e");
    }

    /// 🔄 Toplam sayıları logla
    await _logTotals();
  }

  /// -----------------------------------------------------------------
  /// 📌 SQLite ve Firestore 'da kelimeyi günceller
  /// -----------------------------------------------------------------
  static Future<void> updateWord(Word word, {required String oldSirpca}) async {
    bool sqliteUpdated = false; // 🔄 güncellendi mi?

    /// 🔹 SQLite Güncelle
    if (word.id != null) {
      await DbHelper.instance.updateRecord(word);
      sqliteUpdated = true;
    } else {
      final dbWord = await DbHelper.instance.getWord(word.sirpca);
      if (dbWord != null) {
        await DbHelper.instance.updateRecord(word.copyWith(id: dbWord.id));
        sqliteUpdated = true;
      }
    }

    if (sqliteUpdated) {
      log("💾 ${word.sirpca} Kelimesi, SQLite ’ta güncellendi.");
    }

    /// 🔹 Firestore (sirpca ’ya göre güncelleme)
    try {
      final query =
          await FirebaseFirestore.instance
              .collection('kelimeler')
              .where('sirpca', isEqualTo: oldSirpca)
              .get();

      for (var doc in query.docs) {
        await doc.reference.update(word.toMap());
      }
    } catch (e) {
      log("❌ Firestore güncelleme hatası: $e");
    }

    log("✏️ ${word.sirpca} kelimesi, Firestore ’da güncellendi.");

    /// 🔄 Toplam sayıları logla
    await _logTotals();
  }

  /// 📌 SQLite içinde bu kelime var mı? (sırpça adına göre kontrol)
  static Future<bool> wordExists(String sirpca) async {
    final word = await DbHelper.instance.getWord(sirpca);
    return word != null;
  }

  /// -----------------------------------------------------------------
  /// 🔧 YARDIMCI: Hem SQLite hem Firestore ’daki toplam kayıt sayısını logla
  /// -----------------------------------------------------------------
  static Future<void> _logTotals() async {
    try {
      /// SQLite toplamı
      final sqliteTotal = await DbHelper.instance.countRecords();

      /// Firestore toplamı (basit get — veri çoksa count aggregation kullanabilirsiniz)
      final fsSnap =
          await FirebaseFirestore.instance.collection('kelimeler').get();
      final firestoreTotal = fsSnap.size;

      log('📊 Toplam kayıt — SQLite: $sqliteTotal, Firestore: $firestoreTotal');
    } catch (e) {
      log('⚠️ Toplam kayıt sayısı alınırken hata: $e');
    }
  }
}
