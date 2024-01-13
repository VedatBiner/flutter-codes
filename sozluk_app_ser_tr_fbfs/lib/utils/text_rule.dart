import 'package:flutter/material.dart';

Widget buildTextRule(String ruleText, BuildContext context, {TextStyle? style}) {
  return Text(
    ruleText,
    textAlign: TextAlign.start,
    style: (style ?? const TextStyle()) // Varsayılan stil belirleniyor
        .copyWith(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white // Dark mode için beyaz renk
          : Colors.black, // Light mode için siyah renk
    ),
  );
}
