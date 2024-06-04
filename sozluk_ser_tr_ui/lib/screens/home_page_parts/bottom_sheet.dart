/// <----- build_bottom_sheet.dart ----->
/// Girilen kelime sayısı burada bulunuyor
library;

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../constants/app_constants/color_constants.dart';
import '../../services/word_service.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final WordService wordService = WordService();
    log("08-bottom_sheet.dart dosyası çalıştı.");
    return Container(
      color: menuColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: StreamBuilder<int>(
        stream: wordService.getDocumentCountStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    noOfWordsEntered,
                    style: noOfWordsText,
                  ),
                  Text(
                    '${snapshot.data}',
                    style: noOfWordsCount,
                  ),
                ],
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              noOfWordsErrorMsg,
              style: baslikTextBlack,
            ),
          );
        },
      ),
    );
  }
}
