import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sozluk_ser_tr_ui/constants/app_constants/color_constants.dart';

import '../../constants/app_constants/constants.dart';
import '../../services/auth_services.dart';

class AddWordBox extends StatelessWidget {
  AddWordBox({
    super.key,
    required this.firstLanguageController,
    required this.secondLanguageController,
    required this.firstLanguageText,
    required this.secondLanguageText,
    required this.language,
    required this.onWordAdded,
    required this.currentUserEmail,
  });

  final TextEditingController firstLanguageController;
  final TextEditingController secondLanguageController;
  String firstLanguageText;
  String secondLanguageText;
  final String currentUserEmail;
  final Function(String, String, String) onWordAdded;
  final email = MyAuthService.currentUserEmail;
  final bool language;

  @override
  Widget build(BuildContext context) {
    // log("kayıtlı kullanıcı : $currentUserEmail");
    // log("add_word_box.dart email : $email");

    log("10-add_word_box.dart dosyası çalıştı. >>>>>");

    log("add_word_box.dart => build - firstLanguageText : $firstLanguageText");
    log("add_word_box.dart => build - secondLanguageText : $secondLanguageText");
    log("add_word_box.dart => build - language : $language");

    String tempLanguageText;

    if (language) {
      firstLanguageText = firstLanguageText;
      secondLanguageText = secondLanguageText;
    } else {
      tempLanguageText = firstLanguageText;
      firstLanguageText = secondLanguageText;
      secondLanguageText = tempLanguageText;
    }

    /// bu kontroller Sırpça-Türkçe dile seçimi için doğru çalışıyor
    // if (firstLanguageText == anaDil) {
    //   firstLanguageText = yardimciDil;
    //   secondLanguageText = anaDil;
    // } else if (firstLanguageText == yardimciDil) {
    //   firstLanguageText = anaDil;
    //   secondLanguageText = yardimciDil;
    // }

    log("add_word_box.dart => build - değişti mi? - firstLanguageText : $firstLanguageText");
    log("add_word_box.dart => build - değişti mi ?secondLanguageText : $secondLanguageText");

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Kelime Ekle',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: drawerColor,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          TextField(
            controller: firstLanguageController,
            decoration: InputDecoration(
              labelText: "$firstLanguageText kelime",
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
            controller: secondLanguageController,
            decoration: InputDecoration(
              labelText: "$secondLanguageText karşılığı",
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
                    Navigator.of(context).pop();
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
                    // log("add_word_box.dart => (ElevatedButton) - email : $email");
                    onWordAdded(
                      firstLanguageController.text,
                      secondLanguageController.text,
                      email,
                    );
                  },
                  child: Text(
                    'Kelime Ekle',
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
