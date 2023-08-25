import 'package:flutter/material.dart';
import '../../theme/theme_light.dart';
import '../../theme/theme_dark.dart';

enum ThemeEnum {
  light,
  dark,
  ;

  ThemeData get theme {
    switch (this) {
      case light:
        return ThemeLight.instance.theme;
      case dark:
        return ThemeDark.instance.theme;
      default:
        return ThemeLight.instance.theme;
    }
  }
}
