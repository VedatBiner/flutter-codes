import 'package:flutter/material.dart';
import '../constants/enum/theme_enum.dart';

abstract class IThemeManager {
  late ThemeData currentTheme;
  late ThemeEnum currentEnum;

  void changeTheme(ThemeEnum theme);

  void reverseTheme();
}

abstract class IAppTheme{
  late ThemeData theme;
}