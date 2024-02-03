/// <----- flag_row.dart ----->
library;

import 'package:flutter/material.dart';

import '../../widgets/flags_widget.dart';

Padding buildFlagRow(
  String countryCode,
  String text,
  TextStyle textStyle,
) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 30,
      right: 30,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FlagWidget(
          countryCode: countryCode,
          radius: 25,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: textStyle,
          ),
        ),
      ],
    ),
  );
}
