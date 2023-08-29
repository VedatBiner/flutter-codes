import 'package:flutter/material.dart';

import '../../../core/extension/screensize_extension.dart';
import '../../../core/constants/enum/enum.dart';
import '../../../core/theme/default_text_theme.dart';

class AboutSubtitleWidget extends StatelessWidget {
  AboutSubtitleWidget({super.key});

  late BuildContext mainContext;
  @override
  Widget build(BuildContext context) {
    mainContext = context;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I'm Flutter Developer",
          style: titleStyle,
        ),
        GapEnum.L.heightBox,
        const Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing "
          "elit, sed do eiusmod tempor incididunt ut labore et "
          "dolore magna aliqua. Ut enim ad minim veniam, quis "
          "nostrud exercitation ullamco laboris nisi ut aliquip "
          "ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore "
          "eu fugiat nulla pariatur. Excepteur sint occaecat "
          "cupidatat non proident, sunt in culpa qui officia "
          "deserunt mollit anim id est laborum.",
          style: ,
        ),
      ],
    );
  }

  TextStyle? get titleStyle => mainContext.isDesktop || mainContext.isTablet
      ? DefaultTextTheme().normalTheme.headlineMedium
      : DefaultTextTheme().normalTheme.headlineSmall;
}
