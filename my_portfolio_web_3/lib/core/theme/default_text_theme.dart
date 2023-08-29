import 'package:flutter/material.dart';

class DefaultTextTheme {
  TextTheme get normalTheme => TextTheme(
        displayLarge: TextStyle(
          fontSize: 96,
          fontWeight: FontWeightEnum.light.value,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          fontSize: 60,
          fontWeight: FontWeightEnum.light.value,
          letterSpacing: 0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 48,
          fontWeight: FontWeightEnum.regular.value,
        ),
        headlineMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeightEnum.regular.value,
          letterSpacing: 0.25,
        ),
        headlineSmall: TextStyle(
          fontSize: 34,
          fontWeight: FontWeightEnum.regular.value,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeightEnum.medium.value,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeightEnum.medium.value,
          letterSpacing: 0.15,
        ),
      );
}
