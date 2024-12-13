/// <----- edit_word_box.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../constants/app_constants/color_constants.dart';
import '../../constants/app_constants/constants.dart';
import '../../services/providers/theme_provider.dart';
import '../../widgets/showflag_widget.dart';

class EditWordBox extends StatefulWidget {
  const EditWordBox({
    super.key,
    required this.firstLanguageController,
    required this.secondLanguageController,
    required this.firstLanguageText,
    required this.secondLanguageText,
    required this.onWordUpdated,
    required this.currentUserEmail,
    required this.language,
    required this.wordId,
  });

  final TextEditingController firstLanguageController;
  final TextEditingController secondLanguageController;
  final String firstLanguageText;
  final String secondLanguageText;
  final String currentUserEmail;
  final bool language;
  final String wordId;
  final Function(String, String, String) onWordUpdated;

  @override
  State<EditWordBox> createState() => _EditWordBoxState();
}

class _EditWordBoxState extends State<EditWordBox> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Text(
            'Kelime Düzelt',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode ? menuColor : drawerColor,
            ),
          ),
          Divider(
            color: themeProvider.isDarkMode ? menuColor : drawerColor,
          ),
          TextField(
            controller: widget.language == true
                ? widget.secondLanguageController
                : widget.firstLanguageController,
            style: TextStyle(
              color: themeProvider.isDarkMode ? darkModeText1 : lightModeText1,
            ),
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ShowFlagWidget(
                      code: widget.language == true
                          ? secondCountry
                          : firstCountry,
                      text: '',
                      radius: 48,
                    ),
                  ),
                ],
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black54,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          TextField(
            controller: widget.language == true
                ? widget.firstLanguageController
                : widget.secondLanguageController,
            style: TextStyle(
              color: themeProvider.isDarkMode ? darkModeText1 : lightModeText1,
            ),
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ShowFlagWidget(
                      code: widget.language == true
                          ? firstCountry
                          : secondCountry,
                      text: '',
                      radius: 48,
                    ),
                  ),
                ],
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black54,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 20,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Diyaloğu kapatır
                  },
                  child: const Text(
                    'İptal',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: drawerColor,
                  ),
                  onPressed: () {
                    log("Düzeltme butonuna basıldı");
                    widget.onWordUpdated(
                      widget.wordId,
                      widget.firstLanguageController.text,
                      widget.secondLanguageController.text,
                    );
                  },
                  child: Text(
                    'Kelime Düzelt',
                    style: TextStyle(
                      color: menuColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
