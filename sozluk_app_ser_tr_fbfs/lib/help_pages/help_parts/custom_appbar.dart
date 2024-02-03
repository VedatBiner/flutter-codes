/// <----- custom_app_bar.dart ----->
library;

import 'package:flutter/material.dart';

import '../../services/app_routes.dart';
import '../../constants/app_constants/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  const CustomAppBar({
    super.key,
    required this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        appBarTitle,
        style: TextStyle(
          color: menuColor,
        ),
      ),
      iconTheme: IconThemeData(color: menuColor),
      actions: [
        IconButton(
          icon: Icon(
            Icons.home,
            color: menuColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppRoute.routes[AppRoute.home]!(context),
              ),
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
