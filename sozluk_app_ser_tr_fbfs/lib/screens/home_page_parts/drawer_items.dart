/// <----- drawer_items ----->
/// Drawer seçeneklerini gösteren metot

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../constants/base_constants/app_const.dart';

Drawer buildDrawer(BuildContext context,
    {required Function themeChangeCallback}) {
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
          child: const Text(
            "Yardımcı Bilgiler",
            style: baslikTextWhite,
          ),
        ),
        for (var item in drawerItems)
          buildListTile(context, item["title"], item["page"]),
        const SizedBox(height: 32),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              color: menuColor,
              onPressed: () {
                themeChangeCallback(); // Ana sayfadaki theme değişim fonksiyonunu çağır
              },
              icon: Icon(
                AppConst.listener.themeNotifier.isDarkMode
                    ? Icons.wb_sunny
                    : Icons.brightness_3,
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
  pageRoute,
) {
  return ListTile(
    textColor: menuColor,
    title: Text(text),
    onTap: () {
      Navigator.pop(context); // Drawer'ı kapat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pageRoute,
        ),
      );
    },
  );
}
