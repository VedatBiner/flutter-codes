import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio_web/globals/app_assets.dart';
import '../globals/app_colors.dart';
import '../globals/app_text_styles.dart';
import '../globals/constants.dart';

class MyPortfolio extends StatefulWidget {
  const MyPortfolio({super.key});

  @override
  State<MyPortfolio> createState() => _MyPortfolioState();
}

class _MyPortfolioState extends State<MyPortfolio> {
  final onHoverEffect = Matrix4.identity()..scale(1.0);
  List images = <String>[
    AppAssets.work1,
    AppAssets.work2,
    AppAssets.work1,
    AppAssets.work2,
    AppAssets.work1,
    AppAssets.work2,
  ];

  var hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.8,
      color: AppColors.bgColor2,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: size.width * 0.1,
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
                      color: AppColors.robinEdgeBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Constants.sizedBox(height: 40),
          GridView.builder(
            itemCount: images.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 280,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
            ),
            itemBuilder: (context, index) {
              var image = images[index];
              return FadeInUpBig(
                duration: const Duration(milliseconds: 1600),
                child: InkWell(
                  onTap: () {},
                  onHover: (value) {
                    setState(() {
                      if (value) {
                        hoveredIndex = index;
                      } else {
                        hoveredIndex = null;
                      }
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: AssetImage(image),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Visibility(
                        visible: index == hoveredIndex,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform:
                              index == hoveredIndex ? onHoverEffect : null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.themeColor.withOpacity(1.0),
                                AppColors.themeColor.withOpacity(0.9),
                                AppColors.themeColor.withOpacity(0.8),
                                AppColors.themeColor.withOpacity(0.8),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "App Development",
                                style: AppTextStyles.montserratStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                ),
                              ),
                              Constants.sizedBox(height: 15.0),
                              Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing "
                                "elit, sed do eiusmod tempor incididunt ut labore et ",
                                style: AppTextStyles.normalStyle(
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Constants.sizedBox(height: 30),
                              CircleAvatar(
                                maxRadius: 25,
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  AppAssets.share,
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
