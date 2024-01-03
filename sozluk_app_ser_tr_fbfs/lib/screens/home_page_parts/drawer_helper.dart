/// <----- drawer_helper ----->
/// Drawer seçeneklerini gösteren metot

import 'package:flutter/material.dart';

ListTile buildListTile(
  BuildContext context,
  String text,
  pageRoute,
) {
  return ListTile(
    textColor: Colors.amber,
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
