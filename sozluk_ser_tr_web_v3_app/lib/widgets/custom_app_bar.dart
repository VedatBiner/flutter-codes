// 📃 <----- custom_app_bar.dart ----->

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarName;

  // 🔎 Arama için minimal parametreler
  final bool isSearching;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  // 🏠 YENİ: "Ana Sayfa" butonu davranışı dışarıdan gelir (opsiyonel).
  // Sağlanmazsa fallback olarak mevcut navigator stack 'i köke pop eder.
  final VoidCallback? onTapHome;

  // (Gerekirse ileride açarsın)
  // final VoidCallback? onClearSearch;
  // final VoidCallback? onStartSearch;

  const CustomAppBar({
    super.key,
    required this.appBarName,
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    this.onTapHome,
    // this.onClearSearch,
    // this.onStartSearch,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: drawerColor,
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
                  icon: const FaIcon(
                    FontAwesomeIcons.eraser,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    searchController.clear();
                    onSearchChanged('');
                    // onClearSearch?.call();
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
              // onChanged: onSearchChanged, // istersen canlı filtre
            )
          : Text(appBarName, style: itemCountStil),
      actions: [
        /// 🔍 Arama ikonları (örnek; şimdilik sadece görsel amaçlı)
        isSearching
            ? IconButton(
                tooltip: "Aramayı kapat",
                color: menuColor,
                icon: Image.asset(
                  "assets/images/close.png",
                  width: 48,
                  height: 48,
                ),
                onPressed: () {
                  searchController.clear();
                  onSearchChanged('');
                  // onClearSearch?.call();
                },
              )
            : IconButton(
                color: menuColor,
                tooltip: "Aramayı başlat",
                icon: Image.asset(
                  "assets/images/search.png",
                  width: 48,
                  height: 48,
                ),
                onPressed: () {
                  // onStartSearch?.call();
                  // (İstersen burada setState ile isSearching=true yapılır;
                  // şu an bu widget stateless olduğu için dışarıdan yönetiliyor.)
                },
              ),

        /// 🏠 Ana Sayfa ikonu (callback üzerinden)
        Transform.translate(
          offset: const Offset(0, 8),
          child: IconButton(
            tooltip: "Ana Sayfa",
            icon: Image.asset("assets/images/home.png", width: 64, height: 64),
            onPressed:
                onTapHome ??
                () {
                  // Fallback davranış: stack ’i köke kadar temizle
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
