// 📃 widgets/drawer_widgets/drawer_reset_db_tile.dart
// Drawer 'daki "Veritabanını Sıfırla (SQL)" satırını bağımsız bir
// widget olarak taşıdık. Böylece CustomDrawer daha temiz.
//

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../../utils/database_reset_helper.dart';

class DrawerResetDbTile extends StatelessWidget {
  final VoidCallback onAfterReset;

  const DrawerResetDbTile({super.key, required this.onAfterReset});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Veritabanını Sıfırla',
      child: ListTile(
        leading: Icon(Icons.delete, color: deleteButtonColor, size: 32),
        title: const Text('Veritabanını Sıfırla (SQL)', style: drawerMenuText),
        onTap: () async {
          await showResetDatabaseDialog(context, onAfterReset: onAfterReset);
        },
      ),
    );
  }
}
