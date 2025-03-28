// 📃 <----- custom_app_bar.dart ----->

import 'package:flutter/material.dart';

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
      title:
          isSearching
              ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Ara...',
                  border: InputBorder.none,
                ),
                onChanged: onSearchChanged,
              )
              : Text('Kelimelik ($itemCount)'),
      actions: [
        isSearching
            ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: onClearSearch,
            )
            : IconButton(
              icon: const Icon(Icons.search),
              onPressed: onStartSearch,
            ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
