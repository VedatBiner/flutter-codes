import 'dart:developer';

import 'package:flutter/material.dart';

import '../db/word_database.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onDatabaseUpdated;
  final String appVersion;

  const CustomDrawer({
    super.key,
    required this.onDatabaseUpdated,
    required this.appVersion,
  });

  /// 🗑️ Veritabanını Sıfırla dialog
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veritabanı sıfırlandı')),
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

          /// 📜JSON Export
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('JSON Yedeği Oluştur'),
            onTap: () async {
              final path = await WordDatabase.instance.exportWordsToJson();
              log('📁 JSON dosya konumu: $path', name: 'JSON');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('JSON yedeği oluşturuldu:\n$path')),
              );
              Navigator.of(context).maybePop();
            },
          ),

          /// 📜JSON Import
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('JSON Yedekten Geri Yükle'),
            onTap: () async {
              await WordDatabase.instance.importWordsFromJson();
              onDatabaseUpdated();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('JSON yedek geri yüklendi')),
              );
              Navigator.of(context).maybePop();
            },
          ),

          /// 📜CSV Export
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('CSV Yedeği Oluştur'),
            onTap: () async {
              final path = await WordDatabase.instance.exportWordsToCsv();
              log('📁 CSV dosya konumu: $path', name: 'CSV');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('CSV yedeği oluşturuldu:\n$path')),
              );
              Navigator.of(context).maybePop();
            },
          ),

          /// 📜CSV Import
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('CSV Yedekten Geri Yükle'),
            onTap: () async {
              await WordDatabase.instance.importWordsFromCsv();
              onDatabaseUpdated();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('CSV yedek geri yüklendi')),
              );
              Navigator.of(context).maybePop();
            },
          ),

          /// 🗑️ Veritabanını Sıfırla
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Veritabanını Sıfırla'),
            onTap: () => _showResetDatabaseDialog(context),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              appVersion,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
