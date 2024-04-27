/// <----- word_list_builder.dart ----->
/// Kelime listesini oluşturmak için bu kod kullanılıyor.
/// Oluşturulan kelimeler word_card_view.dart dosyasına
/// veya word_list_view.dart dosyasına gönderilerek
/// istenen formatta görünüm elde ediliyor.
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
              final translatedLanguage = wordIndex < serbianResults.length
                  ? targetLanguage
                  : currentLanguage;
              return buildWordTile(
                context: context,
                word: word,
                isListView: isListView,
                displayedLanguage: displayedLanguage,
                translatedLanguage: translatedLanguage,
              );
            },
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
    final displayedTranslation = translatedLanguage;

    final wordWidget = isListView
        ? WordListView(
            word: word,
            isDarkMode: isDarkMode,
            displayedTranslation: displayedTranslation,
            displayedLanguage: displayedLanguage,
            firstLanguageText:
            languageParams.firstLanguageText == displayedTranslation
                ? word.sirpca
                : word.turkce,
            secondLanguageText:
            languageParams.secondLanguageText == displayedLanguage
                ? word.turkce
                : word.sirpca,
          )
        : WordCardView(
            word: word,
            isDarkMode: isDarkMode,
            displayedTranslation: displayedTranslation,
            displayedLanguage: displayedLanguage,
            firstLanguageText:
                languageParams.firstLanguageText == displayedTranslation
                    ? word.sirpca
                    : word.turkce,
            secondLanguageText:
                languageParams.secondLanguageText == displayedLanguage
                    ? word.turkce
                    : word.sirpca,
          );

    return wordWidget;
  }
}
