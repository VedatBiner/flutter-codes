/// <----- details_card_ser_tr.dart ----->
library;

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../constants/app_constants/color_constants.dart';
import '../../services/providers/theme_provider.dart';
import 'flag_row.dart';

class DetailsCard extends StatelessWidget {
  final String firstLanguageText;
  final String secondLanguageText;
  final String displayedLanguage;
  final String displayedTranslation;
  final ThemeProvider themeProvider;

  const DetailsCard({
    super.key,
    required this.firstLanguageText,
    required this.secondLanguageText,
    required this.displayedLanguage,
    required this.displayedTranslation,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      shadowColor: Colors.blue[200],
      color: themeProvider.isDarkMode ? cardDarkMode : cardLightMode,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.width * 0.95,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              displayedLanguage == anaDil
                  ? buildFlagRow(
                      firstCountry,
                      firstLanguageText,
                      detailTextRed,
                    )
                  : buildFlagRow(
                      secondCountry,
                      secondLanguageText,
                      detailTextBlue,
                    ),
              const SizedBox(height: 40),
              displayedTranslation == yardimciDil
                  ? buildFlagRow(
                      secondCountry,
                      secondLanguageText,
                      detailTextRed,
                    )
                  : buildFlagRow(
                      firstCountry,
                      firstLanguageText,
                      detailTextBlue,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
