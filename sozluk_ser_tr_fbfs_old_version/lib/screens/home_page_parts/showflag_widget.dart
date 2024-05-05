/// <----- showflag_widget.dart ----->
library;

import 'package:flutter/material.dart';
import '../../widgets/flags_widget.dart';

import '../../constants/app_constants/constants.dart';

class ShowFlagWidget extends StatelessWidget {
  const ShowFlagWidget({
    required this.code,
    required this.text,
    required this.radius,
    super.key,
  });

  final String code;
  final double radius;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FlagWidget(
            countryCode: code,
            radius: radius,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: baslikTextWhite,
          ),
        ],
      ),
    );
  }
}
