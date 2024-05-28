import 'package:flutter/material.dart';
import 'package:sozluk_ser_tr_ui/constants/app_constants/color_constants.dart';
import 'package:sozluk_ser_tr_ui/constants/app_constants/constants.dart';
import 'package:sozluk_ser_tr_ui/screens/home_page_parts/showflag_widget.dart';

class EditWordBox extends StatelessWidget {
  const EditWordBox({
    super.key,
    required this.firstLanguageController,
    required this.secondLanguageController,
    required this.firstLanguageText,
    required this.secondLanguageText,
    required this.onWordUpdated,
    required this.currentUserEmail,
  });

  final TextEditingController firstLanguageController;
  final TextEditingController secondLanguageController;
  final String firstLanguageText;
  final String secondLanguageText;
  final String currentUserEmail;
  final Function(String, String) onWordUpdated;

  @override
  Widget build(BuildContext context) {
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
            controller: firstLanguageController,
            decoration: InputDecoration(
                prefixIcon: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: ShowFlagWidget(
                        code: secondCountry,
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
                )),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: secondLanguageController,
            decoration: InputDecoration(
              prefixIcon: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: ShowFlagWidget(
                      code: firstCountry,
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
