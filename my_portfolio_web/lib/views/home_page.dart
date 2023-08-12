import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio_web/globals/app_assets.dart';
import 'package:my_portfolio_web/globals/app_colors.dart';
import 'package:my_portfolio_web/globals/app_text_styles.dart';
import 'package:my_portfolio_web/globals/constants.dart';
import 'package:my_portfolio_web/helperclass/helper_class.dart';
import 'package:my_portfolio_web/widgets/profile_animation.dart';
import '../globals/app_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final socialButtons = <String>[
    AppAssets.facebook,
    AppAssets.twitter,
    AppAssets.linkedin,
    AppAssets.instagram,
    AppAssets.github,
    AppAssets.medium,
    AppAssets.telegram,
  ];

  var socialBI;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return HelperClass(
      mobile: Column(
        children: [
          buildHomePersonalInfo(size),
          Constants.sizedBox(height: 25.0),
          const ProfileAnimation()
        ],
      ),
      tablet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: buildHomePersonalInfo(size)),
          const ProfileAnimation(),
        ],
      ),
      desktop: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: buildHomePersonalInfo(size)),
          const ProfileAnimation(),
        ],
      ),
      paddingWidth: size.width * 0.1,
      bgColor: Colors.transparent,
    );
  }

  Column buildHomePersonalInfo(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 1200),
          child: Text(
            "Hello, It\'s Me",
            style: AppTextStyles.montserratStyle(
              color: Colors.white,
            ),
          ),
        ),
        Constants.sizedBox(height: 15),
        FadeInDownBig(
          duration: const Duration(milliseconds: 1400),
          child: Text(
            "Vedat Biner",
            style: AppTextStyles.headingStyles(),
          ),
        ),
        Constants.sizedBox(height: 15),
        FadeInLeftBig(
          duration: const Duration(milliseconds: 1400),
          child: Text(
            "and I'm a,",
            style: AppTextStyles.montserratStyle(color: Colors.white),
          ),
        ),
        FadeInLeft(
          duration: const Duration(milliseconds: 1400),
          child: Row(
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    "Flutter Developer",
                    textStyle: AppTextStyles.montserratStyle(
                      /// fontSize: 15,
                      color: Colors.blueAccent,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                  TyperAnimatedText(
                    "Python Developer",
                    textStyle: AppTextStyles.montserratStyle(
                      color: Colors.blueAccent,

                      /// fontSize: 15,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                  TyperAnimatedText(
                    "Frontend Web Developer",
                    textStyle: AppTextStyles.montserratStyle(
                      color: Colors.blueAccent,

                      /// fontSize: 15,
                    ),
                    speed: const Duration(milliseconds: 75),
                  ),
                  TyperAnimatedText(
                    "System Administrator",
                    textStyle: AppTextStyles.montserratStyle(
                      color: Colors.blueAccent,

                      /// fontSize: 15,
                    ),
                    speed: const Duration(milliseconds: 75),
                  ),
                  TyperAnimatedText(
                    "Freelancer",
                    textStyle: AppTextStyles.montserratStyle(
                      color: Colors.blueAccent,

                      ///  fontSize: 15,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                pause: const Duration(milliseconds: 1000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ],
          ),
        ),
        Constants.sizedBox(height: 15),
        FadeInDown(
          duration: const Duration(milliseconds: 1600),
          child: Expanded(
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
        ),
        Constants.sizedBox(height: 22),
        FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: SizedBox(
            height: 48,
            child: ListView.separated(
              itemCount: socialButtons.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, child) =>
                  Constants.sizedBox(width: 8.0),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  onHover: (value) {
                    setState(() {
                      if (value) {
                        socialBI = index;
                      } else {
                        socialBI = null;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(550.0),
                  hoverColor: AppColors.themeColor,
                  splashColor: AppColors.lawGreen,
                  child: buildSocialButton(
                      asset: socialButtons[index],
                      hover: socialBI == index ? true : false),
                );
              },
            ),
          ),
        ),
        Constants.sizedBox(height: 18),
        FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: AppButtons.buildMaterialButton(
            onTap: () {},
            buttonName: "Download CV",
          ),
        ),
      ],
    );
  }

  Ink buildSocialButton({
    required String asset,
    required bool hover,
  }) {
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
      child: Image.asset(
        asset,
        width: 10,
        height: 12,
        color: hover ? AppColors.bgColor : AppColors.themeColor,
        fit: BoxFit.fill,
      ),
    );
  }
}
