/// <----- word_list_view.dart ----->
/// Kelime listesini ListView olarak göstermek için
/// bu kod kullanılıyor.
/// kelime bilgileri word_list_builder.dart dosyasından geliyor.
library;

import 'package:flutter/material.dart';
import 'dart:developer';

import '../../constants/app_constants/constants.dart';
import '../../constants/app_constants/color_constants.dart';
import '../../models/fs_words.dart';
import '../details_page.dart';

class WordListView extends StatefulWidget {
  final FsWords word;
  final bool isDarkMode;
  final String displayedLanguage;
  final String displayedTranslation;
  final String firstLanguageText;
  final String secondLanguageText;
  final List<FsWords> mergedResults;
  final bool language;

  const WordListView({
    super.key,
    required this.word,
    required this.isDarkMode,
    required this.displayedLanguage,
    required this.displayedTranslation,
    required this.firstLanguageText,
    required this.secondLanguageText,
    required this.mergedResults,
    required this.language,
  });

  @override
  State<WordListView> createState() => _WordListViewState();
}

class _WordListViewState extends State<WordListView> {
  @override
  Widget build(BuildContext context) {
    log("===> 15-word_list_view.dart dosyası çalıştı. >>>>>>>");
    log("----------------------------------------------------");
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: InkWell(
        onTap: () {
          log("word : ${widget.word.sirpca}");
          log("word : ${widget.word.turkce}");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(
                wordList: widget.mergedResults,
                initialWord: widget.word,
                language: widget.language,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.displayedLanguage == anaDil
                        ? widget.firstLanguageText ?? ""
                        : widget.secondLanguageText ?? "",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color:
                          widget.isDarkMode ? cardDarkModeText1 : cardLightModeText1,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.displayedTranslation == yardimciDil
                        ? widget.secondLanguageText ?? ""
                        : widget.firstLanguageText ?? "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color:
                          widget.isDarkMode ? cardDarkModeText2 : cardLightModeText2,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: widget.isDarkMode ? Colors.white60 : Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
