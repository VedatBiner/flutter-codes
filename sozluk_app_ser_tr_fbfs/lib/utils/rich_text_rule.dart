/// <----- rich_text_rule.dart ----->

import 'package:flutter/material.dart';

Widget buildRichTextRule(
  String text,
  BuildContext context, {
  String? dashTextA,
  String? dashTextB,
  String? dashTextC,
  String? dashTextD,
}) {
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

  List<InlineSpan> children = [];
  int currentIndex = 0;

  if (dashTextA != null) {
    int indexOfDashA = text.indexOf(dashTextA);
    children.add(TextSpan(
      text: text.substring(currentIndex, indexOfDashA),
      style: defaultStyle,
    ));
    children.add(TextSpan(
      text: dashTextA,
      style: boldStyle,
    ));
    currentIndex = indexOfDashA + dashTextA.length;
  }

  if (dashTextB != null) {
    int indexOfDashB = text.indexOf(dashTextB, currentIndex);
    children.add(TextSpan(
      text: text.substring(currentIndex, indexOfDashB),
      style: defaultStyle,
    ));
    children.add(TextSpan(
      text: dashTextB,
      style: boldStyle,
    ));
    currentIndex = indexOfDashB + dashTextB.length;
  }

  if (dashTextC != null) {
    int indexOfDashC = text.indexOf(dashTextC, currentIndex);
    children.add(TextSpan(
      text: text.substring(currentIndex, indexOfDashC),
      style: defaultStyle,
    ));
    children.add(TextSpan(
      text: dashTextC,
      style: boldStyle,
    ));
    currentIndex = indexOfDashC + dashTextC.length;
  }

  if (dashTextD != null) {
    int indexOfDashD = text.indexOf(dashTextD, currentIndex);
    children.add(TextSpan(
      text: text.substring(currentIndex, indexOfDashD),
      style: defaultStyle,
    ));
    children.add(TextSpan(
      text: dashTextD,
      style: boldStyle,
    ));
    currentIndex = indexOfDashD + dashTextD.length;
  }

  children.add(TextSpan(
    text: text.substring(currentIndex),
    style: defaultStyle,
  ));

  return RichText(
    text: TextSpan(
      style: defaultStyle,
      children: children,
    ),
  );
}
