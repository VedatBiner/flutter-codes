import 'package:flutter/material.dart';

import '../globals/app_colors.dart';
import '../globals/app_text_styles.dart';
import '../globals/constants.dart';
import 'about_me.dart';
import 'contact_us.dart';
import 'footer_class.dart';
import 'home_page.dart';
import 'my_portfolio.dart';
import 'my_services.dart';

class MainDashBoard extends StatefulWidget {
  const MainDashBoard({Key? key}) : super(key: key);

  @override
  _MainDashBoardState createState() => _MainDashBoardState();
}

class _MainDashBoardState extends State<MainDashBoard> {
  final onMenuHover = Matrix4.identity()..scale(1.0);

  final screensList = const <Widget>[
    HomePage(),
    AboutMe(),
    MyServices(),
    MyPortfolio(),
    ContactUs(),
    // FooterClass(),
  ];

  final List<String> menuItems = [
    "Home",
    "About",
    "Services",
    "Portfolio",
    "Contact",
    // "", // Ekstra bir seçenek olarak eklenmiş.
  ];

  var menuIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        toolbarHeight: 90,
        titleSpacing: 40,
        elevation: 0,
        title: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 768) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Portfolio', style: AppTextStyles.headerTextStyle()),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.menu_sharp,
                      size: 32,
                      color: Colors.white,
                    ),
                    position: PopupMenuPosition.under,
                    onSelected: (String result) {
                      setState(() {
                        // Tıklanan öğeyi belirle ve menuIndex'i güncelle
                        menuIndex = menuItems.indexOf(result);
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return menuItems.map((String option) {
                        return PopupMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: AppTextStyles.normalStyle(
                              color: menuIndex == menuItems.indexOf(option)
                                  ? AppColors.themeColor
                                  : Colors.black54,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    elevation: 5,
                    color: AppColors.robinEdgeBlue,
                  ),
                ],
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Portfolio',
                    style: AppTextStyles.headerTextStyle(),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 30,
                    child: ListView.separated(
                      itemCount: menuItems.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, child) =>
                          Constants.sizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print("Seçenek $index seçildi.");
                            setState(() {
                              // Tıklanan öğeyi belirle ve menuIndex'i güncelle
                              menuIndex = index;
                              screensList[index];
                            });
                          },
                          borderRadius: BorderRadius.circular(100),
                          onHover: (value) {
                            setState(() {
                              if (value) {
                                menuIndex = index;
                              } else {
                                menuIndex = 0;
                              }
                            });
                          },
                          child: buildNavBarAnimatedContainer(
                              index, menuIndex == index ? true : false),
                        );
                      },
                    ),
                  ),
                  Constants.sizedBox(width: 30),
                ],
              );
            }
          },
        ),
      ),
      body: ListView.builder(
        itemCount: screensList.length,
        itemBuilder: (context, index) {
          return menuIndex == index
              ? screensList[index]
              : const SizedBox.shrink();
        },
      ),
    );
  }

  AnimatedContainer buildNavBarAnimatedContainer(int index, bool hover) {
    return AnimatedContainer(
      alignment: Alignment.center,
      width: hover ? 80 : 75,
      duration: const Duration(milliseconds: 200),
      transform: hover ? onMenuHover : null,
      child: Text(
        menuItems[index],
        style: AppTextStyles.headerTextStyle(
            color: hover ? AppColors.themeColor : AppColors.white),
      ),
    );
  }
}
