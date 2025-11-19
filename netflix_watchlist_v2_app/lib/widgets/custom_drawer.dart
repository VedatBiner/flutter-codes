// 📁 lib/widgets/custom_drawer.dart
//
// 🎬 Netflix Film List App
// Drawer menüsü – görünüm modu, yedekleme, sıfırlama, vb. işlemler.
//

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_export_all.dart'; // <-- TEK CSV EXPORTER
import 'drawer_widgets/drawer_info_padding_tile.dart';
// import 'drawer_widgets/drawer_share_tile.dart';
import 'drawer_widgets/drawer_title.dart';

class CustomDrawer extends StatelessWidget {
  final String appVersion;

  /// 🔹 HomePage'den geliyor
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
      backgroundColor: Colors.grey[900],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          /// 📌 Drawer menü başlığı burada oluşturuluyor
          const DrawerTitleWidget(),

          Divider(color: menuColor, thickness: 2),

          // ------------------------------------------------------------------
          // 📤 CSV DIŞA AKTAR — (Filmler + Diziler TEK CSV)
          // ------------------------------------------------------------------
          ListTile(
            leading: const Icon(Icons.download, color: Colors.white),
            title: const Text(
              "CSV Dışa Aktar (Film + Dizi)",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "Tüm liste + OMDb verileri",
              style: TextStyle(color: Colors.white70),
            ),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("CSV hazırlanıyor...")),
              );

              // 1️⃣ Filmler + Diziler → Tek CSV oluştur ve Download’a taşı
              final file = await exportAllToCsv(allMovies, allSeries);

              if (file != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ CSV başarıyla dışa aktarıldı!"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("❌ CSV dışa aktarılamadı.")),
                );
              }
            },
          ),

          Divider(color: menuColor, thickness: 2),

          /// 📌 Versiyon ve yazılım bilgisi
          InfoPaddingTile(appVersion: appVersion),
        ],
      ),
    );
  }
}
