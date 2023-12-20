/// <----- firestore.dart ----->

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// notes yerine words kullanıyoruz
/// koleksiyon adı kelimeler
/// kelime yerine word kullanıyoruz
/// notesStream yerine wordsStream

class FirestoreService {
  /// get collection
  final CollectionReference words =
      FirebaseFirestore.instance.collection("kelimeler");

  /// CREATE : Create a new word
  Future<void> addWord(
      BuildContext context, String sirpca, String turkce) async {
    var result = await words.where("sirpca", isEqualTo: sirpca).get();

    if (result.docs.isEmpty) {
      /// Sırpça kelime bulunamadı, ekleyebiliriz
      await FirebaseFirestore.instance.collection("kelimeler").add({
        "sirpca": sirpca,
        "turkce": turkce,
      });
    } else {
      /// Sırpça kelime zaten var, kullanıcıyı uyar
      Fluttertoast.showToast(
        msg: "Bu kelime zaten var",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.black,
        textColor: Colors.red,
        fontSize: 16,
      );
    }
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
  /// bu işlem sadece değişen bir alan için kullanılabilir.
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
