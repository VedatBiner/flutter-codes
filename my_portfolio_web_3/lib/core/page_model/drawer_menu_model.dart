import 'package:flutter/material.dart';
import '../../design/drawer/drawer_menu_list.dart';

class DrawerMenuModel {
  IconData icon;
  String title;
  void Function() clicked;

  DrawerMenuModel({
    required this.icon,
    required this.title,
    required this.clicked,
  });
}

List<DrawerMenuModel> drawerMenuList() => [
      DrawerMenuModel(
        icon: Icons.home,
        title: "Home",
        clicked: () => pageAnimatedTo(0,),
      ),
      DrawerMenuModel(
        icon: Icons.person,
        title: "About",
        clicked: () => pageAnimatedTo(1),
      ),
      DrawerMenuModel(
        icon: Icons.menu_book,
        title: "Services",
        clicked: () => pageAnimatedTo(2),
      ),
      DrawerMenuModel(
        icon: Icons.school,
        title: "Portfolio",
        clicked: () => pageAnimatedTo(3),
      ),
      DrawerMenuModel(
        icon: Icons.message_outlined,
        title: "Contact",
        clicked: () => pageAnimatedTo(4),
      ),
    ];

