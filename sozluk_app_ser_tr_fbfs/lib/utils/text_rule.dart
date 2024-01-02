// Tek dosyada güncellenmiş buildTextRule metodu
import 'package:flutter/material.dart';

Widget buildTextRule(String ruleText, {TextStyle? style}) {
  return Text(
    ruleText,
    textAlign: TextAlign.start,
    style: style,
  );
}
