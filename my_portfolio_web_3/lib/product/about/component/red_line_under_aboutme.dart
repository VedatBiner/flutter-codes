import 'package:flutter/material.dart';

import '../../../core/extension/screensize_extension.dart';
import '../../../core/extension/theme_extension.dart';

class RedLineUnderAboutMe extends StatelessWidget {
  const RedLineUnderAboutMe({
    super.key,
    this.isSmall = false,
  });

  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    double lineWidth = context.isDesktop || context.isTablet ? 100 : 80;
    return Container(
      height: 8,
      width: isSmall ? lineWidth / 2 : lineWidth,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
