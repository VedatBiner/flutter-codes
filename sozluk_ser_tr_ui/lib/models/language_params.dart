import 'package:flutter/foundation.dart';

class LanguageParams extends ChangeNotifier {
  String _firstLanguageCode;
  String _firstLanguageText;
  String _secondLanguageCode;
  String _secondLanguageText;

  LanguageParams({
    required String firstLanguageCode,
    required String firstLanguageText,
    required String secondLanguageCode,
    required String secondLanguageText,
  })  : _firstLanguageCode = firstLanguageCode,
        _firstLanguageText = firstLanguageText,
        _secondLanguageCode = secondLanguageCode,
        _secondLanguageText = secondLanguageText;

  String get firstLanguageCode => _firstLanguageCode;
  String get firstLanguageText => _firstLanguageText;
  String get secondLanguageCode => _secondLanguageCode;
  String get secondLanguageText => _secondLanguageText;

  set firstLanguageCode(String value) {
    _firstLanguageCode = value;
    notifyListeners();
  }

  set firstLanguageText(String value) {
    _firstLanguageText = value;
    notifyListeners();
  }

  set secondLanguageCode(String value) {
    _secondLanguageCode = value;
    notifyListeners();
  }

  set secondLanguageText(String value) {
    _secondLanguageText = value;
    notifyListeners();
  }

  LanguageParams copyWith({
    String? firstLanguageCode,
    String? firstLanguageText,
    String? secondLanguageCode,
    String? secondLanguageText,
  }) {
    return LanguageParams(
      firstLanguageCode: firstLanguageCode ?? _firstLanguageCode,
      firstLanguageText: firstLanguageText ?? _firstLanguageText,
      secondLanguageCode: secondLanguageCode ?? _secondLanguageCode,
      secondLanguageText: secondLanguageText ?? _secondLanguageText,
    );
  }

  void changeLanguage({
    required String firstLanguageCode,
    required String firstLanguageText,
    required String secondLanguageCode,
    required String secondLanguageText,
  }) {
    this.firstLanguageCode = firstLanguageCode;
    this.firstLanguageText = firstLanguageText;
    this.secondLanguageCode = secondLanguageCode;
    this.secondLanguageText = secondLanguageText;
  }
}
