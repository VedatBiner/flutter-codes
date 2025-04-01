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
      backgroundColor: Colors.indigo,
      iconTheme: const IconThemeData(color: Colors.amber),
      titleTextStyle: const TextStyle(color: Colors.amber),
      title:
          isSearching
              ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Kelime veya anlamını ara ...',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: onSearchChanged,
              )
              : Text(
                'Kelimelik ($itemCount)',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      actions: [
        isSearching
            ? IconButton(
              color: Colors.amber,
              icon: const Icon(Icons.clear),
              onPressed: onClearSearch,
            )
            : IconButton(
              color: Colors.amber,
              icon: const Icon(Icons.search),
              onPressed: onStartSearch,
            ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
