// 📁 lib/widgets/drawer_widgets/drawer_share_tile.dart
//
// 🎬 Netflix Film List App
// -----------------------------------------------------------
// Bu widget, Drawer menüsünde yer alan “Yedekleri Paylaş” seçeneğini
// tek başına yönetir.
//
// Görevleri:
//  • Download/{appName} klasöründeki CSV, JSON, Excel, SQL dosyalarını paylaşır.
//  • share_helper.dart dosyasındaki shareBackupFolder() metodunu çağırır.
//  • Başarılı veya başarısız durumlarda log üretir.
//
// Kullanım:
//   import 'drawer_widgets/drawer_share_tile.dart';
//   ...
//   const DrawerShareTile();
//
// Gereken dosyalar:
//   - lib/utils/fc_files/share_helper.dart  → shareBackupFolder()
//   - permission_handler / share_plus paketleri
// -----------------------------------------------------------

import 'package:flutter/material.dart';

import '../../utils/fc_files/share_helper.dart'; // paylaşım yardımcı dosyası

class DrawerShareTile extends StatelessWidget {
  const DrawerShareTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.share, color: Colors.white70),
      title: const Text(
        "Yedekleri Paylaş",
        style: TextStyle(color: Colors.white),
      ),
      subtitle: const Text(
        "Dosyaları zip formatında"
        "\nmail ile gönderilir",
        style: TextStyle(color: Colors.white54, fontSize: 12),
      ),
      onTap: () async {
        await shareBackupFolder(); // 📤 paylaşım işlemi başlatılıyor
        if (context.mounted) Navigator.pop(context);
      },
    );
  }
}
