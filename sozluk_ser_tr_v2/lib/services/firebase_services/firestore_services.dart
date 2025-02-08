/// <----- firestore_services.dart ----->
library;

import 'dart:developer';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/app_constants/constants.dart';
import 'auth_services.dart';

class FirestoreService {
  final CollectionReference words =
  FirebaseFirestore.instance.collection("kelimeler");
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late ElegantNotification notification;

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

    try {
      var result = await words
          .where(fsYardimciDil, isEqualTo: ikinciDil)
          .where(fsAnaDil, isEqualTo: birinciDil)
          .get();

      /// kelime veri tabanında varsa ekleme
      if (result.docs.isNotEmpty) {

        /// Kelime var mesajı
        ElegantNotification(
          width: 360,
          stackedOptions: StackedOptions(
            key: 'left',
            type: StackedType.same,
            scaleFactor: 0.2,
            itemOffset: const Offset(-20, 10),
          ),
          toastDuration: const Duration(seconds: 5),
          position: Alignment.centerLeft,
          animation: AnimationType.fromLeft,
          title: const Text('Info'),
          description: const Text(
            'Bu kelime zaten var',
          ),
          onNotificationPressed: () {
            notification.dismiss();
          },
          showProgressIndicator: false,
          onDismiss: () {},
          icon: const Icon(
            Icons.info_outline, // Daha uygun bir ikon
            color: Colors.amber,
          ),
        ).show(context); // show() metodu çağrıldı


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

  Future<void> updateWord(String wordId, String firstLang, String secondLang) async {
    if (wordId.isEmpty) {
      throw ArgumentError('wordId must be a non-empty string');
    }

    try {
      await _db.collection('kelimeler').doc(wordId).update({
        'sirpca': firstLang,
        'turkce': secondLang,
      });
    } catch (e) {
      log('Error updating word: $e');
      rethrow;
    }
  }

  Future<void> deleteWord(String docId) async {
    if (docId.isEmpty) {
      log("firestore_services.dart");
      log("-------------------------------------");
      log("Error DocId is null or Empty : $docId");
    }
    try {
      await words.doc(docId).delete();
    } catch (e) {
      log("Error deleting word: $e");
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
      /// Tüm belgeleri al
      QuerySnapshot querySnapshot = await words.get();

      /// Tüm belgeler için döngü oluştur
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        /// Güncellenmiş alanın değeri
        Map<String, dynamic> newData = {
          fieldName: fieldValue, // Yeni alan ve değeri
        };

        /// Firestore belgesini güncelle
        await words.doc(document.id).update(newData);
      }

      log('Tüm belgelere yeni alan eklendi.');
    } catch (e) {
      log("Error adding field to all documents: $e");
    }
  }
}