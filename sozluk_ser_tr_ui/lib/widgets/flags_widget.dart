/// <----- flags_widget.dart ----->
library;

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class FlagWidget extends StatelessWidget {
  const FlagWidget({
    super.key,
    required this.countryCode,
    required this.radius
  });

  final String countryCode;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Flag.fromString(
      countryCode,
      height: 40,
      width: 40,
      fit: BoxFit.fill,
      flagSize: FlagSize.size_1x1,
      borderRadius: radius,
    );
  }
}

