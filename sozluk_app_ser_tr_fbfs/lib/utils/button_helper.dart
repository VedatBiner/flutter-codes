import 'package:flutter/material.dart';

Widget buildElevatedButton({
  required VoidCallback onPressed,
  required IconData icon,
}) {
  return Expanded(
    flex: 2,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Icon(icon),
    ),
  );
}

