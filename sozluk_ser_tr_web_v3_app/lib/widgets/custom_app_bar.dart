// 📃 <----- lib/widgets/custom_app_bar.dart ----->
//
// CustomAppBar: Drawer butonu, başlık, arama alanı ve “Ana Sayfa” ikonu.
// Arama modunu dışarıdan (parent) yönetebilmek için:
//   - isSearching (bool)
//   - onStartSearch()  → sağdaki “ara” ikonuna basınca tetiklenir
//   - onClearSearch()  → sağdaki “kapat” ikonuna basınca tetiklenir
// Ayrıca canlı filtre için:
//   - searchController
//   - onSearchChanged(String)
//
// Ana Sayfa ikonu callback’i:
//   - onTapHome() verilirse onu, verilmezse fallback olarak navigator stack’i köke pop eder.

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarName;

  // 🔎 Arama için parametreler
  final bool isSearching;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  /// 🏠 Opsiyonel: “Ana Sayfa” ikonu davranışı
  final VoidCallback? onTapHome;

  /// 🔁 Opsiyonel: Arama modunu aç/kapa callback ’leri
  final VoidCallback? onStartSearch;
  final VoidCallback? onClearSearch;

  ///🔺 AppBar yüksekliği (iki satır başlık için biraz büyük)
  static const double _barHeight = 72;

  const CustomAppBar({
    super.key,
    required this.appBarName,
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    this.onTapHome,
    this.onStartSearch,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: drawerColor,
      toolbarHeight: _barHeight,
      iconTheme: IconThemeData(color: menuColor), // Drawer butonu rengi
      titleTextStyle: TextStyle(color: menuColor),
      title: isSearching
          ? TextField(
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
                  tooltip: 'Metni temizle',
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
              onChanged: onSearchChanged, // canlı filtre
            )
          : RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Sırpça-Türkçe Sözlük", style: itemCountStil),
                  TextSpan(
                    text: "\nFirestore WEB & Mobil",
                    style: itemCountStil,
                  ),
                ],
              ),
            ),

      // Text(
      //         appBarName,
      //         style: itemCountStil,
      //         maxLines: 2,
      //         overflow: TextOverflow.visible,
      //         softWrap: true,
      //       ),
      actions: [
        // 🔍 Arama ikonları
        isSearching
            ? IconButton(
                tooltip: "Aramayı kapat",
                color: menuColor,
                icon: Image.asset(
                  "assets/images/close.png",
                  width: 64,
                  height: 64,
                ),
                onPressed: () {
                  // dışarıdan state ’i kapat
                  onClearSearch?.call();
                },
              )
            : IconButton(
                color: menuColor,
                tooltip: "Aramayı başlat",
                icon: Image.asset(
                  "assets/images/search.png",
                  width: 64,
                  height: 64,
                ),
                onPressed: () {
                  // dışarıdan state ’i aç
                  onStartSearch?.call();
                },
              ),

        // 🏠 Ana Sayfa ikonu (callback üzerinden)
        IconButton(
          tooltip: "Ana Sayfa",
          icon: Image.asset("assets/images/home.png", width: 64, height: 64),
          onPressed:
              onTapHome ??
              () {
                // Fallback: stack ’i köke kadar temizle
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_barHeight);
}
