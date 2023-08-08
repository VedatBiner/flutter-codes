import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../globals/app_colors.dart';
import '../globals/app_text_styles.dart';
import '../globals/constants.dart';

class MyPortfolio extends StatelessWidget {
  const MyPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.bgColor2,
      /// alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 12,
      ),
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 1200),
            child: RichText(
              text: TextSpan(
                text: "Latest ",
                style: AppTextStyles.headingStyles(fontSize: 30),
                children: [
                  TextSpan(
                    text: "Projects",
                    style: AppTextStyles.headingStyles(
                      fontSize: 30,
                      color: AppColors.robbinEdgeBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Constants.sizedBox(height: 60),
        ],
      ),
    );
  }
}

