import 'package:flutter/material.dart';
import 'package:my_portfolio_web/globals/app_assets.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image.asset(
            AppAssets.profile2,
            height: 450,
            width: 400,
          ),
        ],
      ),
    );
  }
}
