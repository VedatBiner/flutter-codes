import 'package:flutter/material.dart';

import '../../core/extension/theme_extension.dart';
import '../../core/extension/widget_extension.dart';
import '../../core/page_model/drawer_menu_model.dart';
import '../../design/drawer/drawer_menu_list.dart';

// ignore: must_be_immutable
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          drawerLogoField(),
          drawerControllerPanel(),
        ],
      ),
    );
  }

  Widget drawerControllerPanel() {
    return Column(
      children: [
        const Spacer(flex: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  drawerMenuList().map((e) => drawerMenuListWidget(e)).toList(),
            ),
          ],
        ),
        const Spacer(flex: 5),
      ],
    ).expanded(73);
  }

  Container drawerLogoField() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.home, size: 46).expanded(27),
    );
  }
}
