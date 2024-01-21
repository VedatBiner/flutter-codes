/// <----- text_header.dart ----->
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

Widget buildTextHeader(String ruleText, BuildContext context,
    {TextStyle? style}) {
  return Text(
    ruleText,
    textAlign: TextAlign.start,
    style: style?.copyWith(
      color: kIsWeb
          ? Colors.blueAccent
          : Theme.of(context).brightness == Brightness.dark
              ? Colors.white // Dark mode için beyaz renk
              : Colors.black, // Light mode için siyah renk
    ),
  );
}
