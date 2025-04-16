// 📃 <----- custom_app_bar.dart ----->
// AppBar özelleştirme
// - Başlık ortalanmış
// - Başlık ve arama aşağı kaydırılmış
// - Drawer (hamburger) ikonu büyütülmüş ve aşağı kaydırılmış
// - Action iconlar aşağı kaydırılmış
// - Gerçek cihazda yazı ve arama kutusu kesilme sorunu çözüldü

import 'package:flutter/material.dart';
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

  const CustomAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onStartSearch,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: drawerColor,
      centerTitle: true,

      /// 📌 Drawer ikon ayarları (büyütüldü & aşağı kaydırıldı)
      leading: Transform.translate(
        offset: const Offset(0, 2), // Hafif aşağı kaydırıldı
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
                offset: const Offset(0, 6), // Arama kutusunu aşağı kaydır
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
          offset: const Offset(0, 8), // 👈 Action ikonlarını aşağı kaydır
          child:
              isSearching
                  /// 📌 aramayı kapat
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
                  /// 📌 aramayı başlat
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

        /// 📌 Ana Sayfa ikonu
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

  /// 📌 AppBar yüksekliği arttırıldı → Gerçek cihazda kesilme sorunu çözümü
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);
}
