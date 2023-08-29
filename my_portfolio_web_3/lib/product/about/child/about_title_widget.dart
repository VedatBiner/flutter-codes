import 'package:flutter/material.dart';

import '../../../core/constants/enum/enum.dart';
import '../../../product/about/component/red_line_under_aboutme.dart';
import '../../../core/theme/default_text_theme.dart';

class AboutTitleWidget extends StatelessWidget {
  const AboutTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: aboutMeTitle(),
        ),
        GapEnum.xL.heightBox,
      ],
    );
  }

  List<Widget> aboutMeTitle() {

    return [
      Text(
        "About Me",
        style: DefaultTextTheme.displayMedium(fontSize: 16).copyWith(
          fontWeight: FontWeight.bold,
      ),
      ),
      GapEnum.N.heightBox,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          redLineUnderAboutMe(),
          GapEnum.xL.heightBox,
          redLineUnderAboutMe(isSmall: true),
        ],
      ),
    ];
  }
}
