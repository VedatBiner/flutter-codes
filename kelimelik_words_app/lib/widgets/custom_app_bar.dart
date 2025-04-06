// 📃 <----- custom_app_bar.dart ----->

import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/color_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onStartSearch;
  final int itemCount;

  const CustomAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onStartSearch,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(color: menuColor),
      titleTextStyle: TextStyle(color: menuColor),
      title:
          isSearching
              ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Kelime ara ...',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: menuColor, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: menuColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: onSearchChanged,
              )
              : Text(
                'Kelimelik ($itemCount)',
                style: TextStyle(
                  color: menuColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      actions: [
        isSearching
            ? IconButton(
              color: menuColor,
              icon: Image.asset(
                "assets/images/close.png",
                width: 32,
                height: 32,
              ),
              // icon: const Icon(Icons.clear),
              onPressed: onClearSearch,
            )
            : IconButton(
              color: menuColor,
              icon: Image.asset(
                "assets/images/search.png",
                width: 32,
                height: 32,
              ),
              onPressed: onStartSearch,
            ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
