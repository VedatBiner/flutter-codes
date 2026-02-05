// 📃 widgets/drawer_backup_tile.dart
// Drawer içindeki "Yedek Oluştur (JSON/CSV/XLSX)" satırını bağımsız
// bir widget ’a taşıdık. Böylece custom_drawer.dart daha okunur oldu.
//

import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../../utils/backup_notification_helper.dart';
import '../show_notification_handler.dart';

class DrawerBackupTile extends StatelessWidget {
  const DrawerBackupTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'JSON/CSV/XLSX\nyedeği oluştur',
      child: ListTile(
        leading: Icon(Icons.download, color: downLoadButtonColor, size: 32),
        title: Text('Yedek Oluştur', style: drawerMenuText),
        subtitle: Text(
          "Aşağıdaki formatlarda \nyedek oluşturur: \n(JSON / CSV / XLSX)",
          style: drawerMenuSubtitleText,
        ),
        onTap: () async {
          await backupNotificationHelper(
            context: context,
            onStatusChange: (_) {},
            onExportingChange: (_) {},
            onSuccessNotify: (ctx, res) {
              showBackupNotification(
                ctx,
                res.csvPath,
                res.jsonPath,
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
