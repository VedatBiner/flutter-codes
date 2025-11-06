// 📁 lib/widgets/custom_drawer.dart
//
// 🎬 Netflix Film List App
// Drawer menüsü – görünüm modu, yedekleme, sıfırlama, vb. işlemler.
//

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import 'drawer_widgets/drawer_info_padding_tile.dart';
import 'drawer_widgets/drawer_share_tile.dart';
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

          /// 📌 Yedek oluştur (JSON/CSV/XLSX/SQL)
          // const DrawerBackupTile(),

          /// 📤 Yedekleri paylaşma butonu
          const DrawerShareTile(),

          Divider(color: menuColor, thickness: 2),

          /// 📌 Versiyon ve yazılım bilgisi
          InfoPaddingTile(appVersion: appVersion),
        ],
      ),
    );
  }
}
