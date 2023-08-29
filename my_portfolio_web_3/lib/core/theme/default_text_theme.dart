import 'package:flutter/material.dart';
import '../constants/enum/font_weight_enum.dart';

class DefaultTextTheme {
  TextTheme get normalTheme => TextTheme(
    displayLarge: TextStyle(
      fontSize: 96,
      fontWeight: convertFontWeight(FontWeightEnum.light),
      letterSpacing: -1.5,
    ),
    displayMedium: TextStyle(
      fontSize: 60,
      fontWeight: convertFontWeight(FontWeightEnum.light),
      letterSpacing: 0.5,
    ),
    displaySmall: TextStyle(
      fontSize: 48,
      fontWeight: convertFontWeight(FontWeightEnum.regular),
      letterSpacing: 0.0,
    ),
    headlineMedium: TextStyle(
      fontSize: 34,
      fontWeight: convertFontWeight(FontWeightEnum.regular),
      letterSpacing: 0.25,
    ),
    headlineSmall: TextStyle(
      fontSize: 34,
      fontWeight: convertFontWeight(FontWeightEnum.regular),
      letterSpacing: 0.0,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: convertFontWeight(FontWeightEnum.medium),
      letterSpacing: 0.15,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: convertFontWeight(FontWeightEnum.medium),
      letterSpacing: 0.15,
    ),
  );
}
FontWeight convertFontWeight(FontWeightEnum fontWeightEnum) {
  switch (fontWeightEnum) {
    case FontWeightEnum.light:
      return FontWeight.w300;
    case FontWeightEnum.regular:
      return FontWeight.w400;
    case FontWeightEnum.medium:
      return FontWeight.w500;
    case FontWeightEnum.bold:
      return FontWeight.w700;
    default:
      return FontWeight.normal; // Varsayılan olarak normal ağırlık
  }
}

