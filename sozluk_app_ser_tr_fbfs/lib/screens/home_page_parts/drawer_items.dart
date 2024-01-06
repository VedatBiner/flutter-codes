/// <----- drawer_items ----->
/// Drawer seçeneklerini gösteren metot

import 'package:flutter/material.dart';

import '../../constants/constants.dart';

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
