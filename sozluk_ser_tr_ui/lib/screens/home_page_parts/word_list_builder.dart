/// <----- word_list_builder.dart ----->
library;

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants/constants.dart';
import '../../models/fs_words.dart';
import '../../services/theme_provider.dart';
import '../details_page.dart';

class WordListBuilder extends StatelessWidget {
  final List<QuerySnapshot<FsWords>> snapshot;
  final bool isListView;

  const WordListBuilder({
    super.key,
    required this.snapshot,
    required this.isListView,
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
            context: context, word: word, isListView: isListView);
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
    Widget wordWidget;
    if (isListView) {
      /// Liste görünümü
      wordWidget = ListTile(
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
                      color: themeProvider.isDarkMode
                          ? cardDarkModeText1
                          : cardLightModeText1,
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
                      color: themeProvider.isDarkMode
                          ? cardDarkModeText2
                          : cardLightModeText2,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: themeProvider.isDarkMode ? Colors.white60 : Colors.black45,
            ),
          ],
        ),
      );
    } else {
      /// Card Görünümü
      wordWidget = Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          shadowColor: Colors.green[200],
          color: themeProvider.isDarkMode ? cardDarkMode : cardLightMode,
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
                            color: themeProvider.isDarkMode
                                ? cardDarkModeText1
                                : cardLightModeText1,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: themeProvider.isDarkMode
                              ? Colors.white60
                              : Colors.black45,
                        ),
                        Text(
                          word.turkce ?? "",
                          style: TextStyle(
                            color: themeProvider.isDarkMode
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
    return wordWidget;
  }
}