// 📃 widgets/drawer_backup_tile.dart
// Drawer içindeki "Yedek Oluştur (JSON/CSV/XLSX)" satırını bağımsız
// bir widget ’a taşıdık. Böylece custom_drawer.dart daha okunur oldu.
//

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/color_constants.dart';
import '../../constants/file_info.dart';
import '../../constants/text_constants.dart';
import '../../utils/backup_notification_helper.dart';

class DrawerBackupTile extends StatefulWidget {
  const DrawerBackupTile({super.key});

  @override
  State<DrawerBackupTile> createState() => _DrawerBackupTileState();
}

class _DrawerBackupTileState extends State<DrawerBackupTile> {
  bool exporting = false;
  String status = 'Hazır. Konsolu kontrol edin.';
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'JSON/CSV/XLSX yedeği oluştur',
      child: ListTile(
        leading: Icon(Icons.download, color: downLoadButtonColor, size: 32),
        title: const Text(
          'Yedek Oluştur \n(JSON/CSV/XLSX)',
          style: drawerMenuText,
        ),
        onTap: () async {
          triggerBackupExport(
            context: context,
            onStatusChange: (s) => setState(() => status = s),
            onExportingChange: (v) => setState(() => exporting = v),
            pageSize: 1000,
            subfolder: appName,
          );
        },
      ),
    );
  }
}
