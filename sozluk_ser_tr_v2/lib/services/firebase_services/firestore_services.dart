/// <----- firestore_services.dart ----->
library;

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../models/fs_words.dart';
import 'auth_services.dart';

class FirestoreService {
  final CollectionReference words =
  FirebaseFirestore.instance.collection(collectionName);
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Kelime ekleme metodu
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

  /// Kelime var mı kontrolü
  Future<bool> checkWordExists(String firstLang, String secondLang) async {
    try {
      final collection = FirebaseFirestore.instance
          .collection(collectionName)
          .withConverter<FsWords>(
        fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
        toFirestore: (word, _) => word.toJson(),
      );

      final querySnapshot = await collection
          .where(fsYardimciDil, isEqualTo: firstLang)
          .where(fsAnaDil, isEqualTo: secondLang)
          .get();

      return querySnapshot.docs.isNotEmpty; // Eğer belge varsa true, yoksa false
    } catch (e) {
      log("Hata: $e");
      return false; // Hata durumunda false döndür
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
      String wordId, String firstLang, String secondLang) async {
    if (wordId.isEmpty) {
      throw ArgumentError('wordId must be a non-empty string');
    }

    try {
      await _db.collection(collectionName).doc(wordId).update({
        fsYardimciDil: firstLang,
        fsAnaDil: secondLang,
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

  /// Firestore'dan kelimeleri çek
  Future<List<FsWords>> fetchWords() async {
    try {
      QuerySnapshot querySnapshot = await words.orderBy("sirpca").get();
      return querySnapshot.docs.map((doc) {
        return FsWords(
          wordId: doc.id,
          turkce: doc['turkce'] ?? '',
          sirpca: doc['sirpca'] ?? '',
          userEmail: doc['userEmail'],
        );
      }).toList();
    } catch (e) {
      log("Firestore'dan kelimeler çekilemedi: $e");
      return [];
    }
  }

}