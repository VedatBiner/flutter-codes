/// <----- firestore.dart ----->

import 'package:cloud_firestore/cloud_firestore.dart';

/// notes yerine words kullanıyoruz
/// koleksiyon adı kelimeler
/// kelime yerine word kullanıyoruz
/// notesStream yerine wordsStream

class FirestoreService {
  /// get collection
  final CollectionReference words =
      FirebaseFirestore.instance.collection("kelimeler");

  /// CREATE : Create a new word
  Future<void> addWord(String sirpca, String turkce) {
    return words.add({
      "sirpca": sirpca,
      "turkce": turkce,
    });
  }

  /// READ : get words from database
  Stream<QuerySnapshot> getWordsStream() {
    final wordsStream = words
        .orderBy(
          "sirpca",
          descending: false,
        )
        .snapshots();
    return wordsStream;
  }

  /// UPDATE : update word given a doc id
  Future<void> updateWord(
    String docId,
    String sirpcaKelime,
    String turkceKelime,
  ) async {

    // Kullanımı
    /// Burada bir düzeltme gerekiyor ?
    bool kelimeVarMi = await isWordExists(sirpcaKelime);

    if (kelimeVarMi) {
      print('Sırpça kelime mevcut');
    } else {
      print('Sırpça kelime mevcut değil');
    }

    return words.doc(docId).update({
      "sirpca": sirpcaKelime,
      "turkce": turkceKelime,
    });
  }

  /// DELETE : delete word given a doc id
  Future<void> deleteWord(String docId) {
    return words.doc(docId).delete();
  }

  Future<bool> isWordExists(String sirpcaKelime) async {

  // Sırpça kelimeye sahip belgeleri getirin
  QuerySnapshot querySnapshot =
  await words.where('sirpca', isEqualTo: sirpcaKelime).get();

  // Belirli bir sırpça kelimenin var olup olmadığını kontrol edin
  return querySnapshot.docs.isNotEmpty;
  }

}
