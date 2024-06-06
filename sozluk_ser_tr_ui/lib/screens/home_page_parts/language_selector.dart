/// <----- language_selector.dart ----->
library;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants/color_constants.dart';
import '../../services/providers/icon_provider.dart';
import '../../widgets/showflag_widget.dart';

class LanguageSelector extends StatelessWidget {
  final String firstLanguageCode;
  final String firstLanguageText;
  final String secondLanguageCode;
  final String secondLanguageText;
  final bool isListView;
  final bool language;
  final Function() onIconPressed;
  final Function(bool) onLanguageChange;

  const LanguageSelector({
    super.key,
    required this.firstLanguageCode,
    required this.firstLanguageText,
    required this.secondLanguageCode,
    required this.secondLanguageText,
    required this.isListView,
    required this.language,
    required this.onIconPressed,
    required this.onLanguageChange,
  });

  @override
  Widget build(BuildContext context) {
    log("===> 15-language_selector.dart dosyası çalıştı. >>>>>>>");
    log("-------------------------------------------------------");
    log("language_selector.dart => language : $language");

    language == true ? log("Sırpça - Türkçe") : log("Türkçe - Sırpça");

    return Container(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShowFlagWidget(
              code: language == true ? firstLanguageCode : secondLanguageCode,
              text: language == true ? firstLanguageText : secondLanguageText,
              radius: 8,
            ),
            ShowFlagWidget(
              code: language == true ? secondLanguageCode : firstLanguageCode,
              text: language == true ? secondLanguageText : firstLanguageText,
              radius: 8,
            ),
            Consumer<IconProvider>(
              builder: (context, iconProvider, _) {
                return IconButton(
                  tooltip: "Görünümü değiştir",
                  icon: Icon(
                    iconProvider.isIconChanged ? Icons.credit_card : Icons.list,
                    size: 40,
                    color: menuColor,
                  ),
                  onPressed: onIconPressed,
                );
              },
            ),
            IconButton(
              tooltip: "Dil değiştir",
              onPressed: () => onLanguageChange(!language),
              icon: Icon(
                Icons.swap_horizontal_circle_rounded,
                color: menuColor,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
