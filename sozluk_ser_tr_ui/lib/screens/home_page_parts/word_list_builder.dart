/// <----- word_list_builder.dart ----->
/// Kelime listesini oluşturmak için bu kod kullanılıyor.
/// Oluşturulan kelimeler word_card_view.dart dosyasına
/// veya word_list_view.dart dosyasına gönderilerek
/// istenen formatta görünüm elde ediliyor.
library;

import 'dart:developer';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../screens/home_page_parts/word_card_view.dart';
import '../../screens/home_page_parts/word_list_view.dart';
import '../../models/fs_words.dart';
import '../../services/theme_provider.dart';
import '../../models/language_params.dart';

class WordListBuilder extends StatefulWidget {
  final List<QuerySnapshot<FsWords>> snapshot;
  final bool isListView;
  final LanguageParams languageParams;

  const WordListBuilder({
    super.key,
    required this.snapshot,
    required this.isListView,
    required this.languageParams,
  });

  @override
  State<WordListBuilder> createState() => _WordListBuilderState();
}

class _WordListBuilderState extends State<WordListBuilder> {
  /// Scrollbar için controller
  ScrollController listViewController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final serbianResults =
        widget.snapshot[0].docs.map((doc) => doc.data()).toList();
    final turkishResults =
        widget.snapshot[1].docs.map((doc) => doc.data()).toList();
    final mergedResults = [...serbianResults, ...turkishResults];
    // log("Merged results : $mergedResults");
    // log("Serbian Words : $serbianResults");
    // log("Turkish Words : $turkishResults");

    /// Dilin her iki yöne de belirlenmesi
    final languageParams = Provider.of<LanguageParams>(context);
    final currentLanguage = languageParams.firstLanguageText;
    final targetLanguage = languageParams.secondLanguageText;

    return Column(
      children: [
        Expanded(
          child: DraggableScrollbar.arrows(
            alwaysVisibleScrollThumb: true,
            backgroundColor:
            Provider.of<ThemeProvider>(context).isDarkMode
                ? Colors.white
                : Colors.grey.shade800,
            controller: listViewController,
            labelTextBuilder: (double offset) => Text(
              targetLanguage,
              style: TextStyle(
                color: Provider.of<ThemeProvider>(context).isDarkMode
                    ? Colors.red
                    : Colors.blue,
              ),
            ),
            child: ListView.builder(
              controller: listViewController,
              itemCount: mergedResults.length,
              itemBuilder: (context, wordIndex) {
                final word = mergedResults[wordIndex];
                final displayedLanguage = wordIndex < serbianResults.length
                    ? currentLanguage
                    : targetLanguage;
                final translatedLanguage = wordIndex < serbianResults.length
                    ? targetLanguage
                    : currentLanguage;
                return buildWordTile(
                  context: context,
                  word: word,
                  isListView: widget.isListView,
                  displayedLanguage: displayedLanguage,
                  translatedLanguage: translatedLanguage,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// kelime listesi List ve Card görünümüne
  /// göre hangi metodun kullanılacağı burada belirleniyor
  Widget buildWordTile({
    required BuildContext context,
    required FsWords word,
    required bool isListView,
    required String displayedLanguage,
    required String translatedLanguage,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    /// Dil kontrolü ve kelimenin doğru dilde gösterilmesi
    final languageParams = Provider.of<LanguageParams>(context);
    final displayedTranslation = translatedLanguage;

    final wordWidget = isListView
        ? ChangeNotifierProvider<LanguageParams>.value(
            value: languageParams,
            child: WordListView(
              word: word,
              isDarkMode: isDarkMode,
              displayedTranslation: displayedTranslation,
              displayedLanguage: displayedLanguage,
              firstLanguageText:
                  languageParams.firstLanguageText == displayedTranslation
                      ? word.turkce
                      : word.sirpca,
              secondLanguageText:
                  languageParams.secondLanguageText == displayedLanguage
                      ? word.sirpca
                      : word.turkce,
            ),
          )
        : ChangeNotifierProvider.value(
            value: languageParams,
            child: WordCardView(
              word: word,
              isDarkMode: isDarkMode,
              displayedTranslation: displayedTranslation,
              displayedLanguage: displayedLanguage,
              firstLanguageText:
                  languageParams.firstLanguageText == displayedTranslation
                      ? word.turkce
                      : word.sirpca,
              secondLanguageText:
                  languageParams.secondLanguageText == displayedLanguage
                      ? word.sirpca
                      : word.turkce,
            ),
          );

    return wordWidget;
  }
}
