// 📃 <----- word_service.dart ----->
//
// Bu sınıf, kelime ekleme/silme/güncelleme ve listeleme/arama işlemlerini
// sadece Firestore üzerinde yönetir. (SQLite bağımlılıkları kaldırılmıştır.)
//
// Özellikler:
// - addWord / updateWord / deleteWord
// - getById
// - streamAll (canlı liste akışı)
// - searchTurkcePrefix (prefix arama)
// - countTotals (toplam sayım, destek varsa aggregate count)
// - userEmail filtrelemesi ile çok kullanıcılı güvenli kullanım
//
// Notlar:
// - Kimlik çakışmalarını önlemek için sorgularda 'userEmail' filtresi kullanılır.
// - 'turkce' alanında prefix arama için orderBy('turkce') + startAt/endAt kullanılır.
//   Gerekirse Firestore, Console üzerinden otomatik index isteyebilir.
//

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/word_model.dart';

class WordService {
  WordService._();
  static final instance = WordService._();

  static const String _collectionName = 'kelimeler';
  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection(_collectionName);

  // ---------------------------------------------------------------------------
  // CREATE
  // ---------------------------------------------------------------------------
  /// Yeni kelime ekler. Doküman id'si Firestore tarafından oluşturulur.
  /// Dönüş: Oluşan doküman id'si
  Future<String> addWord(Word word) async {
    try {
      final data = word.toMap(); // {sirpca, turkce, userEmail}
      final docRef = await _col.add(data);
      log("✅ Firestore: '${word.turkce}' eklendi. (id=${docRef.id})");
      return docRef.id;
    } catch (e, st) {
      log("❌ Firestore ekleme hatası: $e", stackTrace: st);
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // READ
  // ---------------------------------------------------------------------------
  /// Dokümanı id ile getirir.
  Future<Word?> getById(String id) async {
    try {
      final snap = await _col.doc(id).get();
      if (!snap.exists) return null;
      return Word.fromMap(snap.data()!, id: snap.id);
    } catch (e, st) {
      log("❌ Firestore getById hatası: $e", stackTrace: st);
      rethrow;
    }
  }

  /// Canlı liste akışı. İsteğe bağlı userEmail filtresi + limit.
  Stream<List<Word>> streamAll({
    String? userEmail,
    int limit = 500,
    String orderByField = 'turkce',
  }) {
    Query<Map<String, dynamic>> q = _col.orderBy(orderByField).limit(limit);
    if (userEmail != null && userEmail.isNotEmpty) {
      q = q.where('userEmail', isEqualTo: userEmail);
    }
    return q.snapshots().map(
      (s) => s.docs.map((d) => Word.fromMap(d.data(), id: d.id)).toList(),
    );
  }

  /// Türkçe alanında prefix arama (örn. 'kit' -> 'kitap', 'kitaplık' ...).
  /// Çok kullanıcılı kullanım için 'userEmail' filtrelemesi önerilir.
  Stream<List<Word>> searchTurkcePrefix(
    String query, {
    String? userEmail,
    int limit = 50,
  }) {
    if (query.isEmpty) {
      // Boş arama: streamAll döndür
      return streamAll(userEmail: userEmail, limit: limit);
    }
    final end = '$query\uf8ff';

    Query<Map<String, dynamic>> q = _col
        .orderBy('turkce')
        .startAt([query])
        .endAt([end])
        .limit(limit);
    if (userEmail != null && userEmail.isNotEmpty) {
      // Dikkat: İki farklı orderBy/where kombinasyonu için composite index isteyebilir.
      q = q.where('userEmail', isEqualTo: userEmail);
    }

    return q.snapshots().map(
      (s) => s.docs.map((d) => Word.fromMap(d.data(), id: d.id)).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // UPDATE
  // ---------------------------------------------------------------------------
  /// Güncelleme: id varsa doğrudan id ile; yoksa (oldSirpca veya word.sirpca) + userEmail ile bulup günceller.
  Future<void> updateWord(
    Word word, {
    required String userEmail,
    String? oldSirpca,
  }) async {
    try {
      final data = word.toMap();

      if (word.id != null && word.id!.isNotEmpty) {
        await _col.doc(word.id!).update(data);
        log("✏️ Firestore: '${word.turkce}' (id=${word.id}) güncellendi.");
        return;
      }

      // id yoksa: eski sirpca (veya mevcut sirpca) + userEmail ile ara
      final keySirpca = (oldSirpca ?? word.sirpca);
      final q = await _col
          .where('userEmail', isEqualTo: userEmail)
          .where('sirpca', isEqualTo: keySirpca)
          .limit(5)
          .get();

      if (q.docs.isEmpty) {
        log(
          "ℹ️ Güncellenecek kayıt bulunamadı (sirpca=$keySirpca, userEmail=$userEmail).",
        );
        return;
      }

      // Birden fazla eşleşme varsa hepsini günceller (isteğe göre ilkini güncelleyebilirsin)
      for (final doc in q.docs) {
        await doc.reference.update(data);
      }
      log(
        "✏️ Firestore: '$keySirpca' eşleşmeleri güncellendi (${q.docs.length} adet).",
      );
    } catch (e, st) {
      log("❌ Firestore güncelleme hatası: $e", stackTrace: st);
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------
  /// Silme: id varsa doğrudan id ile; yoksa sirpca + userEmail ile tüm eşleşenleri siler.
  Future<void> deleteWord(Word word, {required String userEmail}) async {
    try {
      if (word.id != null && word.id!.isNotEmpty) {
        await _col.doc(word.id!).delete();
        log("🗑️ Firestore: '${word.turkce}' (id=${word.id}) silindi.");
        return;
      }

      // id yoksa: sirpca + userEmail ile ara
      final q = await _col
          .where('userEmail', isEqualTo: userEmail)
          .where('sirpca', isEqualTo: word.sirpca)
          .get();

      if (q.docs.isEmpty) {
        log(
          "ℹ️ Silinecek kayıt bulunamadı (sirpca=${word.sirpca}, userEmail=$userEmail).",
        );
        return;
      }

      final batch = FirebaseFirestore.instance.batch();
      for (final doc in q.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      log(
        "🗑️ Firestore: '${word.sirpca}' eşleşmeleri silindi (${q.docs.length} adet).",
      );
    } catch (e, st) {
      log("❌ Firestore silme hatası: $e", stackTrace: st);
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // EXISTS / COUNT
  // ---------------------------------------------------------------------------
  /// Aynı (sirpca, userEmail) kombinasyonunda kayıt var mı?
  Future<bool> wordExists({
    required String sirpca,
    required String userEmail,
  }) async {
    try {
      final q = await _col
          .where('userEmail', isEqualTo: userEmail)
          .where('sirpca', isEqualTo: sirpca)
          .limit(1)
          .get();
      return q.docs.isNotEmpty;
    } catch (e, st) {
      log("❌ Firestore wordExists hatası: $e", stackTrace: st);
      rethrow;
    }
  }

  /// Toplam kayıt sayısı (destek varsa aggregate count, yoksa fallback).
  Future<int?> countTotals({String? userEmail}) async {
    try {
      Query<Map<String, dynamic>> q = _col;
      if (userEmail != null && userEmail.isNotEmpty) {
        q = q.where('userEmail', isEqualTo: userEmail);
      }

      // Aggregate count (yeni SDK'larda mevcut)
      try {
        final aggSnap = await q.count().get();
        final total = aggSnap.count;
        log('📊 Firestore toplam: $total (userEmail=${userEmail ?? "-"})');
        return total;
      } catch (_) {
        // Fallback: normal get + size
        final snap = await q.get();
        final total = snap.size;
        log(
          '📊 Firestore toplam (fallback): $total (userEmail=${userEmail ?? "-"})',
        );
        return total;
      }
    } catch (e, st) {
      log('⚠️ Firestore toplam sayım hatası: $e', stackTrace: st);
      rethrow;
    }
  }
}
