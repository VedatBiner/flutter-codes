import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio_web/globals/app_assets.dart';
import 'package:my_portfolio_web/globals/app_buttons.dart';
import 'package:my_portfolio_web/globals/app_colors.dart';
import 'package:my_portfolio_web/globals/app_text_styles.dart';
import 'package:my_portfolio_web/globals/constants.dart';
import 'package:my_portfolio_web/helperclass/helper_class.dart';

class MyServices extends StatefulWidget {
  const MyServices({super.key});

  @override
  State<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  bool isApp = false, isGraphic = false, isDataAnalyst = false;
  final onHoverActive = Matrix4.identity()..translate(0, -10, 0);
  final onHoverRemove = Matrix4.identity()..translate(0, 0, 0);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return HelperClass(
        mobile: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildMyServicesText(),
            Constants.sizedBox(height: 60),
            InkWell(
              onTap: () {},
              onHover: (value) {
                setState(() {
                  isApp = value;
                });
              },
              child: buildAnimatedContainer(
                title: "App Development",
                asset: AppAssets.code,
                hover: isApp,
              ),
            ),
            Constants.sizedBox(height: 24),
            InkWell(
              onTap: () {},
              onHover: (value) {
                setState(() {
                  isGraphic = value;
                });
              },
              child: buildAnimatedContainer(
                title: "Graphic Design",
                asset: AppAssets.brush,
                hover: isGraphic,
              ),
            ),
            Constants.sizedBox(height: 24),
            InkWell(
              onTap: () {},
              onHover: (value) {
                setState(() {
                  isDataAnalyst = value;
                });
              },
              child: buildAnimatedContainer(
                title: "Digital Marketing",
                asset: AppAssets.analyst,
                hover: isDataAnalyst,
              ),
            ),
          ],
        ),
        tablet: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildMyServicesText(),
            Constants.sizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  onHover: (value) {
                    setState(() {
                      isApp = value;
                    });
                  },
                  child: buildAnimatedContainer(
                    title: "App Development",
                    asset: AppAssets.code,
                    hover: isApp,
                  ),
                ),
                Constants.sizedBox(width: 24),
                InkWell(
                  onTap: () {},
                  onHover: (value) {
                    setState(() {
                      isGraphic = value;
                    });
                  },
                  child: buildAnimatedContainer(
                    title: "Graphic Design",
                    asset: AppAssets.brush,
                    hover: isGraphic,
                  ),
                ),
              ],
            ),
            Constants.sizedBox(width: 26),
            InkWell(
              onTap: () {},
              onHover: (value) {
                setState(() {
                  isDataAnalyst = value;
                });
              },
              child: buildAnimatedContainer(
                title: "Digital Marketing",
                asset: AppAssets.analyst,
                hover: isDataAnalyst,
                width: 725,
                hoverWidth: 735,
              ),
            ),
          ],
        ),
        desktop: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildMyServicesText(),
            Constants.sizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  onHover: (value) {
                    setState(() {
                      isApp = value;
                    });
                  },
                  child: buildAnimatedContainer(
                    title: "App Development",
                    asset: AppAssets.code,
                    hover: isApp,
                  ),
                ),
                Constants.sizedBox(width: 24),
                InkWell(
                  onTap: () {},
                  onHover: (value) {
                    setState(() {
                      isGraphic = value;
                    });
                  },
                  child: buildAnimatedContainer(
                    title: "Graphic Design",
                    asset: AppAssets.brush,
                    hover: isGraphic,
                  ),
                ),
                Constants.sizedBox(width: 24),
                InkWell(
                  onTap: () {},
                  onHover: (value) {
                    setState(() {
                      isDataAnalyst = value;
                    });
                  },
                  child: buildAnimatedContainer(
                    title: "Digital Marketing",
                    asset: AppAssets.analyst,
                    hover: isDataAnalyst,
                  ),
                ),
              ],
            ),
          ],
        ),
        paddingWidth: size.width * 0.1,
        bgColor: AppColors.bgColor,
    );
  }

  FadeInDown buildMyServicesText() {
    return FadeInDown(
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
                color: AppColors.robinEdgeBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildAnimatedContainer({
    required String title,
    required String asset,
    required bool hover,
    double width = 350,
    double hoverWidth = 360,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      width: hover ? hoverWidth : width,
      height: hover ? 390 : 380,
      alignment: Alignment.center,
      transform: hover ? onHoverActive : onHoverRemove,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgColor2,
        borderRadius: BorderRadius.circular(30),
        border: hover
            ? Border.all(
                color: AppColors.themeColor,
                width: 3,
              )
            : null,
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 4.0,
            blurRadius: 4.5,
            offset: Offset(3.0, 4.5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppTextStyles.montserratStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Constants.sizedBox(height: 30.0),
          Image.asset(
            asset,
            width: 50,
            height: 50,
            color: AppColors.themeColor,
          ),
          Constants.sizedBox(height: 12.0),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing "
            "elit, sed do eiusmod tempor incididunt ut labore et "
            "dolore magna aliqua.",
            style: AppTextStyles.normalStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Constants.sizedBox(height: 20.0),
          AppButtons.buildMaterialButton(
            buttonName: "Read More",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
