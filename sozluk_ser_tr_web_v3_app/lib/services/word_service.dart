// 📃 <----- word_service.dart ----->
//
// Bu sınıf, kelime ekleme, silme ve güncelleme işlemlerini
// Firestore için yönetir. (İleride SQLite tarafı eklenebilir.)
// Ayrıca tek seferlik okuma yardımcısı : readWordsOnce().
// + wordExists(sirpca, {excludeId}) eklendi.

import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/file_info.dart';
import '../models/word_model.dart';

class WordService {
  /// Firestore koleksiyon referansı (Map tabanlı)
  static CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection(collectionName);

  /// -----------------------------------------------------------------
  /// 📌 Verilen Sırpça kelime Firestore'da var mı?
  ///  - Basit eşitlik kontrolü (case-sensitive): where('sirpca', isEqualTo: sirpca)
  ///  - Düzenleme senaryosu için `excludeId` verilirse o belge hariç tutulur.
  /// -----------------------------------------------------------------
  static Future<bool> wordExists(String sirpca, {String? excludeId}) async {
    final key = sirpca.trim();
    if (key.isEmpty) return false;

    try {
      if (excludeId == null || excludeId.isEmpty) {
        // En ucuz yol: sadece sayım (aggregate)
        final agg = await _col.where('sirpca', isEqualTo: key).count().get();
        return agg.count! > 0;
      } else {
        // Belirli bir id'yi hariç tutmak için dokümanları çekip filtreliyoruz
        final snap = await _col.where('sirpca', isEqualTo: key).get();
        return snap.docs.any((d) => d.id != excludeId);
      }
    } catch (e, st) {
      log('⚠️ wordExists hata: $e', error: e, stackTrace: st);
      return false;
    }
  }

  /// -----------------------------------------------------------------
  /// 📌 Firestore 'a yeni kelime ekler
  ///  - id yoksa Firestore otomatik üretir.
  ///  - createdAt/updatedAt server timestamp olarak set edilir.
  /// -----------------------------------------------------------------
  static Future<void> addWord(Word word) async {
    try {
      await _col.add({
        ...word.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      log('✅ "${word.sirpca}" kelimesi Firestore ’a eklendi.');
    } catch (e, st) {
      log('❌ Firestore ekleme hatası: $e', error: e, stackTrace: st);
    }
    await _logTotals();
  }

  /// -----------------------------------------------------------------
  /// 📌 Firestore 'dan kelimeyi siler
  ///  - Tercihen `id` verilmişse doğrudan o belge silinir.
  ///  - `id` yoksa `sirpca` eşleşen TÜM belgeler silinir (dikkat!).
  /// -----------------------------------------------------------------
  static Future<void> deleteWord(Word word) async {
    try {
      if (word.id != null && word.id!.isNotEmpty) {
        await _col.doc(word.id!).delete();
        log('🗑️ "${word.sirpca}" (id: ${word.id}) silindi.');
      } else {
        final snap = await _col.where('sirpca', isEqualTo: word.sirpca).get();
        for (final d in snap.docs) {
          await d.reference.delete();
        }
        log('🗑️ "${word.sirpca}" için ${snap.docs.length} kayıt silindi.');
      }
    } catch (e, st) {
      log('❌ Firestore silme hatası: $e', error: e, stackTrace: st);
    }
    await _logTotals();
  }

  /// -----------------------------------------------------------------
  /// 📌 Firestore 'da kelimeyi günceller
  ///  - `id` varsa direkt o belge güncellenir.
  ///  - `id` yoksa `oldSirpca` (verilirse) ya da `word.sirpca` ile
  ///    eşleşen belgeler güncellenir.
  ///  - updatedAt server timestamp olarak set edilir.
  /// -----------------------------------------------------------------
  static Future<void> updateWord(Word word, {String? oldSirpca}) async {
    try {
      final data = {
        ...word.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (word.id != null && word.id!.isNotEmpty) {
        await _col.doc(word.id!).update(data);
        log('✏️ "${word.sirpca}" (id: ${word.id}) güncellendi.');
      } else {
        final key = (oldSirpca == null || oldSirpca.isEmpty)
            ? word.sirpca
            : oldSirpca;

        final snap = await _col.where('sirpca', isEqualTo: key).get();
        for (final d in snap.docs) {
          await d.reference.update(data);
        }
        log('✏️ "$key" için ${snap.docs.length} kayıt güncellendi.');
      }
    } catch (e, st) {
      log('❌ Firestore güncelleme hatası: $e', error: e, stackTrace: st);
    }
    await _logTotals();
  }

  /// -----------------------------------------------------------------
  /// 📖 Tek seferlik okuma (özet)
  /// 1) withConverter<Word> ile tipli referans kurar.
  /// 2) Aggregate count ile toplam belge sayısını log’lar.
  /// 3) İlk belgeyi örnek olarak log’lar.
  /// 4) UI’da göstermek üzere kısa bir durum metni döndürür.
  /// -----------------------------------------------------------------
  static Future<String> readWordsOnce() async {
    try {
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
        // log(
        //   '🔎 Örnek: ${w.id} -> ${w.sirpca} ➜ ${w.turkce} (userEmail: ${w.userEmail})',
        //   name: collectionName,
        // );
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

  /// -----------------------------------------------------------------
  /// 🔧 YARDIMCI: Firestore ’daki toplam kayıt sayısını logla
  ///  - Aggregate count ile performanslı sayım
  /// -----------------------------------------------------------------
  static Future<void> _logTotals() async {
    try {
      final agg = await _col.count().get();
      log('📊 Toplam kayıt — Firestore: ${agg.count}');
    } catch (e, st) {
      log(
        '⚠️ Toplam kayıt sayısı alınırken hata: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// listeli okuma

  static Future<List<Word>> fetchAllWords({int pageSize = 2000}) async {
    final ref = FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<Word>(
          fromFirestore: Word.fromFirestore,
          toFirestore: (w, _) => w.toFirestore(),
        );

    final List<Word> out = [];
    Query<Word> base = ref.orderBy('sirpca').orderBy(FieldPath.documentId);

    String? lastSirpca;
    String? lastId;

    while (true) {
      var q = base.limit(pageSize);
      if (lastSirpca != null && lastId != null) {
        q = q.startAfter([lastSirpca, lastId]);
      }

      final snap = await q.get();
      if (snap.docs.isEmpty) break;

      for (final d in snap.docs) {
        out.add(d.data());
      }

      final last = snap.docs.last;
      lastSirpca = last.data().sirpca;
      lastId = last.id;

      if (snap.docs.length < pageSize) break;
    }

    return out;
  }
}
