import 'package:flutter/material.dart';

import '../../core/constants/enum/enum.dart';
import 'child/about_title_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: GapEnum.L.value,
        vertical: GapEnum.xxL.value,
      ),
      child: SingleChildScrollView(
      child: childreWidget(),
      ),
    );
  }

  Column childreWidget() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AboutTitleWidget(),

    ],
  );
}