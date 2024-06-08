import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';

SnackBar buildSnackBar(
  String text,
  firstMessage,
  secondMessage,
) {
  return SnackBar(
    content: Column(
      children: [
        Row(
          children: [
            Text(
              text ?? '',
              style: kelimeStil,
            ),
            const Text(" kelimesi"),
          ],
        ),
        Row(
          children: [
            Text(
              firstMessage,
              style: userStil,
            ),
            Text(secondMessage),
          ],
        ),
      ],
    ),
  );
}
