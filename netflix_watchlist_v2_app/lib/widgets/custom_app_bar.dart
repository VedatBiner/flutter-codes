// 📁 lib/widgets/custom_app_bar.dart
//
// ============================================================================
// 🧩 CustomAppBar – Uygulamanın Üst AppBar Bileşeni (Search + Stats + Tema)
// ============================================================================
//
// Bu dosya, HomePage üzerinde kullanılan üst AppBar ’ı tek bir yerde toplar.
// Amaç: HomePage içindeki AppBar kodunu şişirmeden, tekrar kullanılabilir ve
// yönetilebilir bir üst bar üretmek.
//
// ---------------------------------------------------------------------------
// 🔹 Bu AppBar neleri yapar?
// ---------------------------------------------------------------------------
// 1) Uygulama başlığını gösterir (“Netflix Watchlist”).
// 2) Arama ikonuna basınca arama alanını (TextField) aç/kapatır.
// 3) İstatistik ikonuna basınca Stats sayfasına geçişi tetikler
//    (navigasyon burada yapılmaz, callback ile HomePage’e bırakılır).
// 4) Tema ikonuna basınca ThemeController üzerinden Dark/Light mod değiştirir.
// 5) Arama alanı açıkken kullanıcının yazdığı metni HomePage’e callback ile iletir.
//
// ---------------------------------------------------------------------------
// 🔹 Neden StatelessWidget + PreferredSizeWidget?
// ---------------------------------------------------------------------------
// • AppBar, Scaffold.appBar alanında kullanılırken bir “yükseklik” ister.
// • PreferredSizeWidget ile “arama alanı açıkken yükseklik artıyor” bilgisini
//   AppBar ’a doğru şekilde bildiririz.
// • Bu widget state tutmaz; state HomePage’dedir (isSearchVisible vb.).
//
// ---------------------------------------------------------------------------
// 🔹 Dışarıdan beklediği parametreler
// ---------------------------------------------------------------------------
// • isSearchVisible      → search alanı açık mı kapalı mı?
// • onSearchPressed      → arama ikonuna basılınca ne yapılacak? (toggle)
// • onStatsPressed       → stats ikonuna basılınca ne yapılacak? (route)
// • searchController     → TextField controller (HomePage yönetir)
// • onSearchChanged      → TextField yazısı değişince filtrelemeyi tetikler
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../controllers/theme_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// =========================================================================
  /// 🔎 Arama alanı açık/kapalı durumu
  /// =========================================================================
  /// Bu değer HomePage’de tutulur. CustomAppBar sadece “göster/gizle” kararını
  /// bu parametreye göre verir.
  final bool isSearchVisible;

  /// =========================================================================
  /// 🔍 Arama ikonuna basılınca çağrılır
  /// =========================================================================
  /// Burada toggle yapılmaz; HomePage’de setState ile yönetilir.
  final VoidCallback onSearchPressed;

  /// =========================================================================
  /// 📊 İstatistik ikonuna basılınca çağrılır
  /// =========================================================================
  /// Navigasyon burada yapılmaz; HomePage Get.toNamed() vb. ile yönetir.
  final VoidCallback onStatsPressed;

  /// =========================================================================
  /// ⌨️ Arama TextField controller
  /// =========================================================================
  /// TextField içeriğini yönetmek için dışarıdan alınır.
  /// Böylece arama kapandığında temizleme vb. işlemleri HomePage kontrol eder.
  final TextEditingController searchController;

  /// =========================================================================
  /// ✍️ Arama metni değişince çağrılır
  /// =========================================================================
  /// Kullanıcı yazdıkça filtreleme/arama mantığı HomePage’de çalışır.
  final ValueChanged<String> onSearchChanged;

  const CustomAppBar({
    super.key,
    required this.isSearchVisible,
    required this.onSearchPressed,
    required this.onStatsPressed,
    required this.searchController,
    required this.onSearchChanged,
  });

  /// =========================================================================
  /// 🏗 build
  /// =========================================================================
  /// CustomAppBar’ın tüm UI üretimi burada yapılır:
  ///
  /// • Sol: Drawer ikon rengi (iconTheme)
  /// • Title: “Netflix Watchlist”
  /// • Actions:
  ///    1) Search (arama alanını aç/kapat)
  ///    2) Stats (istatistik sayfasına git)
  ///    3) Theme (dark/light değiştir)
  ///
  /// • Bottom (opsiyonel):
  ///    - isSearchVisible == true ise TextField içeren ikinci satır görünür.
  ///    - Bu alan AppBar yüksekliğini artırdığı için preferredSize doğru hesaplanır.
  ///
  /// Tema yönetimi:
  /// • ThemeController GetX ile yönetildiği için burada Get.find() ile controller alınır.
  /// • toggleTheme() çağrısı tüm app ’i ThemeMode bazında günceller.
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return AppBar(
      iconTheme: IconThemeData(color: drawerMenuTitleText.color),
      title: Text("Netflix Watchlist", style: appBarTitleText),
      actions: [
        // 🔍 ARAMA BUTONU
        IconButton(
          icon: Icon(Icons.search, color: drawerMenuTitleText.color),
          tooltip: "Ara",
          onPressed: onSearchPressed,
        ),

        // 📊 İSTATİSTİK SAYFASI
        IconButton(
          icon: Icon(Icons.bar_chart, color: drawerMenuTitleText.color),
          tooltip: "İstatistikler",
          onPressed: onStatsPressed,
        ),

        // 🌙 TEMA BUTONU
        IconButton(
          icon: Icon(Icons.brightness_6, color: drawerMenuTitleText.color),
          tooltip: "Tema Değiştir",
          onPressed: themeController.toggleTheme,
        ),
      ],

      /// =========================================================================
      /// 🔽 bottom (Search TextField)
      /// =========================================================================
      /// Search görünürse AppBar ’ın altında ikinci satır olarak TextField gösterilir.
      ///
      /// Notlar:
      /// • autofocus: true → açılır açılmaz klavye gelir
      /// • fillColor: Colors.white → şu an sabit beyaz
      ///    - Dark modda daha iyi görünüm için bunu tema bazlı yapabiliriz
      ///      (istersen sonra iyileştiririz).
      /// • enabledBorder/focusedBorder: menuColor ile uyumlu çizgi
      bottom: isSearchVisible
          ? PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 10.0,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Ara (Dizi, Film, Bölüm)...",
                    prefixIcon: const Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: menuColor, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: menuColor, width: 2.0),
                    ),
                  ),
                  onChanged: onSearchChanged,
                ),
              ),
            )
          : null,
    );
  }

  /// =========================================================================
  /// 📏 preferredSize
  /// =========================================================================
  /// Scaffold.appBar, AppBar ’ın toplam yüksekliğini bilmek ister.
  ///
  /// Burada:
  /// • normal durumda → kToolbarHeight
  /// • search açıkken  → kToolbarHeight + (extra height)
  ///
  /// Not:
  /// bottom PreferredSize 48 veriyor; burada 56 kullanılmış.
  /// Bu genelde sorun çıkarmaz ama istersen ikisini aynı yapıp tam uyumlu
  /// hale getirebiliriz (48/56 farkını tek değere sabitlemek daha “temiz”).
  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (isSearchVisible ? 56.0 : 0));
}
