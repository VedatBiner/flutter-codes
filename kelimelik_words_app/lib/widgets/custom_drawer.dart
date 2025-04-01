// 📃 <----- custom_drawer.dart ----->

import 'dart:developer';

import 'package:flutter/material.dart';

import '../db/word_database.dart';
import 'notification_service.dart'; // 🆕 Eklenmeli

class CustomDrawer extends StatelessWidget {
  final VoidCallback onDatabaseUpdated;
  final String appVersion;

  const CustomDrawer({
    super.key,
    required this.onDatabaseUpdated,
    required this.appVersion,
  });

  void _showResetDatabaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Veritabanını Sıfırla'),
            content: const Text('Tüm kelimeler silinecek. Emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).maybePop();
                },
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final db = await WordDatabase.instance.database;
                  await db.delete('words');
                  Navigator.of(context).pop();
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
                },
                child: const Text('Sil'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Text(
              'Menü',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          // JSON Export
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('JSON Yedeği Oluştur'),
            onTap: () async {
              final path = await WordDatabase.instance.exportWordsToJson();
              log('📁 JSON dosya konumu: $path', name: 'JSON');

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

          // JSON Import
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('JSON Yedekten Geri Yükle'),
            onTap: () async {
              await WordDatabase.instance.importWordsFromJson();
              onDatabaseUpdated();

              NotificationService.showCustomNotification(
                context: context,
                title: 'JSON Yedeği Yüklendi',
                message: const Text('Yedek başarıyla geri yüklendi.'),
                icon: Icons.upload,
                iconColor: Colors.green,
                progressIndicatorColor: Colors.green,
                progressIndicatorBackground: Colors.green.shade100,
              );

              Navigator.of(context).maybePop();
            },
          ),

          // CSV Export
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('CSV Yedeği Oluştur'),
            onTap: () async {
              final path = await WordDatabase.instance.exportWordsToCsv();
              log('📁 CSV dosya konumu: $path', name: 'CSV');

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

          // CSV Import
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('CSV Yedekten Geri Yükle'),
            onTap: () async {
              await WordDatabase.instance.importWordsFromCsv();
              onDatabaseUpdated();

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

          // Veritabanını sıfırla
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Veritabanını Sıfırla'),
            onTap: () => _showResetDatabaseDialog(context),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                Text(
                  appVersion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Vedat Biner",
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
                const Text(
                  "vbiner@gmail.com",
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
