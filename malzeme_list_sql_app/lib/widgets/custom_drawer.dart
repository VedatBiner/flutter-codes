// 📃 <----- custom_drawer.dart ----->
// Drawer menüye buradan erişiliyor.

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../utils/backup_notification_helper.dart';
import '../utils/database_reset_helper.dart';
import '../widgets/sql_loading_overlay.dart'; // 👈 SQL yükleme kartı eklendi

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
            // 📌 Başlık
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

            /// 📌 Görünüm değiştir
            ListTile(
              leading: Icon(Icons.swap_horiz, color: menuColor),
              title: Text(
                isFihristMode ? 'Klasik Görünüm' : 'Fihristli Görünüm',
                style: drawerMenuText,
              ),
              onTap: () {
                onToggleViewMode();
                Navigator.of(context).maybePop();
              },
            ),

            /// 📌 Yedek oluştur (JSON/CSV)
            ListTile(
              leading: Icon(Icons.download, color: downLoadButtonColor),
              title: const Text(
                'Yedek Oluştur (JSON/CSV)',
                style: drawerMenuText,
              ),
              onTap: () async {
                await createAndNotifyBackup(context);
                if (!context.mounted) return;
                Navigator.of(context).maybePop();
              },
            ),

            /// 📌 Veritabanını Yenile
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.amber),
              title: const Text(
                'Veritabanını Yenile (SQL)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                Navigator.of(context).maybePop();
                await Future.delayed(const Duration(milliseconds: 300));
                if (!context.mounted) return;

                /// ✅ Overlay erişimi düzeltildi
                final overlay = Navigator.of(context).overlay;
                final overlayEntry = OverlayEntry(
                  builder: (context) => const SQLLoadingCardOverlay(),
                );
                overlay?.insert(overlayEntry);

                /// 🔄 Veritabanını JSON 'dan yeniden yükle ve kartı güncelle
                await onLoadJsonData(
                  ctx: context,
                  onStatus: (loading, progress, currentWord, elapsed) {
                    SQLLoadingCardOverlay.update(
                      progress: progress,
                      loadingWord: currentWord,
                      elapsedTime: elapsed,
                      show: loading,
                    );

                    if (!loading) {
                      overlayEntry.remove(); // işlem bitince kartı kaldır
                    }
                  },
                );
              },
            ),

            /// 📌 Veritabanını Sıfırla
            ListTile(
              leading: Icon(Icons.delete, color: deleteButtonColor),
              title: const Text(
                'Veritabanını Sıfırla (SQL)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                await showResetDatabaseDialog(
                  context,
                  onAfterReset: () {
                    onDatabaseUpdated(); // listeyi yenile
                  },
                );
              },
            ),

            Divider(color: menuColor, thickness: 2),

            /// 📌 Versiyon / yazar
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  Text(
                    appVersion,
                    style: versionText,
                    textAlign: TextAlign.center,
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
