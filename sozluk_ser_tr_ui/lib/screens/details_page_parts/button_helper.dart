/// <----- button_helper.dart ----->
library;

import 'package:flutter/material.dart';
import '../../constants/app_constants/constants.dart';

Widget buildElevatedButton({
  required VoidCallback onPressed,
  required IconData icon,
  Color? buttonColor,
  double iconSize = 24,
}) {
  return Expanded(
    flex: 2,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: menuColor,
      ),
      child: Icon(
        icon,
        size: iconSize,
      ),
    ),
  );
}
