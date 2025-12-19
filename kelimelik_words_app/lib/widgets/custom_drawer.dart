// 📃 <----- custom_drawer.dart ----->
// Drawer menüye buradan erişiliyor.

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import 'drawer_widgets/drawer_backup_tile.dart';
import 'drawer_widgets/drawer_info_padding.dart';
import 'drawer_widgets/drawer_share_tile.dart';
import 'drawer_widgets/drawer_stat_tile.dart';
import 'drawer_widgets/drawer_title.dart';

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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            /// 📌 Drawer menü başlığı burada oluşturuluyor
            const DrawerTitleWidget(),

            Divider(thickness: 2, color: menuColor, height: 0),

            /// 📌 Görünüm değiştirme
            /// Bir süre iptal
            // DrawerChangeViewTile(
            //   isFihristMode: isFihristMode,
            //   onToggleViewMode: onToggleViewMode,
            // ),

            /// 📌 İstatistikler
            const DrawerStatTile(),

            /// 📌 Yedek oluştur (JSON/CSV/XLSX/SQL/ZIP)
            const DrawerBackupTile(),

            /// 📌 Yedekleri paylaşma butonu
            const DrawerShareTile(),

            /// 📌 Veritabanını Yenile (SQL)
            /// DrawerRenewDbTile(onLoadJsonData: onLoadJsonData),
            /// Geçici iptal

            /// 📌 Veritabanını Sıfırla
            /// DrawerResetDbTile(onAfterReset: onDatabaseUpdated),
            /// Geçici iptal
            Divider(color: menuColor, thickness: 2),

            /// 📌 Versiyon ve yazılım bilgisi
            InfoPaddingTile(appVersion: appVersion),
          ],
        ),
      ),
    );
  }
}
