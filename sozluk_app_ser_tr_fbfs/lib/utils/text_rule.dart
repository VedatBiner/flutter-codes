import 'package:flutter/material.dart';

Widget buildTextRule(String ruleText, BuildContext context, {TextStyle? style}) {
  return Text(
    ruleText,
    textAlign: TextAlign.start,
    style: style?.copyWith(
      color: Theme.of(context).platform == TargetPlatform.android
          ? Colors.black
          : Colors.white,
    ),
  );
}

