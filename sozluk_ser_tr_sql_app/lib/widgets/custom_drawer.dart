// 📃 <----- custom_drawer.dart ----->
// Drawer menüye buradan erişiliyor.

// 📌 Flutter paketleri

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import 'drawer_widgets/drawer_backup_tile.dart';
import 'drawer_widgets/drawer_change_view_tile.dart';
import 'drawer_widgets/drawer_renew_db_tile.dart';
import 'drawer_widgets/drawer_reset_db_tile.dart';
import 'drawer_widgets/info_padding_tile.dart';
import 'drawer_widgets/main_expansion_tile.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onDatabaseUpdated;
  final String appVersion;
  final bool isFihristMode;
  final VoidCallback onToggleViewMode;

  /// 📌 JSON ’dan veri yüklemek için üst bileşenden gelen fonksiyon
  ///    İmza → ({ctx, onStatus})
  final Future<void> Function({
    required BuildContext ctx,
    required void Function(bool, double, String?, Duration) onStatus,
  })
  onLoadJsonData;

  const CustomDrawer({
    super.key,
    required this.onDatabaseUpdated,
    required this.appVersion,
    required this.isFihristMode,
    required this.onToggleViewMode,
    required this.onLoadJsonData,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: drawerColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.centerLeft,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: drawerColor,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(
                'Menü',
                style: TextStyle(
                  color: menuColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(thickness: 2, color: menuColor, height: 0),

            /// 📌 Görünüm değiştirme
            DrawerChangeViewTile(
              isFihristMode: isFihristMode,
              onToggleViewMode: onToggleViewMode,
            ),

            /// 📌 Yardımcı Bilgiler - Alt Menülü
            const MainExpansionTile(),

            /// 📌 Yedek oluştur (JSON/CSV/XLSX)
            const DrawerBackupTile(),

            /// 📌 Veritabanını Yenile (SQL)
            DrawerRenewDbTile(onLoadJsonData: onLoadJsonData),

            /// 📌 Veritabanını Sıfırla
            DrawerResetDbTile(onAfterReset: onDatabaseUpdated),

            Divider(color: menuColor, thickness: 2),

            /// 📌 Versiyon ve yazılım bilgisi
            InfoPaddingTile(appVersion: appVersion),
          ],
        ),
      ),
    );
  }
}
