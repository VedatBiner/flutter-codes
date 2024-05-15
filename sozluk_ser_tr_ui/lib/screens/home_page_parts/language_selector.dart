/// <----- language_selector.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants/constants.dart';
import '../../services/icon_provider.dart';
import 'showflag_widget.dart';

class LanguageSelector extends StatelessWidget {
  final String firstLanguageCode;
  final String firstLanguageText;
  final String secondLanguageCode;
  final String secondLanguageText;
  final bool isListView;
  final Function() onIconPressed;
  final Function() onLanguageChange;

  const LanguageSelector({
    super.key,
    required this.firstLanguageCode,
    required this.firstLanguageText,
    required this.secondLanguageCode,
    required this.secondLanguageText,
    required this.isListView,
    required this.onIconPressed,
    required this.onLanguageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShowFlagWidget(
              code: firstLanguageCode,
              text: firstLanguageText,
              radius: 8,
            ),
            ShowFlagWidget(
              code: secondLanguageCode,
              text: secondLanguageText,
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
              onPressed: onLanguageChange,
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