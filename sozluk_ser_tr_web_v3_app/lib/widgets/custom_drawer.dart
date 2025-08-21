// 📃 <----- custom_drawer.dart ----->

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import 'drawer_widgets/drawer_backup_tile.dart';
import 'drawer_widgets/drawer_info_padding.dart';
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

            const MainExpansionTile(),

            // Yedek oluştur
            const DrawerBackupTile(),

            // 👇 YENİ: Verileri tekrar oku
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.white),
              title: const Text('Verileri tekrar oku', style: drawerMenuText),
              onTap: () async {
                Navigator.pop(context); // drawer’ı kapat
                await onReload(); // callback’i çalıştır
              },
            ),

            Divider(color: menuColor, thickness: 2),

            // Versiyon
            InfoPaddingTile(appVersion: appVersion),
          ],
        ),
      ),
    );
  }
}
