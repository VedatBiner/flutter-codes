// 📃 <----- custom_app_bar.dart ----->
// AppBar özelleştirme

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../providers/word_count_provider.dart';
import '../screens/home_page.dart';

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
      centerTitle: true,

      leading: Transform.translate(
        offset: const Offset(0, 2),
        child: Builder(
          builder:
              (context) => IconButton(
                tooltip: 'Menüyü Aç',
                icon: const Icon(Icons.menu),
                iconSize: 36,
                color: menuColor,
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),

      iconTheme: IconThemeData(color: menuColor, size: 36),
      titleTextStyle: TextStyle(color: menuColor),

      title:
          isSearching
              ? Transform.translate(
                offset: const Offset(0, 6),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Kelime ara ...',
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
                ),
              )
              : Transform.translate(
                offset: const Offset(0, 4),
                child: Consumer<WordCountProvider>(
                  builder: (context, wordCountProvider, _) {
                    return Text(
                      'Sırpça-Türkçe\nSözlük (${wordCountProvider.count})',
                      style: itemCountStil,
                    );
                  },
                ),
              ),

      actions: [
        Transform.translate(
          offset: const Offset(0, 8),
          child:
              isSearching
                  ? IconButton(
                    tooltip: "Aramayı kapat",
                    color: menuColor,
                    icon: Image.asset(
                      "assets/images/close.png",
                      width: 64,
                      height: 64,
                    ),
                    onPressed: onClearSearch,
                  )
                  : IconButton(
                    tooltip: "Aramayı başlat",
                    color: menuColor,
                    icon: Image.asset(
                      "assets/images/search.png",
                      width: 64,
                      height: 64,
                    ),
                    onPressed: onStartSearch,
                  ),
        ),

        /// Ana Sayfa ikonu
        Transform.translate(
          offset: const Offset(0, 8),
          child: IconButton(
            tooltip: "Ana Sayfa",
            icon: Image.asset("assets/images/home.png", width: 64, height: 64),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);
}
