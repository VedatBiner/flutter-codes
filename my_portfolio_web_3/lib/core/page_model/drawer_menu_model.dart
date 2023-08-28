import 'package:flutter/material.dart';

import '../constants/duration.dart';
import '../controller/main_screen_controller.dart';

class DrawerMenuModel {
  IconData? icon;
  String? title;
  void Function()? clicked;
  int? pageNumber;

  DrawerMenuModel({
    this.icon,
    this.title,
    this.clicked,
    this.pageNumber,
  });
}

List<DrawerMenuModel> drawerMenuList() => [
      DrawerMenuModel(
        icon: Icons.home,
        title: "Home",
        clicked: () => pageAnimatedTo(0),
        pageNumber: 0,
      ),
      DrawerMenuModel(
        icon: Icons.person,
        title: "About",
        clicked: () => pageAnimatedTo(1),
        pageNumber: 1,
      ),
      DrawerMenuModel(
        icon: Icons.menu_book,
        title: "Services",
        clicked: () => pageAnimatedTo(2),
        pageNumber: 2,
      ),
      DrawerMenuModel(
        icon: Icons.school,
        title: "Portfolio",
        clicked: () => pageAnimatedTo(3),
        pageNumber: 3,
      ),
      DrawerMenuModel(
        icon: Icons.message_outlined,
        title: "Contact",
        clicked: () => pageAnimatedTo(4),
        pageNumber: 4,
      ),
    ];

Future<void> pageAnimatedTo(int page) async {
  MainScreenController.instance.changePage(page);
  return MainScreenController.instance.controller.animateToPage(
    page,
    duration: PageDuration().durationMs300,
    curve: Curves.bounceIn,
  );
}
