/// <----- firestore.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sozluk_app_ser_tr_fbfs/constants/app_constants/constants.dart';

class FirestoreService {
  final CollectionReference words =
      FirebaseFirestore.instance.collection("kelimeler");

  Future<void> addWord(
      BuildContext context, String ikinciDil, String birinciDil) async {
    var result = await words.where(fsIkinciDil, isEqualTo: ikinciDil).get();

    if (result.docs.isEmpty) {
      try {
        await words.add({
          fsIkinciDil: ikinciDil,
          fsBirinciDil: birinciDil,
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

  /// Alfabetik sıralama için kullanılan servis metodu
  Stream<QuerySnapshot<Object?>> getWordsStream(String firstLanguageText) {
    Query query;
    if (firstLanguageText == birinciDil) {
      query = words.orderBy(fsBirinciDil);
    } else {
      query = words.orderBy(fsIkinciDil);
    }

    final wordsStream = query.snapshots();
    return wordsStream;
  }

  Future<void> updateWord(
    String docId,
    String ikinciDilKelime,
    String birinciDilKelime,
  ) async {
    try {
      await words.doc(docId).update({
        fsIkinciDil: ikinciDilKelime,
        fsBirinciDil: birinciDilKelime,
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
