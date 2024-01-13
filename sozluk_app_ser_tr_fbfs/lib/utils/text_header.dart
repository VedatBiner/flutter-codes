import 'package:flutter/material.dart';

Widget buildTextHeader(String ruleText, BuildContext context, {TextStyle? style}) {
  return Text(
    ruleText,
    textAlign: TextAlign.start,
    style: style?.copyWith(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.blueAccent // Dark mode için beyaz renk
          : Colors.blueAccent, // Light mode için siyah renk
    ),
  );
}