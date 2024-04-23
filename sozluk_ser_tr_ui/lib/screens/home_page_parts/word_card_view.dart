import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/app_constants/constants.dart';
import '../../models/fs_words.dart';
import '../details_page.dart';

class WordCardView extends StatelessWidget {
  final FsWords word;
  final bool isDarkMode;

  const WordCardView({
    super.key,
    required this.word,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        shadowColor: Colors.green[200],
        color: isDarkMode ? cardDarkMode : cardLightMode,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.sirpca ?? "",
                        style: TextStyle(
                          color: isDarkMode
                              ? cardDarkModeText1
                              : cardLightModeText1,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: isDarkMode ? Colors.white60 : Colors.black45,
                      ),
                      Text(
                        word.turkce ?? "",
                        style: TextStyle(
                          color: isDarkMode
                              ? cardDarkModeText2
                              : cardLightModeText2,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        log("Kelime düzeltme seçildi");
                      },
                      icon: const Icon(Icons.edit),
                      tooltip: "kelime düzelt",
                      color: Colors.green,
                    ),
                    IconButton(
                      onPressed: () {
                        log("Kelime silme seçildi");
                      },
                      icon: const Icon(Icons.delete),
                      tooltip: "kelime sil",
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            log("word : ${word.sirpca}");
            log("word : ${word.turkce}");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailsPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
