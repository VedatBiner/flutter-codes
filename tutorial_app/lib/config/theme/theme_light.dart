import 'package:flutter/material.dart';

final class LightTheme {
  const LightTheme._();
  static final ThemeData theme = ThemeData.light(useMaterial3: true).copyWith(
    primaryColor: Colors.white,
    cardColor: Colors.pink,
    scaffoldBackgroundColor: Colors.white,
  );
}
