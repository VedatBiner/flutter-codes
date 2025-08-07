// 📃 <----- custom_drawer.dart ----->
// Drawer menüye buradan erişiliyor.

// 📌 Flutter paketleri

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../utils/database_reset_helper.dart';
import 'drawer_widgets/alphabet_expansion_tile.dart';
import 'drawer_widgets/drawer_backup_tile.dart';
import 'drawer_widgets/grammar_expansion_tile.dart';
import 'drawer_widgets/help_pages_tile.dart';

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
            Tooltip(
              message: "Görünüm değiştir",
              child: ListTile(
                leading: Icon(Icons.swap_horiz, color: menuColor, size: 32),
                title: Text(
                  isFihristMode ? 'Klasik Görünüm' : 'Fihristli Görünüm',
                  style: drawerMenuText,
                ),
                onTap: () {
                  onToggleViewMode();
                  Navigator.of(context).maybePop();
                },
              ),
            ),

            /// 📌 Yardımcı Bilgiler - Alt Menülü
            ExpansionTile(
              leading: Icon(
                Icons.info_outline_rounded,
                color: menuColor,
                size: 32,
              ),
              title: const Text('Yardımcı Bilgiler', style: drawerMenuText),
              childrenPadding: const EdgeInsets.only(left: 24),
              collapsedIconColor: menuColor,

              children: [
                /// 📌 Alfabe - İçinde Latin ve Kiril seçenekleri
                const AlphabetExpansionTile(),

                /// 📌 Gramer
                const GrammarExpansionTile(),

                /// 📌 Yardımcı Kavramlar
                const HelpExpansionTile(),
              ],
            ),

            /// 📌 Yedek oluştur (JSON/CSV/XLSX)
            const DrawerBackupTile(),

            /// 📌 Veritabanını Yenile (SQL)
            Tooltip(
              message: "Veritabanını Yenile",
              child: ListTile(
                leading: const Icon(
                  Icons.refresh,
                  color: Colors.amber,
                  size: 32,
                ),
                title: const Text(
                  'Veritabanını Yenile (SQL)',
                  style: drawerMenuText,
                ),
                onTap: () async {
                  // 🔸 Drawer kapanmadan önce KÖK context ’i al
                  final rootCtx =
                      Navigator.of(context, rootNavigator: true).context;

                  // 🔸 Drawer ’ı kapat
                  Navigator.of(context).maybePop();
                  // Küçük gecikme: kapanma animasyonu tamamlansın
                  await Future.delayed(const Duration(milliseconds: 300));

                  // 1️⃣ Yerel tabloyu sil
                  final db = await DbHelper.instance.database;
                  await db.delete('words');

                  // 2️⃣ Yeniden indir / yükle  (kök context ’i kullan!)
                  await onLoadJsonData(
                    ctx: rootCtx,
                    onStatus:
                        (
                          loading,
                          prog,
                          word,
                          elapsed,
                        ) {}, // Drawer ’da ilerleme yok
                  );
                },
              ),
            ),

            /// 📌 Veritabanını Sıfırla
            Tooltip(
              message: "Veritabanını Sıfırla",
              child: ListTile(
                leading: Icon(Icons.delete, color: deleteButtonColor, size: 32),
                title: const Text(
                  'Veritabanını Sıfırla (SQL)',
                  style: drawerMenuText,
                ),
                onTap: () async {
                  await showResetDatabaseDialog(
                    context,
                    onAfterReset: () => onDatabaseUpdated(),
                  );
                },
              ),
            ),

            Divider(color: menuColor, thickness: 2),

            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  Text(
                    appVersion,
                    textAlign: TextAlign.center,
                    style: versionText,
                  ),
                  Text("Vedat Biner", style: nameText),
                  Text("vbiner@gmail.com", style: nameText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
