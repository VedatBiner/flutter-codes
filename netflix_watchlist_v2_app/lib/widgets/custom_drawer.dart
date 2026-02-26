// 📁 lib/widgets/custom_drawer.dart
//
// ============================================================================
// 🧭 CustomDrawer – Uygulama Drawer Menüsü (Yedekleme + Paylaşım + Bilgi)
// ============================================================================
//
// Bu dosya, HomePage içindeki Scaffold.drawer alanına verilen Drawer menüsünü üretir.
// Drawer; kullanıcıya uygulama içinde “yardımcı aksiyonları” (yedek oluşturma, paylaşma,
// versiyon bilgisi gösterme vb.) sunmak için kullanılır.
//
// ---------------------------------------------------------------------------
// 🔹 Neden CustomDrawer ayrı bir dosya?
// ---------------------------------------------------------------------------
// • HomePage (ana ekran) kodunu sade tutar.
// • Drawer büyüdükçe menüyü ayrı yönetmek kolaylaşır.
// • Drawer satırlarını modüler widget ’lara ayırarak (DrawerBackupTile,
//   DrawerShareTile, DrawerTitleWidget, InfoPaddingTile) okunabilirliği artırır.
//
// ---------------------------------------------------------------------------
// 🔹 Bu Drawer hangi widget ’lardan oluşur?
// ---------------------------------------------------------------------------
// 1) DrawerTitleWidget
//    - Drawer ’ın üst başlık alanını gösterir (logo/başlık gibi).
// 2) DrawerBackupTile
//    - JSON/CSV/XLSX yedeği üretme aksiyonunu yönetir.
// 3) DrawerShareTile
//    - Download/{appName} altındaki yedek dosyalarını paylaşma aksiyonunu yönetir.
// 4) InfoPaddingTile
//    - En altta uygulama versiyon bilgisini ve sabit bilgilendirme alanını gösterir.
//
// ---------------------------------------------------------------------------
// 🔹 Tema davranışı (Light/Dark)
// ---------------------------------------------------------------------------
// • Light Mode: drawerColor (mavi) arka plan
// • Dark Mode : scaffoldBackgroundColor (koyu temaya uyumlu arka plan)
//
// Not:
// Drawer satırlarının kendi iç renkleri (ikon, yazı stili vs.) ilgili widget ’ların
// dosyalarında yönetilir.
//
// ============================================================================

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import 'drawer_widgets/drawer_backup_tile.dart';
import 'drawer_widgets/drawer_info_padding_tile.dart';
import 'drawer_widgets/drawer_share_tile.dart';
import 'drawer_widgets/drawer_title.dart';

class CustomDrawer extends StatelessWidget {
  /// Uygulama versiyon bilgisini Drawer ’ın alt kısmında göstermek için kullanılır.
  /// HomePage içinde PackageInfo ile üretilip buraya gönderilir.
  final String appVersion;

  /// HomePage’den gelen tüm film listesi.
  ///
  /// Şu an Drawer içinde doğrudan kullanılmıyor; fakat ileride:
  /// • “Sadece filmleri dışa aktar”
  /// • “Filmleri filtreleyerek paylaş”
  /// gibi özellikler eklenirse hazır olsun diye parametre olarak taşınıyor.
  final List<NetflixItem> allMovies;

  /// HomePage’den gelen tüm dizi listesi.
  ///
  /// Şu an Drawer içinde doğrudan kullanılmıyor; fakat ileride:
  /// • “Sadece dizileri dışa aktar”
  /// • “Dizi istatistikleri”
  /// gibi özellikler eklenirse hazır olsun diye parametre olarak taşınıyor.
  final List<SeriesGroup> allSeries;

  const CustomDrawer({
    super.key,
    required this.appVersion,
    required this.allMovies,
    required this.allSeries,
  });

  /// =========================================================================
  /// 🧱 build()
  /// =========================================================================
  /// Drawer UI ’ını üretir.
  ///
  /// 1) Önce tema modunu (dark/light) tespit eder.
  /// 2) Drawer arka plan rengini temaya göre ayarlar:
  ///    - Light: drawerColor (mavi)
  ///    - Dark : scaffoldBackgroundColor (koyu temaya uyum)
  /// 3) Drawer içeriğini ListView ile alt alta dizer:
  ///    - Başlık
  ///    - Yedek oluştur
  ///    - Yedekleri paylaş
  ///    - Versiyon bilgisi
  ///
  /// Not:
  /// Drawer içindeki satırların davranışları ilgili widget ’larda yönetilir.
  /// (Örn: backupNotificationHelper, shareBackupFolder vb. tetiklemeler)
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      // ✅ Light temada mavi; dark temada uygulamanın scaffold arka planı
      backgroundColor: isDarkMode
          ? Theme.of(context).scaffoldBackgroundColor
          : drawerColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          /// 📌 Drawer başlığı
          const DrawerTitleWidget(),

          const Divider(thickness: 2),

          /// 📌 Yedek oluştur (JSON/CSV/XLSX)
          const DrawerBackupTile(),
          const SizedBox(height: 8),

          /// 📌 Yedekleri paylaşma butonu
          /// (Download/{appName} içindeki dosyaları paylaşır)
          DrawerShareTile(
            // onShareCsv: () async {
            //   // Drawer 'ı kapat
            //   Navigator.of(context).pop();
            //
            //   // CSV dosyasını oluştur
            //   final file = await exportAllToCsv(allMovies, allSeries);
            //   if (file == null) return;
            //
            //   // Paylaşım menüsünü aç
            //   await ShareHelper.shareCsv(file);
            // },
          ),
          const SizedBox(height: 8),

          const Divider(thickness: 2),

          /// 📌 Versiyon & bilgi
          InfoPaddingTile(appVersion: appVersion),
        ],
      ),
    );
  }
}














