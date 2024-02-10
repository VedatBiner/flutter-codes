/// <----- details_card_ser_tr.dart ----->
library;

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../models/words.dart';
import '../../services/theme_provider.dart';
import 'flag_row.dart';

class DetailsCardSerTr extends StatelessWidget {
  final Words word;
  final ThemeProvider themeProvider;

  const DetailsCardSerTr({
    super.key,
    required this.word,
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
              buildFlagRow(
                'RS',
                word.sirpca,
                detailTextRed,
              ),
              const SizedBox(height: 40),
              buildFlagRow(
                'TR',
                word.turkce,
                detailTextBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
