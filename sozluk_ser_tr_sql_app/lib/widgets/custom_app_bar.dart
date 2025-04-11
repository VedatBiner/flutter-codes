// 📃 <----- custom_app_bar.dart ----->
// AppBar özelleştirme
// - Başlık ortalanmış
// - Başlık ve arama aşağı kaydırılmış
// - Drawer (hamburger) ikonu büyütülmüş ve aşağı kaydırılmış
// - Action iconlar aşağı kaydırılmış

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';

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

      /// 📌 Drawer ikon ayarları (büyütüldü & aşağı kaydırıldı)
      leading: Transform.translate(
        offset: const Offset(0, 6), // 👈 Hafif aşağı kaydırıldı
        child: Builder(
          builder:
              (context) => IconButton(
                tooltip: 'Menüyü Aç',
                icon: const Icon(Icons.menu),
                iconSize: 36, // 👈 İkon büyütüldü
                color: menuColor,
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),

      iconTheme: IconThemeData(
        color: menuColor,
        size: 36, // Yedek amaçlı büyütme burada da dursun
      ),

      titleTextStyle: TextStyle(color: menuColor),

      title:
          isSearching
              ? Transform.translate(
                offset: const Offset(0, 8), // 👈 Arama aşağı kaydırıldı
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Kelime ara ...',
                    hintStyle: hintStil,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
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
                ),
              )
              : Transform.translate(
                offset: const Offset(0, 8), // 👈 Başlık aşağı kaydırıldı
                child: Text(
                  'Sırpça-Türkçe\nSözlük ($itemCount)',
                  style: itemCountStil,
                ),
              ),

      actions: [
        Transform.translate(
          offset: const Offset(0, 8), // 👈 Action ikonları da aşağı kaydırıldı
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
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
