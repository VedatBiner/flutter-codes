// 📃 <----- theme.dart ----->

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

class CustomTheme {
  const CustomTheme._();

  static final theme = ThemeData(
    useMaterial3: false,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _blue,
      primary: _blue,
      secondary: _yellow,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
  );

  static const MaterialColor _blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFFE1F3FB),
      100: Color(0xFFB3E0F5),
      200: Color(0xFF81CCEF),
      300: Color(0xFF4FB8E9),
      400: Color(0xFF29A8E4),
      500: Color(_bluePrimaryValue), // 0xFF0277BD
      600: Color(0xFF026CAE),
      700: Color(0xFF025D9B),
      800: Color(0xFF024E88),
      900: Color(0xFF023C6E),
    },
  );
  static const int _bluePrimaryValue = 0xFF0277BD;

  static const MaterialColor _yellow = MaterialColor(
    _yellowPrimaryValue,
    <int, Color>{
      50: Color(0xFFF8FBE7),
      100: Color(0xFFF1F8C9),
      200: Color(0xFFE7F29F),
      300: Color(0xFFDFED7C),
      400: Color(0xFFD9E961),
      500: Color(_yellowPrimaryValue), // 0xFFDCE775
      600: Color(0xFFCFD636),
      700: Color(0xFFBCC129),
      800: Color(0xFFA9AD1E),
      900: Color(0xFF8C8F0F),
    },
  );
  static const int _yellowPrimaryValue = 0xFFDCE775;
}
