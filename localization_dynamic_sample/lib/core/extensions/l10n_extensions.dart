import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// BuildContext üzerine bir extension ekliyoruz
extension AppLocalizationExtension on BuildContext {
  /// Dil dosyalarındaki metinlere erişim için null kontrolü ekleyelim
  String? translate(String key) {
    final localizations = AppLocalizations.of(this);
    return localizations?.translate(key); // null kontrolü yapılıyor
  }

  /// [locale]: Uygulamanın diline extension üzerinden erişmek için
  Locale? get locale => AppLocalizations.of(this)?.locale;
}
