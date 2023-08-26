import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_manager.dart';

extension ThemeManagerExtension on BuildContext {
  ThemeData get currentTheme => watch<ThemeManager>().currentTheme;
  TextTheme get textTheme => currentTheme.textTheme;
  ColorScheme get colorScheme => currentTheme.colorScheme;
}

