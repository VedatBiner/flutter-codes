/// <----- mesaj_helper.dart ----->

import 'package:flutter/material.dart';

class MessageHelper {
  static void showSnackBar(
    BuildContext context, {
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
