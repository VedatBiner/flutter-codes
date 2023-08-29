import 'package:flutter/material.dart';

Container redLineUnderAboutMe({bool isSmall = false}) {
  double lineWidth = 100;
  return Container(
    height: 8,
    width: isSmall ? lineWidth / 2 : lineWidth,
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

