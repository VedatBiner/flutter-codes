/// <----- word_card_view.dart ----->
/// Kelime listesini CardView olarak göstermek için
/// bu kod kullanılıyor.
/// kelime bilgileri word_list_builder.dart dosyasından geliyor.
library;

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants/constants.dart';
import '../../models/fs_words.dart';
import '../../models/language_params.dart';
import '../../services/theme_provider.dart';
import '../details_page.dart';

class WordCardView extends StatelessWidget {
  final FsWords word;
  final bool isDarkMode;
  final String displayedLanguage;
  final String displayedTranslation;
  final String firstLanguageText;
  final String secondLanguageText;

  const WordCardView({
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageParams = Provider.of<LanguageParams>(context);
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
          onTap: () {
            log("first : ${languageParams.firstLanguageText}");
            log("second : ${languageParams.secondLanguageText}");
            log("disp : $displayedLanguage");
            log("trans : $displayedTranslation");

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    firstLanguageText: languageParams.firstLanguageText,
                    secondLanguageText: languageParams.secondLanguageText,
                    displayedLanguage: displayedLanguage,
                    displayedTranslation: displayedTranslation,
                  ),
                ));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayedLanguage == birinciDil
                            ? firstLanguageText ?? ""
                            : secondLanguageText ?? "",
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
                        displayedTranslation == ikinciDil
                            ? secondLanguageText ?? ""
                            : firstLanguageText ?? "",
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Theme.of(context).brightness ==
                                  Brightness.dark
                                  ? Colors.white
                                  : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              title: const Text(
                                dikkatMsg,
                                style: dikkatText,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    silMsg,
                                    style: silText,
                                  ),
                                  const Text(
                                    eminMsg,
                                    style: eminText,
                                  ),
                                  Text(
                                    word.sirpca ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    word.turkce ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('İptal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Burada silme işlemi gerçekleştirilebilir
                                    Navigator.pop(context);
                                    log("Kelime silindi");
                                  },
                                  child: const Text('Sil'),
                                ),
                              ],
                            );
                          },
                        );
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
        ),
      ),
    );
  }
}