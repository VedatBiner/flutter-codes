/// <----- show_message_line.dart ----->
///
library;

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';

/// veya satırı ile ayıralım
Row messageLine() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        height: 1,
        width: 100,
        color: menuColor,
      ),
      Text(
        "veya",
        style: TextStyle(
          color: menuColor,
          fontSize: 24,
        ),
      ),
      Container(
        height: 1,
        width: 100,
        color: menuColor,
      ),
    ],
  );
}
