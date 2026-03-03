// 📃 <----- lib/widgets/drawer_widgets/drawer_title.dart ----->
//
// ============================================================================
// 🧭 DrawerTitleWidget – Drawer Başlık Bileşeni
// ============================================================================
//
// Bu widget, Drawer menüsünün en üst kısmında görünen başlık alanını üretir.
// Drawer içindeki başlık UI ’ını ayrı bir bileşen olarak tanımlamak,
// CustomDrawer dosyasını sade ve okunur tutmayı sağlar.
//
// ---------------------------------------------------------------------------
// 🎯 Sorumlulukları
// ---------------------------------------------------------------------------
// • Drawer ’ın üst başlık metnini göstermek
// • Padding ve hizalamayı kontrol etmek
// • Metin stilini merkezi olarak yönetilen text_constants.dart üzerinden almak
//
// ---------------------------------------------------------------------------
// 🔎 Mimari Not
// ---------------------------------------------------------------------------
// Bu widget arka plan rengi tanımlamaz.
// Neden?
// → Drawer ’ın arka planı CustomDrawer içinde belirlenir.
// → Böylece tema (light/dark) değişiminde başlık otomatik uyum sağlar.
// → Bu widget yalnızca içerik ve iç boşluk (padding) ile ilgilenir.
//
// DrawerHeader yerine Container kullanılmasının sebebi:
// • DrawerHeader varsayılan olarak fazla yükseklik bırakır.
// • Daha kompakt ve kontrollü bir başlık alanı istendiği için
//   sade Container + Padding tercih edilmiştir.
//
// ============================================================================

import 'package:flutter/material.dart';
import '../../constants/text_constants.dart';

/// =========================================================================
/// 🧭 DrawerTitleWidget
/// =========================================================================
/// Drawer ’ın en üstünde yer alan başlık bileşenidir.
///
/// Stateless yapıda tasarlanmıştır çünkü:
/// • İç state tutmaz.
/// • Dinamik veri almaz.
/// • Sadece UI üretir.
/// • Tema değişimi otomatik olarak üst widget ’tan gelir.
///
/// Bu yaklaşım Single Responsibility Principle (SRP) ile uyumludur:
/// Başlık üretme sorumluluğu sadece bu sınıfa aittir.
/// =========================================================================
class DrawerTitleWidget extends StatelessWidget {
  const DrawerTitleWidget({super.key});

  /// =========================================================================
  /// 🏗 build
  /// =========================================================================
  /// Bu metod, Drawer başlık alanının görsel yapısını üretir.
  ///
  /// UI Yapısı:
  /// ------------------------------------------------------------
  /// Container
  ///   └── Text("🎬 Menü (Netflix)")
  ///
  /// Container:
  /// • Yalnızca iç boşluk (padding) sağlar.
  /// • Arka plan rengi burada belirlenmez.
  ///
  /// Text:
  /// • drawerMenuTitleText stilini kullanır.
  /// • Stil merkezi olarak text_constants.dart içinde yönetilir.
  ///
  /// Böylece:
  /// • Renk değişikliği tek yerden yapılabilir.
  /// • Tema uyumu korunur.
  /// • Kod tekrarından kaçınılır.
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: Text(
        '🎬 Menü (Netflix)',
        style: drawerMenuTitleText,
      ),
    );
  }
}