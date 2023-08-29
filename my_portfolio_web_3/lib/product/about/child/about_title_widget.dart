import 'package:flutter/material.dart';

import '../../../core/extension/screensize_extension.dart';
import '../../../core/constants/enum/enum.dart';
import '../../../product/about/component/red_line_under_aboutme.dart';
import '../../../core/theme/default_text_theme.dart';

class AboutTitleWidget extends StatefulWidget {
  const AboutTitleWidget({super.key});

  @override
  State<AboutTitleWidget> createState() => _AboutTitleWidgetState();
}

class _AboutTitleWidgetState extends State<AboutTitleWidget> {
  late BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: aboutMeTitle(),
    );
  }

  List<Widget> aboutMeTitle() {
    return [
      _title(),
      GapEnum.N.heightBox,
      _line(),
      GapEnum.L.heightBox,
    ];
  }

  Column _line() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RedLineUnderAboutMe(),
        GapEnum.xS.heightBox,
        const RedLineUnderAboutMe(isSmall: true),
      ],
    );
  }

  Text _title() {
    return Text(
      "About Me",
      style: titleStyle?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle? get titleStyle => mainContext.isDesktop || mainContext.isTablet
      ? DefaultTextTheme().normalTheme.displayMedium
      : DefaultTextTheme().normalTheme.displaySmall;
}
