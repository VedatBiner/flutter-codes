import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants/color_constants.dart';
import '../../models/fs_words.dart';
import '../../services/firebase_services/firestore_services.dart';
import '../../services/providers/theme_provider.dart';
import 'build_center.dart';

/// FAB ile kelime ekleme işlemi burada yapılıyor
Widget buildFloatingActionButton(
  BuildContext context,
  String email,
  bool language,
  String firstLanguageText,
  String secondLanguageText,
  FirestoreService firestoreService,
  VoidCallback refreshWordList,
  Future<List<QuerySnapshot<FsWords>>> Function() fetchWordList,
  void Function(Future<List<QuerySnapshot<FsWords>>>) updateWordListFuture,
) {
  final TextEditingController firstLanguageController = TextEditingController();
  final TextEditingController secondLanguageController =
      TextEditingController();

  /// theme kontrolü
  final themeProvider = Provider.of<ThemeProvider>(context);
  return FloatingActionButton(
    backgroundColor:
        themeProvider.isDarkMode ? Colors.green.shade900 : drawerColor,
    foregroundColor: menuColor,
    onPressed: () {
      log("Kelime ekleme seçildi");

      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (
          BuildContext buildContext,
          Animation animation,
          Animation secondaryAnimation,
        ) {
          return buildCenter(
            firstLanguageController,
            secondLanguageController,
            email,
            language,
            context,
            firstLanguageText,
            secondLanguageText,
            firestoreService,
            refreshWordList,
            fetchWordList,
            updateWordListFuture,
          );
        },
      );
    },
    child: const Icon(Icons.add),
  );
}
