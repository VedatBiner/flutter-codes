import 'package:flutter/material.dart';

Widget buildRichTextRule(
  String text,
  String dashTextA,
  BuildContext context,
) {
  TextStyle defaultStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Dark mode için beyaz renk
        : Colors.black, // Light mode için siyah renk
  );
  const TextStyle boldStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.red,
  );

  int indexOfDashA = text.indexOf(dashTextA);
  String beforeDashA = text.substring(0, indexOfDashA);
  String dashA = dashTextA;
  String afterDashA = text.substring(indexOfDashA + dashTextA.length);

  return RichText(
    text: TextSpan(
      style: defaultStyle,
      children: [
        TextSpan(text: beforeDashA),
        TextSpan(text: dashA, style: boldStyle),
        TextSpan(text: afterDashA),
      ],
    ),
  );
}
