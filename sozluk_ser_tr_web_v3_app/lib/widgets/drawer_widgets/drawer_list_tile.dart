// 📃 <----- drawer_list_tile.dart ----->
// Drawer menüsünde tekrar eden ListTile yapısı için widget.

import 'package:flutter/material.dart';

import '../../constants/text_constants.dart';

class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String routeName;
  final Color iconColor;

  const DrawerListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.routeName,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: drawerMenuText),
      onTap: () {
        Navigator.of(context).maybePop();
        Navigator.of(context).pushNamed(routeName);
      },
    );
  }
}
