import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio_web/globals/app_assets.dart';
import 'package:my_portfolio_web/globals/app_colors.dart';
import 'package:my_portfolio_web/globals/app_text_styles.dart';
import 'package:my_portfolio_web/globals/constants.dart';

class MyServices extends StatelessWidget {
  const MyServices({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.bgColor,
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 1200),
            child: RichText(
              text: TextSpan(
                text: "My ",
                style: AppTextStyles.headingStyles(fontSize: 30),
                children: [
                  TextSpan(
                    text: "Services",
                    style: AppTextStyles.headingStyles(
                      fontSize: 30,
                      color: AppColors.robbinEdgeBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Constants.sizedBox(height: 40),
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: 450,
                child: Column(
                  children: [
                    Text(
                      "App Development",
                      style: AppTextStyles.montserratStyle(color: Colors.white),
                    ),
                    Constants.sizedBox(height: 30),
                    Image.asset(
                      AppAssets.code,
                      width: 50,
                      height: 50,
                      color: AppColors.themeColor,
                    ),
                    Constants.sizedBox(height: 12),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing "
                      "elit, sed do eiusmod tempor incididunt ut labore et "
                      "dolore magna aliqua. Ut enim ad minim veniam, quis "
                      "nostrud exercitation ullamco laboris nisi ut aliquip "
                      "ex ea commodo consequat. Duis aute irure dolor in",
                      style: AppTextStyles.normalStyle(),
                      textAlign: TextAlign.center,
                    ),
                    Constants.sizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
