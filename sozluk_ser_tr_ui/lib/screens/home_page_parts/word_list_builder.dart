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

    return Column(
      children: [
        // LanguageSelector(
        //   firstLanguageCode: firstLanguageCode,
        //   firstLanguageText: firstLanguageText,
        //   secondLanguageCode: secondLanguageCode,
        //   secondLanguageText: secondLanguageText,
        //   isListView: isListView,
        //   onIconPressed: () {}, // İkon basıldığında yapılacak işlev
        //   onLanguageChange: () {
        //     // Dil değişimini burada işleyelim
        //     // Eğer Sırpça ise Türkçe, Türkçe ise Sırpça olarak değiştiriyoruz
        //     final newLanguage = firstLanguageText == "Sırpça" ? "Türkçe" : "Sırpça";
        //     // Şimdi dil değişimi işlevini çağırarak ThemeProvider 'a bilgi gönderelim
        //     Provider.of<ThemeProvider>(context, listen: false).toggleLanguage();
        //   },
        // ),
        Expanded(
          child: ListView.builder(
            itemCount: mergedResults.length,
            itemBuilder: (context, index) {
              final word = mergedResults[index];
              return buildWordTile(
                context: context,
                word: word,
                isListView: isListView,
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
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    final wordWidget = isListView
        ? WordListView(
      word: word,
      isDarkMode: isDarkMode,
    )
        : WordCardView(
      word: word,
      isDarkMode: isDarkMode,
      language: languageParams.firstLanguageText,
    );

    return wordWidget;
  }
}
