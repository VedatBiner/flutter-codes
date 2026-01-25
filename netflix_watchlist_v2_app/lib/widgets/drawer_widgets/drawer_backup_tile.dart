// 📃 widgets/drawer_backup_tile.dart
// Drawer içindeki "Yedek Oluştur (JSON/CSV/XLSX)" satırını bağımsız
// bir widget ’a taşıdık. Böylece custom_drawer.dart daha okunur oldu.
//

import 'package:flutter/material.dart';

import '../../utils/backup_notification_helper.dart';
import '../show_notification_handler.dart';

class DrawerBackupTile extends StatelessWidget {
  const DrawerBackupTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'JSON/CSV/XLSX\nyedeği oluştur',
      child: ListTile(
        // Sabit renkler ve stiller kaldırıldı.
        // Widget artık renklerini ve stillerini mevcut temadan alacak.
        leading: const Icon(Icons.download, size: 32),
        title: const Text('Yedek Oluştur'),
        subtitle: const Text(
          "Aşağıdaki formatlarda \nyedek oluşturur: \n(JSON / CSV / XLSX)",
        ),
        onTap: () async {
          await backupNotificationHelper(
            context: context,
            onStatusChange: (_) {},
            onExportingChange: (_) {},
            onSuccessNotify: (ctx, res) {
              showBackupNotification(
                ctx,
                res.jsonPath,
                res.csvPath,
                res.excelPath,
              );
            },
          );

          if (!context.mounted) return;
          Navigator.of(context).maybePop();
        },
      ),
    );
  }
}
