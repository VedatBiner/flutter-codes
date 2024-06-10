/// <----- edit_word_box.dart ----->
library;

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/app_constants/color_constants.dart';
import '../../constants/app_constants/constants.dart';
import '../../widgets/showflag_widget.dart';

class EditWordBox extends StatelessWidget {
  const EditWordBox({
    super.key,
    required this.firstLanguageController,
    required this.secondLanguageController,
    required this.firstLanguageText,
    required this.secondLanguageText,
    required this.onWordUpdated,
    required this.currentUserEmail,
    required this.language,
  });

  final TextEditingController firstLanguageController;
  final TextEditingController secondLanguageController;
  final String firstLanguageText;
  final String secondLanguageText;
  final String currentUserEmail;
  final bool language;
  final Function(String, String) onWordUpdated;

  @override
  Widget build(BuildContext context) {
    log("===> 17 - edit_word_bax.dart dosyası çalıştı. >>>>>");
    log("---------------------------------------------------");
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Kelime Düzelt',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: drawerColor,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          TextField(
            controller: language == true
                ? secondLanguageController
                : firstLanguageController,
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ShowFlagWidget(
                      code: language == true ? secondCountry : firstCountry,
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
          const SizedBox(height: 20),
          TextField(
            controller: language == true
                ? firstLanguageController
                : secondLanguageController,
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ShowFlagWidget(
                      code: language == true ? firstCountry : secondCountry,
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: drawerColor,
                  ),
                  onPressed: () {
                    log("Düzeltme butonuna basıldı");
                    onWordUpdated(
                      firstLanguageController.text,
                      secondLanguageController.text,
                    );
                  },
                  child: Text(
                    'Kelime Düzelt',
                    style: TextStyle(color: menuColor),
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
