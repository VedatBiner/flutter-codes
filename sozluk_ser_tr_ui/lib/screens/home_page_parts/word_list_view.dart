import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../models/fs_words.dart';

class WordListView extends StatelessWidget {
  final FsWords word;
  final bool isDarkMode;
  final String displayedLanguage;
  final String displayedTranslation;
  final String firstLanguageText;
  final String secondLanguageText;

  const WordListView({
    super.key,
    required this.word,
    required this.isDarkMode,
    required this.displayedLanguage,
    required this.displayedTranslation,
    required this.firstLanguageText,
    required this.secondLanguageText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  displayedLanguage == birinciDil
                      ? firstLanguageText ?? ""
                      : secondLanguageText ?? "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color:
                    isDarkMode ? cardDarkModeText1 : cardLightModeText1,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  displayedTranslation == ikinciDil
                      ? secondLanguageText ?? ""
                      : firstLanguageText ?? "",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color:
                    isDarkMode ? cardDarkModeText2 : cardLightModeText2,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: isDarkMode ? Colors.white60 : Colors.black45,
          ),
        ],
      ),
    );
  }
}
