// theme_dark.dart
import 'package:flutter/material.dart';

final class DarkTheme {
  const DarkTheme._();
  static final ThemeData theme = ThemeData.dark(useMaterial3: true).copyWith(
    primaryColor: Colors.black87,
    cardColor: Colors.yellow,
    scaffoldBackgroundColor: Colors.black,
  );
}