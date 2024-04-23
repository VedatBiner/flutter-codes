import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../models/fs_words.dart';

class WordListView extends StatelessWidget {
  final FsWords word;
  final bool isDarkMode;

  const WordListView({
    super.key,
    required this.word,
    required this.isDarkMode,
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
                  word.sirpca ?? "",
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
                  word.turkce ?? "",
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
