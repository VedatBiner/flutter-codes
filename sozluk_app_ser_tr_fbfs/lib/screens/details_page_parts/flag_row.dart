/// <----- flag_row.dart ----->

import 'package:flutter/material.dart';

import '../../widgets/flags_widget.dart';

Row buildFlagRow(
  String countryCode,
  String text,
  TextStyle textStyle,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      FlagWidget(
        countryCode: countryCode,
        radius: 25,
      ),
      const SizedBox(width: 10),
      Text(
        text,
        textAlign: TextAlign.left,
        style: textStyle,
      ),
    ],
  );
}
