/// <----- drawer_items.dart ----->
/// Drawer seçeneklerini gösteren metot

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants/constants.dart';
import '../../services/theme_provider.dart';
import '../../services/app_routes.dart';

Drawer buildDrawer(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  return Drawer(
    shadowColor: Colors.lightBlue,
    backgroundColor: drawerColor,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: drawerColor,
          ),
          child: Text(
            drawerTitle,
            style: baslikTextDrawer,
          ),
        ),
        for (var item in drawerItems)
          buildListTile(context, item["title"], (BuildContext context) {
            final pageRoute = AppRoute.routes[item["page"]];
            return pageRoute != null ? pageRoute(context) : Container();
          }),
        const SizedBox(height: 32),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              color: menuColor,
              onPressed: () {
                final provider =
                Provider.of<ThemeProvider>(context, listen: false);
                provider.toggleTheme(!provider.isDarkMode);
              },
              icon: Icon(
                themeProvider.isDarkMode ? Icons.wb_sunny : Icons.brightness_3,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


ListTile buildListTile(
  BuildContext context,
  String text,
  Widget Function(BuildContext) pageRouteGetter,
) {
  return ListTile(
    textColor: menuColor,
    title: Text(text),
    onTap: () {
      Navigator.pop(context); // Drawer'ı kapat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pageRouteGetter(context),
        ),
      );
    },
  );
}
