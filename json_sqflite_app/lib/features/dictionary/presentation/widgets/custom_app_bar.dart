// <----- 📜 custom_app_bar.dart ----->
// -----------------------------------------------------------------------------
// AppBar oluşturmak için kullanılan widget
// -----------------------------------------------------------------------------
//
import 'package:flutter/material.dart';

import 'search_input.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final void Function(String) onSearchChanged;
  final VoidCallback onSearchToggle;
  final int itemCount;

  const CustomAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchToggle,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.blueAccent,
      iconTheme: const IconThemeData(color: Colors.amber),
      centerTitle: true,
      title:
          isSearching
              ? SearchInput(
                controller: searchController,
                onChanged: onSearchChanged,
              )
              : Column(
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    "Sırpça-Türkçe Sözlük",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    "SQLite ($itemCount madde)",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      actions: [
        IconButton(
          icon: Icon(isSearching ? Icons.close : Icons.search),
          onPressed: onSearchToggle,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
