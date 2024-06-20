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
import '../../services/providers/theme_provider.dart';
import '../../models/language_params.dart';

class WordListBuilder extends StatefulWidget {
  final List<QuerySnapshot<FsWords>> snapshot;
  final bool isListView;
  final bool language;
  final LanguageParams languageParams;

  const WordListBuilder({
    super.key,
    required this.snapshot,
    required this.isListView,
    required this.language,
    required this.languageParams,
  });

  @override
  State<WordListBuilder> createState() => _WordListBuilderState();
}

class _WordListBuilderState extends State<WordListBuilder> {
  List<FsWords> mergedResults = [];

  @override
  Widget build(BuildContext context) {
    final serbianResults =
        widget.snapshot[0].docs.map((doc) => doc.data()).toList();
    final turkishResults =
        widget.snapshot[1].docs.map((doc) => doc.data()).toList();

    /// mergedResults listesini sadece ilk oluşturulduğunda doldur.
    if (mergedResults.isEmpty) {
      mergedResults = [...serbianResults, ...turkishResults];
    }

    /// Dilin her iki yöne de belirlenmesi
    final languageParams = Provider.of<LanguageParams>(context);

    final displayedLanguage = widget.language
        ? languageParams.secondLanguageText
        : languageParams.firstLanguageText;
    final translatedLanguage = widget.language
        ? languageParams.firstLanguageText
        : languageParams.secondLanguageText;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: mergedResults.length,
            itemBuilder: (context, wordIndex) {
              final word = mergedResults[wordIndex];
              return buildWordTile(
                context: context,
                word: word,
                isListView: widget.isListView,
                language: widget.language,
                displayedLanguage: displayedLanguage,
                translatedLanguage: translatedLanguage,
                onDelete: () {
                  setState(
                    () {
                      mergedResults.remove(word);
                    },
                  );
                },
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
    required bool language,
    required String displayedLanguage,
    required String translatedLanguage,
    required VoidCallback onDelete,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    /// Dil kontrolü ve kelimenin doğru dilde gösterilmesi
    final languageParams = Provider.of<LanguageParams>(context);
    final displayedTranslation = translatedLanguage;

    /// Sırpça - Türkçe olunca sorun yok
    /// Sırpça - Türkçe durumuna göre Card ve List
    /// görünümü burada belirleniyor.
    final firstLanguageText = language
        ? (displayedLanguage == languageParams.firstLanguageText
            ? word.sirpca
            : word.turkce)
        : (displayedLanguage == languageParams.firstLanguageText
            ? word.turkce
            : word.sirpca);
    final secondLanguageText = language
        ? (displayedLanguage == languageParams.firstLanguageText
            ? word.turkce
            : word.sirpca)
        : (displayedLanguage == languageParams.firstLanguageText
            ? word.sirpca
            : word.turkce);

    final wordWidgetChild = isListView
        ? WordListView(
            word: word,
            isDarkMode: isDarkMode,
            displayedTranslation: displayedTranslation,
            displayedLanguage: displayedLanguage,
            firstLanguageText: firstLanguageText,
            secondLanguageText: secondLanguageText,
          )
        : WordCardView(
            word: word,
            isDarkMode: isDarkMode,
            displayedTranslation: displayedTranslation,
            displayedLanguage: displayedLanguage,
            firstLanguageText: firstLanguageText,
            secondLanguageText: secondLanguageText,
            onDelete: () {
              setState(() {
                /// silinen kelimeyi listeden çıkartalım
                mergedResults.remove(word);
              });
            },
          );

    return ChangeNotifierProvider.value(
      value: languageParams,
      child: wordWidgetChild,
    );
  }
}
