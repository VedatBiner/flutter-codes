/// <----- firestore_services.dart ----->
library;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/app_constants/constants.dart';
import 'auth_services.dart';

class FirestoreService {
  final CollectionReference words =
  FirebaseFirestore.instance.collection("kelimeler");

  Future<void> addWord(
      BuildContext context,
      String ikinciDil,
      String birinciDil,
      String userEmail,
      ) async {
    /// eklenecek kelimelerin baş harfleri
    /// büyük harfe çevriliyor
    ikinciDil = ikinciDil[0].toUpperCase() + ikinciDil.substring(1);
    birinciDil = birinciDil[0].toUpperCase() + birinciDil.substring(1);

    /// login olan kullanıcının email adresini al
//    log("firestore_services.dart => user email : ${MyAuthService.currentUserEmail}");

    try {
      var result = await words.where(fsYardimciDil, isEqualTo: ikinciDil).get();

      /// kelime veri tabanında varsa ekleme
      if (result.docs.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "Bu kelime zaten var",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.red,
          fontSize: 16,
        );
        return;
      }

      /// kelime veri tabanında yoksa ekle
      await words.add({
        fsYardimciDil: ikinciDil,
        fsAnaDil: birinciDil,
        fsUserEmail: MyAuthService.currentUserEmail,
      });
      log("Bu kelime, ${MyAuthService.currentUserEmail} tarafından eklenmiştir.");
    } catch (e) {
      log("Error adding word: $e");
    }
  }

  /// Alfabetik sıralama için kullanılan servis metodu
  Stream<QuerySnapshot<Object?>> getWordsStream(String firstLanguageText) {
    Query query;
    if (firstLanguageText == anaDil) {
      query = words.orderBy(fsAnaDil);
    } else {
      query = words.orderBy(fsYardimciDil);
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
      String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
      await words.doc(docId).update({
        fsYardimciDil: ikinciDilKelime,
        fsAnaDil: birinciDilKelime,
        fsUserEmail: userEmail,
      });
      print("kelimeyi güncelleyen kullanıcı : $userEmail");
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

  /// Firestore 'dan id belli olan kelimeyi çekmek için kullanılıyor
  Future<DocumentSnapshot<Object?>> getWordById(String docId) async {
    return await words.doc(docId).get();
  }

  /// tüm koleksiyon belgelerine yeni alan ekle
  /// örneğin mail adresi ekledik
  Future<void> addFieldToAllDocuments(
      String fieldName, dynamic fieldValue) async {
    try {
      // Tüm belgeleri al
      QuerySnapshot querySnapshot = await words.get();

      // Tüm belgeler için döngü oluştur
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // Güncellenmiş alanın değeri
        Map<String, dynamic> newData = {
          fieldName: fieldValue, // Yeni alan ve değeri
        };

        // Firestore belgesini güncelle
        await words.doc(document.id).update(newData);
      }

      print('Tüm belgelere yeni alan eklendi.');
    } catch (e) {
      print("Error adding field to all documents: $e");
    }
  }
}