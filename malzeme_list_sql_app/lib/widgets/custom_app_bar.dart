// 📃 <----- custom_app_bar.dart ----->

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../providers/malzeme_count_provider.dart';

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
      title: isSearching
          ? TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Malzeme ara ...',
                hintStyle: hintStil,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                suffixIcon: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.eraser,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    searchController.clear();
                    onSearchChanged('');
                  },
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
          : Consumer<MalzemeCountProvider>(
              builder: (context, wordCountProvider, _) {
                return Text(
                  'Malzemeler (Ören) (${wordCountProvider.count})',
                  style: itemCountStil,
                );
              },
            ),

      actions: [
        isSearching
            ? IconButton(
                tooltip: "Aramayı kapat",
                color: menuColor,
                icon: Image.asset(
                  "assets/images/close.png",
                  width: 48,
                  height: 48,
                ),
                // icon: const Icon(Icons.clear),
                onPressed: onClearSearch,
              )
            : IconButton(
                color: menuColor,
                tooltip: "Aramayı başlat",
                icon: Image.asset(
                  "assets/images/search.png",
                  width: 48,
                  height: 48,
                ),
                onPressed: onStartSearch,
              ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
