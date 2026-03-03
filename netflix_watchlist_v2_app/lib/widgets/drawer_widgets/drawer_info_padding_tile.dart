// 📃 <----- lib/widgets/drawer_widgets/info_padding_tile.dart ----->
//
// ============================================================================
// ℹ️ InfoPaddingTile – Drawer Alt Bilgi Alanı
// ============================================================================
//
// Bu widget, Drawer menüsünün en alt kısmında sabit şekilde görünen
// “uygulama bilgisi” alanını oluşturur.
//
// ---------------------------------------------------------------------------
// 🔹 Neden ayrı bir widget?
// ---------------------------------------------------------------------------
// Drawer içinde tekrar eden “version + developer bilgisi” gibi statik metinleri
// CustomDrawer’dan ayırarak:
//
// ✅ custom_drawer.dart dosyasını sade tutar
// ✅ UI bileşenlerini modüler hale getirir
// ✅ ileride bilgi metinleri değişince tek dosyadan yönetmeyi sağlar
//
// ---------------------------------------------------------------------------
// 🔹 Gösterilen Bilgiler
// ---------------------------------------------------------------------------
// • appVersion  → HomePage’de PackageInfo ile okunup buraya gönderilir
// • Telif / isim → sabit metin
// • İletişim     → sabit metin
//
// ---------------------------------------------------------------------------
// UI Davranışı
// ---------------------------------------------------------------------------
// • Alt kısımda biraz boşluk bırakmak için Padding kullanılır (bottom: 16)
// • Text stilleri text_constants.dart içinden gelir
//
// ============================================================================

import 'package:flutter/material.dart';

import '../../constants/text_constants.dart';

/// =========================================================================
/// ℹ️ InfoPaddingTile
/// =========================================================================
/// Drawer alt kısmında uygulama sürümü ve geliştirici bilgilerini gösterir.
///
/// Parametre:
/// • [appVersion] → örnek: "Versiyon: 1.0.3"
///
/// Not:
/// Bu widget sadece görüntüleme yapar; kullanıcı etkileşimi yoktur.
/// =========================================================================
class InfoPaddingTile extends StatelessWidget {
  /// Uygulama versiyonu metni (HomePage/CustomDrawer’dan gelir)
  final String appVersion;

  const InfoPaddingTile({
    super.key,
    required this.appVersion,
  });

  /// =========================================================================
  /// 🏗 build
  /// =========================================================================
  /// Bu widget ’ın UI ağacını üretir.
  ///
  /// Ne yapar?
  /// 1) Drawer ’ın altına yakın bir yerde görünmesi için alt padding uygular.
  /// 2) Versiyon metnini ortalı ve belirlenen stile göre yazar.
  /// 3) Telif/isim ve e-posta bilgisini alt alta gösterir.
  ///
  /// Neden Column?
  /// • Basit ve okunur bir şekilde 3 satır metin göstermek için.
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          // ✅ Uygulama versiyonu: dinamik gelir
          Text(
            appVersion,
            textAlign: TextAlign.center,
            style: versionText,
          ),

          // ✅ Telif / isim: sabit metin
          Text(
            '© 2025,2026 Vedat Biner',
            style: nameText,
          ),

          // ✅ İletişim: sabit metin
          Text(
            'vbiner@gmail.com',
            style: nameText,
          ),
        ],
      ),
    );
  }
}
