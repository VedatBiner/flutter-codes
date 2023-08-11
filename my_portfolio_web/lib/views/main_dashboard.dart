import 'package:flutter/material.dart';
import 'package:my_portfolio_web/views/about_me.dart';
import 'package:my_portfolio_web/views/home_page.dart';
import '../globals/app_colors.dart';
import '../globals/app_text_styles.dart';
import '../globals/constants.dart';
import 'contact_us.dart';
import 'my_portfolio.dart';
import 'my_services.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final menuItems = <String>[
    "Home",
    "About",
    "Services",
    "Portfolio",
    "Contact",
  ];

  final onMenuHover = Matrix4.identity()..scale(1.0);
  var menuIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      /// backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        toolbarHeight: 90,
        titleSpacing: 40,
        elevation: 0,
        title: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 768) {
            return Row(
              children: [
                Text(
                  "Portfolio",
                  style: AppTextStyles.headerTextStyle(),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.menu_sharp,
                    size: 32,
                    color: AppColors.white,
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Text(
                  "Portfolio",
                  style: AppTextStyles.headerTextStyle(),
                ),
                const Spacer(),
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, child) => Constants.sizedBox(
                      width: 8,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(100),
                        child: buildNavBarAnimatedcontainer(
                            index, menuIndex == index ? true : false),
                        onHover: (value) {
                          setState(() {
                            if (value) {
                              menuIndex = index;
                            } else {
                              menuIndex = 0;
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                Constants.sizedBox(width: 30),
              ],
            );
          }
        }),
      ),
      body: const ContactUs(),
    );
  }

  AnimatedContainer buildNavBarAnimatedcontainer(int index, bool hover) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.center,
      width: hover ? 80 : 75,
      transform: hover ? onMenuHover : null,
      child: Text(
        menuItems[index],
        style: AppTextStyles.headerTextStyle(
          color: hover ? AppColors.themeColor : AppColors.white,
        ),
      ),
    );
  }
}
