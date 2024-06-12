import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';

SnackBar buildSnackBar(
  String firstMessage,
  String secondMessage,
  String email,
) {
  return SnackBar(
    content: Column(
      children: [
        Row(
          children: [
            Text(
              firstMessage ?? '',
              style: kelimeStil,
            ),
            const Text(" kelimesi"),
          ],
        ),
        Row(
          children: [
            Text(
              email,
              style: userStil,
            ),
            Text(secondMessage),
          ],
        ),
      ],
    ),
  );
}
