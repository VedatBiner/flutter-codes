import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio_web/globals/app_assets.dart';
import 'package:my_portfolio_web/globals/app_colors.dart';
import 'package:my_portfolio_web/helperclass/helper_class.dart';
import '../globals/app_buttons.dart';
import '../globals/app_text_styles.dart';
import '../globals/constants.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor2,
      body: HelperClass(
        mobile: Column(
          children: [
            buildAboutMeContents(),
            Constants.sizedBox(width: 25),
            buildProfilePicture(),
          ],
        ),
        tablet: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildProfilePicture(),
            Constants.sizedBox(width: 25),
            buildAboutMeContents(),
          ],
        ),
        desktop: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildProfilePicture(),
            Constants.sizedBox(width: 25),
            buildAboutMeContents(),
          ],
        ),
      ),
    );
  }

  FadeInRight buildProfilePicture() {
    return FadeInRight(
      duration: const Duration(milliseconds: 1200),
      child: Image.asset(
        AppAssets.profile2,
        height: 450,
        width: 400,
      ),
    );
  }

  Expanded buildAboutMeContents() {
    return Expanded(
      child: Column(
        children: [
          FadeInRight(
            duration: const Duration(milliseconds: 1200),
            child: RichText(
              text: TextSpan(
                text: "About ",
                style: AppTextStyles.headingStyles(fontSize: 30),
                children: [
                  TextSpan(
                    text: "Me!",
                    style: AppTextStyles.headingStyles(
                      fontSize: 30,
                      color: AppColors.robinEdgeBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Constants.sizedBox(height: 6),
          FadeInLeft(
            duration: const Duration(milliseconds: 1400),
            child: Text(
              "Flutter Developer!",
              style: AppTextStyles.montserratStyle(color: Colors.white),
            ),
          ),
          Constants.sizedBox(height: 8),
          FadeInLeft(
            duration: const Duration(milliseconds: 1600),
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
          Constants.sizedBox(height: 15),
          FadeInUp(
            duration: const Duration(milliseconds: 1800),
            child: AppButtons.buildMaterialButton(
              onTap: () {},
              buttonName: "Read More",
            ),
          ),
        ],
      ),
    );
  }
}
