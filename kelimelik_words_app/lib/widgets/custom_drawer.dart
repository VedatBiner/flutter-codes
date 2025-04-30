// 📃 <----- custom_drawer.dart ----->
// Drawer menüye buradan erişiliyor.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../db/word_database.dart';
import '../providers/word_count_provider.dart';
import '../utils/backup_notification_helper.dart';
import 'confirmation_dialog.dart';
import 'notification_service.dart';

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

  /// 📌 Veritabanını tamamen silmek için onay kutusu
  void _showResetDatabaseDialog(BuildContext context) async {
    final confirm = await showConfirmationDialog(
      context: context,
      title: 'Veritabanını Sıfırla',
      content: const Text(
        'Tüm kelimeler silinecek. Emin misiniz?',
        style: kelimeText,
      ),
      confirmText: 'Sil',
      cancelText: 'İptal',
      confirmColor: deleteButtonColor,
      cancelColor: cancelButtonColor,
    );

    if (confirm == true) {
      final db = await WordDatabase.instance.database;
      await db.delete('words');

      if (!context.mounted) return;
      Provider.of<WordCountProvider>(context, listen: false).updateCount();
      Navigator.of(context).maybePop();
      onDatabaseUpdated();

      /// 🔑  Kök bağlam (MediaQuery garantili)
      final rootContext = Navigator.of(context, rootNavigator: true).context;

      NotificationService.showCustomNotification(
        context: rootContext,
        title: 'Veritabanı Sıfırlandı',
        message: const Text('Tüm kayıtlar silindi.'),
        icon: Icons.delete_forever,
        iconColor: Colors.red,
        progressIndicatorColor: Colors.red,
        progressIndicatorBackground: Colors.red.shade100,
      );
    }
  }

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
                await onLoadJsonData(
                  ctx: context,
                  onStatus: (_, __, ___, ____) {},
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
              onTap: () => _showResetDatabaseDialog(context),
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
