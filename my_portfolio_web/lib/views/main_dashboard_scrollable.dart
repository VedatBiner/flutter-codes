/// Burada Scrollable_positoned_list ile geçiş deniyoruz.
/// Bu dosyayı kullanabilmek için main.dar içinde,
/// MainDashBoardScrollable() olarak değiştiriniz.
/// ListView.builder yerine ScrollablePositionedList
/// kullanıyoruz.

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../globals/app_colors.dart';
import '../globals/app_text_styles.dart';
import '../globals/constants.dart';
import 'about_me.dart';
import 'contact_us.dart';
import 'footer_class.dart';
import 'home_page.dart';
import 'my_portfolio.dart';
import 'my_services.dart';

class MainDashBoardScrollable extends StatefulWidget {
  const MainDashBoardScrollable({Key? key}) : super(key: key);

  @override
  _MainDashBoardScrollableState createState() =>
      _MainDashBoardScrollableState();
}

class _MainDashBoardScrollableState extends State<MainDashBoardScrollable> {
  _MainDashBoardScrollableState() : super();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
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
  ];

  var menuIndex = 0;

  Future scrollTo({required int index}) async {
    _itemScrollController
        .scrollTo(
      index: index,
      duration: const Duration(seconds: 2),
      curve: Curves.fastLinearToSlowEaseIn,
    )
        .whenComplete(() {
      setState(() {
        menuIndex = index;
      });
    });
  }

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
              /// Eğer mobil ekran ise burası çalışacak
              if (constraints.maxWidth < 768) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Portfolio', style: AppTextStyles.headerTextStyle()),
                    const Spacer(),
                    PopupMenuButton(
                      icon: Icon(
                        Icons.menu_sharp,
                        size: 32,
                        color: AppColors.white,
                      ),
                      color: AppColors.bgColor2,
                      position: PopupMenuPosition.under,
                      constraints: BoxConstraints.tightFor(
                        width: size.width * 0.9,
                      ),
                      itemBuilder: (BuildContext context) => menuItems
                          .asMap()
                          .entries
                          .map((e) => PopupMenuItem(
                                textStyle: AppTextStyles.headerTextStyle(
                                    color: Colors.white),
                                onTap: () {
                                  scrollTo(index: e.key);
                                },
                                child: Text(e.value),
                              ))
                          .toList(),
                    ),
                  ],
                );
              } else {
                /// Eğer tablet veya desktop boyutunda ise burası çalışacak
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
                              scrollTo(index: index);
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
        body: Scrollbar(
          trackVisibility: true,
          thumbVisibility: true,
          thickness: 8,
          child: ScrollablePositionedList.builder(
            itemCount: screensList.length,
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            itemBuilder: (context, index) {
              return screensList[index];
            },
          ),
        ));
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
