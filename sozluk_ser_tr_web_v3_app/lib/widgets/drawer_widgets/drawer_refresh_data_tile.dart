// 📃 <----- drawer_refresh_data_tile.dart ----->
//
// Drawer içinde “Verileri tekrar oku” eylemini temsil eden tekil ListTile.
// HomePage’den verilen `onReload` callback ’ini çağırır ve Drawer ’ı kapatır.

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/text_constants.dart';

class DrawerRefreshDataTile extends StatelessWidget {
  final Future<void> Function() onReload;

  const DrawerRefreshDataTile({super.key, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Verileri tekrar oku',
      child: ListTile(
        leading: const Icon(Icons.refresh, color: Colors.white),
        title: const Text('Verileri tekrar oku', style: drawerMenuText),
        onTap: () async {
          Navigator.pop(context); // Drawer ’ı kapat
          await onReload(); // Dışarıdan gelen callback ’i çalıştır
        },
      ),
    );
  }
}
