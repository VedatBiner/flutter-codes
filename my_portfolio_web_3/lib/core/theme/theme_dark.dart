import 'package:flutter/material.dart';
import 'theme_interface.dart';

class ThemeDark implements IAppTheme {
  static ThemeDark? _instance;
  static ThemeDark get instance {
    _instance ??= ThemeDark.init();
    return _instance!;
  }

  ThemeDark.init();

  @override
  ThemeData theme = ThemeData.dark().copyWith(
    colorScheme: scheme,
  );

  static ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: Colors.black87,
    background: Colors.black87,
  );
}
