// 📃 <----- custom_drawer.dart ----->

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/color_constants.dart';

import '../constants/text_constants.dart';
import '../db/word_database.dart';
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

  /// 📌 Veri tabanı silme kutusu burada açılıyor.
  ///
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

            /// 📌 Görünüm değiştirme seçeneği
            ///
            ListTile(
              leading: Icon(Icons.swap_horiz, color: menuColor),
              title: Text(
                isFihristMode ? 'Klasik Görünüm' : 'Fihristli Görünüm',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                onToggleViewMode();
                Navigator.of(context).maybePop();
              },
            ),

            /// 📌 JSON Export
            ///
            ListTile(
              leading: Icon(Icons.download, color: downLoadButtonColor),
              title: const Text(
                'JSON Yedeği Oluştur',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                final path = await WordDatabase.instance.exportWordsToJson();
                log('📁 JSON dosya konumu: $path', name: 'JSON');
                if (!context.mounted) return;

                /// 📌 Notification göster
                ///
                NotificationService.showCustomNotification(
                  context: context,
                  title: 'JSON Yedeği Oluşturuldu',
                  message: Text(path),
                  icon: Icons.download,
                  iconColor: Colors.blue,
                  progressIndicatorColor: Colors.blue,
                  progressIndicatorBackground: Colors.blue.shade100,
                );

                Navigator.of(context).maybePop();
              },
            ),

            /// 📌 JSON Import
            ///
            ListTile(
              leading: Icon(Icons.upload_file, color: upLoadButtonColor),
              title: const Text(
                'JSON Yedekten Geri Yükle (SQL)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                await WordDatabase.instance.importWordsFromJson(context);
                onDatabaseUpdated();
                if (!context.mounted) return;
                Navigator.of(context).maybePop();
              },
            ),

            /// 📌 CSV Export
            ///
            ListTile(
              leading: Icon(Icons.table_chart, color: downLoadButtonColor),
              title: const Text(
                'CSV Yedeği Oluştur',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                final path = await WordDatabase.instance.exportWordsToCsv();
                log('📁 CSV dosya konumu: $path', name: 'CSV');
                if (!context.mounted) return;

                /// 📌 Notification göster
                ///
                NotificationService.showCustomNotification(
                  context: context,
                  title: 'CSV Yedeği Oluşturuldu',
                  message: Text(path),
                  icon: Icons.file_download,
                  iconColor: Colors.teal,
                  progressIndicatorColor: Colors.teal,
                  progressIndicatorBackground: Colors.teal.shade100,
                );

                Navigator.of(context).maybePop();
              },
            ),

            /// 📌 CSV Import
            ///
            ListTile(
              leading: Icon(Icons.upload_file, color: upLoadButtonColor),
              title: const Text(
                'CSV Yedekten Geri Yükle',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                await WordDatabase.instance.importWordsFromCsv();
                onDatabaseUpdated();
                if (!context.mounted) return;

                /// 📌 Notification göster
                ///
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

            /// 📌 Veritabanını sıfırla
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
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Vedat Biner",
                    style: TextStyle(fontSize: 12, color: menuColor),
                  ),
                  Text(
                    "vbiner@gmail.com",
                    style: TextStyle(fontSize: 12, color: menuColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
