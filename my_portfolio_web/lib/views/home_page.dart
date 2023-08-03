import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio_web/globals/app_assets.dart';
import 'package:my_portfolio_web/globals/app_colors.dart';
import 'package:my_portfolio_web/globals/app_text_styles.dart';
import 'package:my_portfolio_web/globals/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        toolbarHeight: 90,
        titleSpacing: 100,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Row(
            children: [
              Text(
                "Portfolio",
                style: AppTextStyles.headerTextStyle(),
              ),
              const Spacer(),
              Text("Home", style: AppTextStyles.headerTextStyle()),
              const SizedBox(width: 30),
              Text("About", style: AppTextStyles.headerTextStyle()),
              const SizedBox(width: 30),
              Text("Services", style: AppTextStyles.headerTextStyle()),
              const SizedBox(width: 30),
              Text("Portfolio", style: AppTextStyles.headerTextStyle()),
              const SizedBox(width: 30),
              Text("Contact", style: AppTextStyles.headerTextStyle()),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: size.height * 0.3,
          left: size.width * 0.2,
          right: size.height * 0.2,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, It\'s Me",
                      style: AppTextStyles.montserratStyle(
                        color: Colors.white,
                      ),
                    ),
                    Constants.sizedBox(height: 15),
                    Text(
                      "Vedat Biner",
                      style: AppTextStyles.headingStyles(),
                    ),
                    Constants.sizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          "and I'm a ",
                          style: AppTextStyles.montserratStyle(
                            color: Colors.white,
                          ),
                        ),
                        AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              "Flutter Developer",
                              textStyle: AppTextStyles.montserratStyle(
                                color: Colors.blueAccent,
                              ),
                              speed: const Duration(milliseconds: 100),
                            ),
                            TyperAnimatedText(
                              "Freelancer",
                              textStyle: AppTextStyles.montserratStyle(
                                color: Colors.yellow,
                              ),
                              speed: const Duration(milliseconds: 100),
                            ),
                            TyperAnimatedText(
                              "System Administrator",
                              textStyle: AppTextStyles.montserratStyle(
                                color: Colors.green,
                              ),
                              speed: const Duration(milliseconds: 75),
                            ),
                          ],
                          pause: const Duration(milliseconds: 1000),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                      ],
                    ),
                    Constants.sizedBox(height: 15),
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing "
                        "elit, sed do eiusmod tempor incididunt ut labore et "
                        "dolore magna aliqua. Ut enim ad minim veniam, quis "
                        "nostrud exercitation ullamco laboris nisi ut aliquip "
                        "ex ea commodo consequat. Duis aute irure dolor in "
                        "reprehenderit in voluptate velit esse cillum dolore "
                        "eu fugiat nulla pariatur. Excepteur sint occaecat "
                        "cupidatat non proident, sunt in culpa qui officia "
                        "deserunt mollit anim id est laborum.",
                        style: AppTextStyles.normalStyle(),
                      ),
                    ),
                    Constants.sizedBox(height: 22),
                    Row(
                      children: [
                        buildSocialButton(asset: AppAssets.facebook),
                        Constants.sizedBox(width: 12),
                        buildSocialButton(asset: AppAssets.instagram),
                        Constants.sizedBox(width: 12),
                        buildSocialButton(asset: AppAssets.linkedin),
                        Constants.sizedBox(width: 12),
                        buildSocialButton(asset: AppAssets.twitter),
                        Constants.sizedBox(width: 12),
                        buildSocialButton(asset: AppAssets.github),
                        Constants.sizedBox(width: 12),
                        buildSocialButton(asset: AppAssets.medium),
                        Constants.sizedBox(width: 12),
                        buildSocialButton(asset: AppAssets.telegram),
                      ],
                    ),
                    Constants.sizedBox(height: 18),
                    buildMaterialButton(onTap: () {}),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  MaterialButton buildMaterialButton({
    required VoidCallback onTap,
  }) {
    return MaterialButton(
      onPressed: onTap,
      color: AppColors.themeColor,
      splashColor: AppColors.lawGreen,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 12,
      ),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      hoverColor: AppColors.aqua,
      elevation: 6,
      height: 46,
      minWidth: 130,
      focusElevation: 12,
      child: Text(
        "Download CV",
        style: AppTextStyles.headerTextStyle(),
      ),
    );
  }

  Ink buildSocialButton({required String asset}) {
    return Ink(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.themeColor,
          width: 2.0,
        ),
        color: AppColors.bgColor,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(500.0),
        splashColor: AppColors.lawGreen,
        hoverColor: AppColors.aqua,
        onTap: () {},
        radius: 50,
        child: Image.asset(
          asset,
          width: 20,
          height: 24,
          color: AppColors.themeColor,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
