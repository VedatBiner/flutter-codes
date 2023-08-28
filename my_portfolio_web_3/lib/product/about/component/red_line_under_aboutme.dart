import 'package:flutter/material.dart';

Container redLineUnderAboutMe(double long) {
  return Container(
    height: 8,
    width: long,
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
