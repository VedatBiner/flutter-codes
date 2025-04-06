// 📃 <----- custom_drawer.dart ----->

import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/color_constants.dart';

import '../constants/text_constants.dart';
import '../db/word_database.dart';
import '../utils/csv_backup_helper.dart';
import '../utils/json_backup_helper.dart';
import 'confirmation_dialog.dart';
import 'notification_service.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onDatabaseUpdated;
  final String appVersion;
  final bool isFihristMode;
  final VoidCallback onToggleViewMode;

  const CustomDrawer({
    super.key,
    required this.onDatabaseUpdated,
    required this.appVersion,
    required this.isFihristMode,
    required this.onToggleViewMode,
  });

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
      Navigator.of(context).maybePop();

      onDatabaseUpdated();

      NotificationService.showCustomNotification(
        context: context,
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
        alignment: Alignment.centerLeft,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: drawerColor),
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.only(bottom: 0),
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
            ///
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

            /// 📌 Yedekleme (JSON/CSV)
            ///
            ListTile(
              leading: Icon(Icons.download, color: downLoadButtonColor),
              title: const Text(
                'Yedek Oluştur (JSON/CSV)',
                style: drawerMenuText,
              ),
              onTap: () async {
                final jsonPath = await createJsonBackup(context);
                if (!context.mounted) return;
                final csvPath = await createCsvBackup(context);
                if (!context.mounted) return;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  NotificationService.showCustomNotification(
                    context: context,
                    title: 'JSON/CSV Yedeği Oluşturuldu',
                    message: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "JSON yedeği : ",
                            style: kelimeAddText,
                          ),
                          TextSpan(text: ' $jsonPath', style: normalBlackText),
                          const TextSpan(
                            text: "\nCSV yedeği : ",
                            style: kelimeAddText,
                          ),
                          TextSpan(text: ' $csvPath', style: normalBlackText),
                        ],
                      ),
                    ),

                    icon: Icons.download,
                    iconColor: Colors.blue,
                    progressIndicatorColor: Colors.blue,
                    progressIndicatorBackground: Colors.blue.shade100,
                  );
                });

                if (!context.mounted) return;
                Navigator.of(context).maybePop();
              },
            ),

            /// 📌 Yedekten geri yükleme (JSON)
            ///
            ListTile(
              leading: Icon(Icons.upload_file, color: upLoadButtonColor),
              title: const Text(
                'JSON Yedekten Geri Yükle (SQL)',
                style: drawerMenuText,
              ),
              onTap: () async {
                await WordDatabase.instance.importWordsFromJson(context);
                onDatabaseUpdated();
                if (!context.mounted) return;
                Navigator.of(context).maybePop();
              },
            ),

            /// 📌 Yedekten geri yükleme (JSON)
            ///
            ListTile(
              leading: Icon(Icons.upload_file, color: upLoadButtonColor),
              title: const Text(
                'CSV Yedekten Geri Yükle',
                style: drawerMenuText,
              ),
              onTap: () async {
                await WordDatabase.instance.importWordsFromCsv();
                onDatabaseUpdated();
                if (!context.mounted) return;

                NotificationService.showCustomNotification(
                  context: context,
                  title: 'CSV Yedeği Yüklendi',
                  message: const Text('CSV dosyasından veriler yüklendi.'),
                  icon: Icons.upload_file,
                  iconColor: Colors.deepPurple,
                  progressIndicatorColor: Colors.deepPurple,
                  progressIndicatorBackground: Colors.deepPurple.shade100,
                );

                Navigator.of(context).maybePop();
              },
            ),

            /// 📌 Veri tabanını sıfırla
            ///
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
