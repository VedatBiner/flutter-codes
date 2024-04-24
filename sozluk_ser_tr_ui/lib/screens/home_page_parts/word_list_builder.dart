/// <----- word_list_builder.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../screens/home_page_parts/word_card_view.dart';
import '../../screens/home_page_parts/word_list_view.dart';
import '../../models/fs_words.dart';
import '../../services/theme_provider.dart';

class WordListBuilder extends StatelessWidget {
  final List<QuerySnapshot<FsWords>> snapshot;
  final bool isListView;
  final String firstLanguageText;

  const WordListBuilder({
    super.key,
    required this.snapshot,
    required this.isListView,
    required this.firstLanguageText,
  });

  @override
  Widget build(BuildContext context) {
    final serbianResults = snapshot[0].docs.map((doc) => doc.data());
    final turkishResults = snapshot[1].docs.map((doc) => doc.data());
    final mergedResults = [...serbianResults, ...turkishResults];

    return ListView.builder(
      itemCount: mergedResults.length,
      itemBuilder: (context, index) {
        final word = mergedResults[index];
        return buildWordTile(
          context: context,
          word: word,
          isListView: isListView,
        );
      },
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

        /// Liste görünümü
        ? WordListView(word: word, isDarkMode: isDarkMode)

        /// Card Görünümü
        : WordCardView(
            word: word,
            isDarkMode: isDarkMode,
          );

    return wordWidget;
  }
}
