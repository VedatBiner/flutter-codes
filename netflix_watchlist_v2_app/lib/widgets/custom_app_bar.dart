// 📁 lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../controllers/theme_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchVisible;
  final VoidCallback onSearchPressed;
  final VoidCallback onStatsPressed;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const CustomAppBar({
    super.key,
    required this.isSearchVisible,
    required this.onSearchPressed,
    required this.onStatsPressed,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return AppBar(
      iconTheme: IconThemeData(color: drawerMenuTitleText.color),
      title: Text("Netflix Watchlist", style: appBarTitleText),
      actions: [
        // 🔍 ARAMA BUTONU
        IconButton(
          icon: Icon(Icons.search, color: drawerMenuTitleText.color),
          tooltip: "Ara",
          onPressed: onSearchPressed,
        ),

        // 📊 İSTATİSTİK SAYFASI
        IconButton(
          icon: Icon(Icons.bar_chart, color: drawerMenuTitleText.color),
          tooltip: "İstatistikler",
          onPressed: onStatsPressed,
        ),

        // 🌙 TEMA BUTONU
        IconButton(
          icon: Icon(Icons.brightness_6, color: drawerMenuTitleText.color),
          tooltip: "Tema Değiştir",
          onPressed: themeController.toggleTheme,
        ),
      ],
      bottom: isSearchVisible
          ? PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Ara (Dizi, Film, Bölüm)...",
                    prefixIcon: const Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: menuColor, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: menuColor, width: 2.0),
                    ),
                  ),
                  onChanged: onSearchChanged,
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (isSearchVisible ? 56.0 : 0));
}
