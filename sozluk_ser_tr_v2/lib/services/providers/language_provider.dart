// bu dosya şimdilik kullanılmayacak

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../models/language_params.dart';

class LanguageProvider with ChangeNotifier {
  late LanguageParams _languageParams;

  LanguageParams get languageParams => _languageParams;

  LanguageProvider() {
    _languageParams = LanguageParams(
      firstLanguageCode: secondCountry,
      firstLanguageText: yardimciDil,
      secondLanguageCode: firstCountry,
      secondLanguageText: anaDil,
    );
  }

  void updateLanguageParams(LanguageParams newParams) {
    _languageParams = newParams;
    notifyListeners();
  }
}
