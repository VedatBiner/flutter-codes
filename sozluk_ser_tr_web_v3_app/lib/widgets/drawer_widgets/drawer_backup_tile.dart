// 📃 widgets/drawer_backup_tile.dart
import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/file_info.dart';
import '../../constants/text_constants.dart';
import '../../utils/backup_notification_helper.dart';

class DrawerBackupTile extends StatelessWidget {
  const DrawerBackupTile({super.key});

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
        onTap: () {
          // 1) Drawer 'ı anında kapat (bu çağrı senkron)
          Navigator.pop(context);

          // 2) Hemen ardından export ’u tetikle (async gap YOK)
          triggerBackupExport(
            context: context, // helper içinde messenger 'a çevrilecek
            onStatusChange: (_) {}, // Drawer kapandı; local state yoksa no-op
            onExportingChange: (_) {}, // (isteğe göre yönetebilirsin)
            pageSize: 1000,
            subfolder: appName,
          );
        },
      ),
    );
  }
}
