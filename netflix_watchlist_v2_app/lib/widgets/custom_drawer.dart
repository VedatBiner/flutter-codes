// 📁 lib/widgets/custom_drawer.dart
//
// 🎬 Netflix Film List App
// Drawer menüsü – görünüm modu, yedekleme, sıfırlama, vb. işlemler.
//

import 'package:flutter/material.dart';

import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_export_all.dart';
import '../utils/share_helper.dart';
import 'drawer_widgets/drawer_backup_tile.dart';
import 'drawer_widgets/drawer_info_padding_tile.dart';
import 'drawer_widgets/drawer_share_tile.dart';
import 'drawer_widgets/drawer_title.dart';

class CustomDrawer extends StatelessWidget {
  final String appVersion;

  /// 🔹 HomePage’den geliyor
  final List<NetflixItem> allMovies;
  final List<SeriesGroup> allSeries;

  const CustomDrawer({
    super.key,
    required this.appVersion,
    required this.allMovies,
    required this.allSeries,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          DrawerShareTile(
            // onShareCsv: () async {
            //   // Drawer'ı kapat
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
