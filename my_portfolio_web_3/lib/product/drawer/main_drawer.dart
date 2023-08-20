import 'package:flutter/material.dart';
import 'package:my_portfolio_web_3/core/page_model/drawer/drawer_menu_model.dart';
import '../../core/page_model/drawer/drawer_menu_list.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({required this.controller, super.key});

  PageController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 27,
            child: Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.home,
                size: 46,
              ),
            ),
          ),
          Expanded(
            flex: 73,
            child: Column(
              children: [
                const Spacer(flex: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: drawerMenuList(controller)
                            .map((e) => drawerMenuListWidget(e))
                            .toList()),
                  ],
                ),
                const Spacer(flex: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
