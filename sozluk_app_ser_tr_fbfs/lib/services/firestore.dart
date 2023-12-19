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
    return words.doc(docId).update({
      "sirpca": sirpcaKelime,
      "turkce": turkceKelime,
    });
  }

  /// DELETE : delete word given a doc id
  Future<void> deleteWord(String docId) {
    return words.doc(docId).delete();
  }
}
