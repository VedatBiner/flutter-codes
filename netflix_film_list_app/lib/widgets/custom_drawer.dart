// 📁 lib/widgets/custom_drawer.dart
//
// 🎬 Netflix Film List App
// Drawer menüsü – görünüm modu, yedekleme, sıfırlama, vb. işlemler.
//

import 'package:flutter/material.dart';

import '../utils/file_creator.dart';
import 'drawer_widgets/drawer_info_padding_tile.dart';
import 'drawer_widgets/drawer_title.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onDatabaseUpdated;
  final String appVersion;
  final bool isFihristMode;
  final VoidCallback onToggleViewMode;

  /// 🔹 Artık opsiyonel hale getirildi (`?`)
  final Future<void> Function({
    required BuildContext ctx,
    required void Function(
      bool loading,
      double prog,
      String? currentItem,
      Duration elapsed,
    )
    onStatus,
  })?
  onLoadJsonData;

  const CustomDrawer({
    super.key,
    required this.onDatabaseUpdated,
    this.onLoadJsonData, // 👈 artık required değil
    required this.appVersion,
    required this.isFihristMode,
    required this.onToggleViewMode,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          /// 📌 Drawer menü başlığı burada oluşturuluyor
          const DrawerTitleWidget(),

          // DrawerHeader(
          //   decoration: const BoxDecoration(color: Colors.redAccent),
          //   child: Center(
          //     child: Text(
          //       '🎬 Menü',
          //       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          ListTile(
            leading: const Icon(Icons.share, color: Colors.white70),
            title: const Text(
              "Yedekleri Paylaş",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "Download klasöründeki dosyaları paylaş",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            onTap: () async {
              await shareBackupFolder(); // file_creator.dart içinden geliyor
              if (context.mounted) Navigator.pop(context);
            },
          ),

          // 🔄 Görünüm modu değiştir
          // ListTile(
          //   leading: const Icon(Icons.swap_horiz, color: Colors.white),
          //   title: Text(
          //     isFihristMode ? 'Fihrist Modu' : 'Liste Modu',
          //     style: const TextStyle(color: Colors.white),
          //   ),
          //   onTap: () {
          //     onToggleViewMode();
          //     Navigator.pop(context);
          //     log('🌀 Görünüm modu değiştirildi: $isFihristMode',
          //         name: 'Drawer');
          //   },
          // ),

          // 🔁 Veritabanını yenile
          // ListTile(
          //   leading: const Icon(Icons.refresh, color: Colors.white),
          //   title: const Text('Veritabanını Yenile',
          //       style: TextStyle(color: Colors.white)),
          //   onTap: () async {
          //     Navigator.pop(context);
          //     await onDatabaseUpdated();
          //     log('✅ Veritabanı yenilendi', name: 'Drawer');
          //   },
          // ),

          // 📥 JSON/SQL yükleme (opsiyonel)
          // if (onLoadJsonData != null)
          //   ListTile(
          //     leading: const Icon(Icons.cloud_download, color: Colors.white),
          //     title: const Text('JSON Verisi Yükle',
          //         style: TextStyle(color: Colors.white)),
          //     onTap: () async {
          //       Navigator.pop(context);
          //       log('📥 JSON yükleme işlemi başlatıldı', name: 'Drawer');
          //       await onLoadJsonData!(
          //         ctx: context,
          //         onStatus: (bool loading, double prog, String? currentItem,
          //             Duration elapsed) {
          //           log('🔄 Yükleniyor: ${prog.toStringAsFixed(2)}', name: 'Drawer');
          //         },
          //       );
          //     },
          //   ),
          const Divider(color: Colors.white24),

          /// 📌 Versiyon ve yazılım bilgisi
          InfoPaddingTile(appVersion: appVersion),
        ],
      ),
    );
  }
}
