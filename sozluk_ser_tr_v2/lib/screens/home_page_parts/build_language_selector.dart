import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants/constants.dart';
import '../../constants/app_constants/drawer_constants.dart';
import '../../models/language_params.dart';
import '../../services/providers/icon_provider.dart';
import 'language_selector.dart';

/// dil değişimi burada yapılıyor
Widget buildLanguageSelector({
  required BuildContext context,
  required bool isListView,
  required bool language,
  required String firstLanguageCode,
  required String firstLanguageText,
  required String secondLanguageCode,
  required String secondLanguageText,
  required String appBarTitle,
  required void Function(bool) onLanguageChange,
  required VoidCallback onIconPressed,
  required void Function(VoidCallback fn) setState,
}) {
  final languageParams = Provider.of<LanguageParams>(context);
  return LanguageSelector(
    firstLanguageCode: languageParams.secondLanguageCode,
    firstLanguageText: languageParams.secondLanguageText,
    secondLanguageCode: languageParams.firstLanguageCode,
    secondLanguageText: languageParams.firstLanguageText,
    isListView: isListView,
    language: language,
    onIconPressed: () {
      setState(() {
        Provider.of<IconProvider>(context, listen: false).changeIcon();
        isListView = !isListView;
      });
    },
    onLanguageChange: (bool newLanguage) {
      setState(
        () {
          language = newLanguage;
          if (language) {
            firstLanguageCode = secondCountry;
            firstLanguageText = yardimciDil;
            secondLanguageCode = firstCountry;
            secondLanguageText = anaDil;
            appBarTitle = appBarMainTitleSecond;
          } else {
            firstLanguageCode = firstCountry;
            firstLanguageText = anaDil;
            secondLanguageCode = secondCountry;
            secondLanguageText = yardimciDil;
            appBarTitle = appBarMainTitleFirst;
          }
        },
      );
    },
  );
}
