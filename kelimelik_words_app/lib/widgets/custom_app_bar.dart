// 📃 <----- custom_app_bar.dart ----->

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../providers/item_count_provider.dart';
import '../widgets/safe_text_field.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onStartSearch;
  final VoidCallback onDrawerPressed;
  final FocusNode searchFocusNode;
  final int itemCount;

  const CustomAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onStartSearch,
    required this.onDrawerPressed,
    required this.searchFocusNode,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(color: menuColor),
      titleTextStyle: TextStyle(color: menuColor),
      automaticallyImplyLeading: false,

      leading: IconButton(
        icon: Icon(Icons.menu, color: menuColor),
        tooltip: 'Menü',
        onPressed: onDrawerPressed, // ✅ kontrol HomePage’de
      ),

      /// 🔍 Arama modu
      title: isSearching
          ? SafeTextField(
              focusBorderColor: menuColor,
              controller: searchController,
              autofocus: false,
              onChanged: onSearchChanged,
              focusNode: searchFocusNode,
              fillColor: Colors.white,
              hint: 'Kelime ara ...',
              hintStyle: hintStil,
              height: 8,
              // width: 12,

              /// Silme butonu
              suffixIcon: IconButton(
                icon: const FaIcon(FontAwesomeIcons.eraser, color: Colors.red),
                onPressed: () {
                  searchController.clear();
                  onSearchChanged('');
                },
              ),
            )
          : Consumer<WordCountProvider>(
              builder: (context, wordCountProvider, _) {
                return Text(
                  'Kelimelik (${wordCountProvider.count})',
                  style: itemCountStil,
                );
              },
            ),

      /// 🔧 Aksiyonlar
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
