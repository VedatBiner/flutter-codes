/// <----- word_list_builder.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../screens/home_page_parts/word_card_view.dart';
import '../../screens/home_page_parts/word_list_view.dart';
import '../../models/fs_words.dart';
import '../../services/theme_provider.dart';
import '../../models/language_params.dart';

class WordListBuilder extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final serbianResults = snapshot[0].docs.map((doc) => doc.data());
    final turkishResults = snapshot[1].docs.map((doc) => doc.data());
    final mergedResults = [...serbianResults, ...turkishResults];

    /// Dilin her iki yöne de belirlenmesi
    final currentLanguage = languageParams.firstLanguageText;
    final targetLanguage = languageParams.secondLanguageText;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: mergedResults.length,
            itemBuilder: (context, wordIndex) {
              final word = mergedResults[wordIndex];
              final displayedLanguage = wordIndex < serbianResults.length
                  ? currentLanguage
                  : targetLanguage;
              return buildWordTile(
                context: context,
                word: word,
                isListView: isListView,
                displayedLanguage: displayedLanguage,
              );
            },
          ),
        ),
      ],
    );
  }

  /// kelime listesi List ve Card Görünümü
  Widget buildWordTile({
    required BuildContext context,
    required FsWords word,
    required bool isListView,
    required String displayedLanguage,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    /// Dil kontrolü ve kelimenin doğru dilde gösterilmesi
    final displayedTranslation =
        displayedLanguage == languageParams.firstLanguageText
            ? word.turkce ?? "" // Türkçe gösterilecekse
            : word.sirpca ?? ""; // Sırpça gösterilecekse

    final wordWidget = isListView
        ? WordListView(
            word: word,
            isDarkMode: isDarkMode,
          )
        : WordCardView(
            word: word,
            isDarkMode: isDarkMode,
            displayedTranslation: displayedTranslation,
            displayedLanguage: displayedLanguage,
            firstLanguageText: languageParams.firstLanguageText == displayedTranslation
              ? word.turkce
              : word.sirpca,
            secondLanguageText: languageParams.secondLanguageText == displayedLanguage
              ? word.sirpca
              : word.turkce,
          );

    print("first Language text: ${languageParams.firstLanguageText}");
    print("second Language text: ${languageParams.secondLanguageText}");
    return wordWidget;
  }
}
