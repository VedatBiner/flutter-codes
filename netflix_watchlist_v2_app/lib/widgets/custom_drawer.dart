// 📁 lib/widgets/custom_drawer.dart
//
// 🎬 Netflix Film List App
// Drawer menüsü – görünüm modu, yedekleme, sıfırlama, vb. işlemler.
//

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart'; // ✅ drawerMenuTitleText
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_export_all.dart'; // <-- TEK CSV EXPORTER
import 'drawer_widgets/drawer_info_padding_tile.dart';
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
      backgroundColor: Colors.grey[900],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          /// 📌 Drawer başlığı
          const DrawerTitleWidget(),

          Divider(color: menuColor, thickness: 2),

          // ------------------------------------------------------------------
          // 📤 CSV DIŞA AKTAR (Filmler + Diziler TEK CSV)
          // ------------------------------------------------------------------
          ListTile(
            leading: const Icon(Icons.download, color: Colors.white),

            /// 🔹 BUTON BAŞLIĞI (drawerMenuTitleText)
            title: Text(
              "CSV Dışa Aktar (Film + Dizi)",
              style: drawerMenuTitleText,
            ),

            /// 🔹 ALT AÇIKLAMA (aynı stilin yumuşatılmış hali)
            subtitle: Text(
              "Tüm liste + OMDb verileri",
              style: drawerMenuTitleText.copyWith(
                fontSize: 12,
                color: drawerMenuTitleText.color?.withOpacity(0.7),
              ),
            ),

            onTap: () async {
              // 1️⃣ Drawer ’ı kapat
              Navigator.pop(context);

              // 2️⃣ Biraz bekle (context güvenli hâle gelsin)
              await Future.delayed(const Duration(milliseconds: 120));

              // 3️⃣ Yeni güvenli context al
              final ctx =
                  ScaffoldMessenger.maybeOf(context)?.context ?? context;

              // 4️⃣ Başlangıç bildirimi
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text("📄 CSV hazırlanıyor...")),
              );

              // 5️⃣ CSV üret ve taşı
              final file = await exportAllToCsv(allMovies, allSeries);

              // 6️⃣ Sonuç bildirimi
              if (file != null) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text("✅ CSV oluşturuldu: ${file.path}")),
                );
              } else {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text("❌ CSV dışa aktarılamadı.")),
                );
              }
            },
          ),

          Divider(color: menuColor, thickness: 2),

          /// 📌 Versiyon & bilgi
          InfoPaddingTile(appVersion: appVersion),
        ],
      ),
    );
  }
}
