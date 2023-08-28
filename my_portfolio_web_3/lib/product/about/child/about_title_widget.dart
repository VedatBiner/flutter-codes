import 'package:flutter/widgets.dart';
import 'package:my_portfolio_web_3/core/constants/enum/enum.dart';
import 'package:my_portfolio_web_3/product/about/component/red_line_under_aboutme.dart';

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
        GapEnum.xxL.heightBox,
      ],
    );
  }

  List<Widget> aboutMeTitle() {
    double lineWidth = 100;
    return [
      Text(
      "About Me",
      style:DefaultTextTheme().normalTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      ),
      GapEnum.N.heightBox,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          redLineUnderAboutMe(lineWidth),
          GapEnum.xS.heightBox,
          redLineUnderAboutMe(lineWidth / 2);
        ],
      ),
    ];
  }
}
