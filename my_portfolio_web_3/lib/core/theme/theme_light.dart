import 'package:flutter/material.dart';
import 'theme_interface.dart';

class ThemeLight implements IAppTheme {
  static ThemeLight? _instance;
  static ThemeLight get instance {
    _instance ??= ThemeLight.init();
    return _instance!;
  }

  ThemeLight.init();

  @override
  ThemeData theme = ThemeData.light().copyWith(
    colorScheme: scheme,
  );

  static ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: Colors.white,
    background: Colors.white,
  );
}

