// 📃 <----- custom_drawer.dart ----->

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import 'drawer_widgets/drawer_backup_tile.dart';
import 'drawer_widgets/drawer_info_padding.dart';
import 'drawer_widgets/drawer_refresh_data_tile.dart';
import 'drawer_widgets/drawer_share_tile.dart';
import 'drawer_widgets/drawer_title.dart';
import 'drawer_widgets/gr_main_expansion_tile.dart';

class CustomDrawer extends StatelessWidget {
  final String appVersion;

  // 👇 YENİ: verileri yeniden okuma callback ’i
  final Future<void> Function() onReload;

  const CustomDrawer({
    super.key,
    required this.appVersion,
    required this.onReload, // 👈 zorunlu yapıyoruz
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: drawerColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerTitleWidget(),
            Divider(thickness: 2, color: menuColor, height: 0),

            /// 👇 Yardım menüleri
            const MainExpansionTile(),

            /// 👇 Yedek oluştur
            const DrawerBackupTile(),

            /// 📌 Yedekleri paylaşma butonu
            const DrawerShareTile(),

            /// 👇 YENİ: Verileri tekrar oku
            DrawerRefreshDataTile(onReload: onReload),

            Divider(color: menuColor, thickness: 2),

            // Versiyon
            InfoPaddingTile(appVersion: appVersion),
          ],
        ),
      ),
    );
  }
}
