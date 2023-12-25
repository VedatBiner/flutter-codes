/// <----- firestore.dart ----->

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreService {
  final CollectionReference words =
      FirebaseFirestore.instance.collection("kelimeler");

  Future<void> addWord(
      BuildContext context, String sirpca, String turkce) async {
    var result = await words.where("sirpca", isEqualTo: sirpca).get();

    if (result.docs.isEmpty) {
      try {
        await words.add({
          "sirpca": sirpca,
          "turkce": turkce,
        });
      } catch (e) {
        print("Error adding word: $e");
      }
    } else {
      Fluttertoast.showToast(
        msg: "Bu kelime zaten var",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.red,
        fontSize: 16,
      );
    }
  }

  Stream<QuerySnapshot<Object?>> getWordsStream() {
    final wordsStream = words
        .orderBy(
          "sirpca",
          descending: false,
        )
        .snapshots();
    return wordsStream;
  }

  Future<void> updateWord(
    String docId,
    String sirpcaKelime,
    String turkceKelime,
  ) async {
    try {
      await words.doc(docId).update({
        "sirpca": sirpcaKelime,
        "turkce": turkceKelime,
      });
    } catch (e) {
      print("Error updating word: $e");
    }
  }

  Future<void> deleteWord(String docId) async {
    try {
      await words.doc(docId).delete();
    } catch (e) {
      print("Error deleting word: $e");
    }
  }

  Future<DocumentSnapshot<Object?>> getWordById(String docId) async {
    return await words.doc(docId).get();
  }
}


























