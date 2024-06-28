import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../models/fs_words.dart';
import '../../services/firebase_services/auth_services.dart';
import '../../services/firebase_services/firestore_services.dart';
import '../../utils/snackbar_helper.dart';
import 'add_word_box.dart';

/// Yeni kelime ekleme kutusu buradan çıkıyor
Widget buildCenter(
  TextEditingController firstLanguageController,
  TextEditingController secondLanguageController,
  email,
  language,
  BuildContext context,
  String firstLanguageText,
  String secondLanguageText,
  FirestoreService firestoreService,
  VoidCallback refreshWordList,
  Future<List<QuerySnapshot<FsWords>>> Function() fetchWordList,
    void Function(Future<List<QuerySnapshot<FsWords>>>) updateWordListFuture,
) {
  TextEditingController tempLanguageController;
  String tempLanguageText;

  if (language) {
    tempLanguageController = secondLanguageController;
    firstLanguageController = secondLanguageController;
    firstLanguageText = secondLanguageText;
    secondLanguageController = firstLanguageController;
    secondLanguageText = firstLanguageText;
  } else {
    tempLanguageController = firstLanguageController;
    tempLanguageText = firstLanguageText;
    firstLanguageController = secondLanguageController;
    firstLanguageText = secondLanguageText;
    secondLanguageController = tempLanguageController;
    secondLanguageText = tempLanguageText;
  }

  return Center(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16.0),
          child: AddWordBox(
            firstLanguageText: yardimciDil,
            secondLanguageText: anaDil,
            currentUserEmail: email,
            language: language,
            onWordAdded: (
              String firstLang,
              String secondLang,
              String email,
            ) async {
              await firestoreService.addWord(
                context,
                language == true ? firstLang : secondLang,
                language == true ? secondLang : firstLang,
                email,
              );
              refreshWordList();
              updateWordListFuture(fetchWordList());
              var message = addMsg;
              ScaffoldMessenger.of(context).showSnackBar(
                buildSnackBar(
                  firstLang,
                  message,
                  MyAuthService.currentUserEmail,
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    ),
  );
}
