/// <----- app_bar_tr_ser.dart ----->
library;

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';

class CustomAppBarTrSer extends StatelessWidget implements PreferredSizeWidget {
  final bool aramaYapiliyorMu;
  final String aramaKelimesi;
  final Function(String) onAramaKelimesiChanged;
  final Function() onCancelPressed;
  final Function() onSearchPressed;

  const CustomAppBarTrSer({
    super.key,
    required this.aramaYapiliyorMu,
    required this.aramaKelimesi,
    required this.onAramaKelimesiChanged,
    required this.onCancelPressed,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: drawerColor,
      title: aramaYapiliyorMu
          ? TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Aradığınız kelimeyi yazınız ...",
                hintStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),
              ),
              onChanged: onAramaKelimesiChanged,
            )
          : Text(
              appBarMainTitleTrSer,
              style: TextStyle(color: menuColor),
            ),
      iconTheme: IconThemeData(color: menuColor),
      actions: [
        aramaYapiliyorMu
            ? IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                onPressed: onCancelPressed,
              )
            : IconButton(
                icon: Icon(
                  Icons.search,
                  color: menuColor,
                ),
                onPressed: onSearchPressed,
              ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
