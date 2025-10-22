// 📃 widgets/drawer_backup_tile.dart
import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/file_info.dart';
import '../../constants/text_constants.dart';
import '../../utils/backup_notification_helper.dart';
import '../show_word_dialog_handler.dart';

class DrawerBackupTile extends StatefulWidget {
  const DrawerBackupTile({super.key});

  @override
  State<DrawerBackupTile> createState() => _DrawerBackupTileState();
}

class _DrawerBackupTileState extends State<DrawerBackupTile> {
  bool isExporting = false;
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
          // 1) Drawer kapanınca da yaşayacak güvenli context 'i al
          final safeCtx =
              Scaffold.maybeOf(context)?.context ??
              Navigator.of(context, rootNavigator: true).context;

          // 2) Önce drawer 'ı kapat
          Navigator.pop(context);

          // 3) Export' u güvenli context ile tetikle
          await triggerBackupExport(
            context: safeCtx, // 🔴 artık tile context 'i değil
            onStatusChange: (s) {
              if (!mounted) return; // 🔐 tile dispose olabilir
              setState(() => status = s);
            },
            onExportingChange: (v) {
              if (!mounted) {
                return; // 🔐 setState() öncesi mounted kontrolü eklendi
              }
              setState(() => isExporting = v);
            },
            // ✅ Bildirimi artık handler gösteriyor:
            onSuccessNotify: showBackupNotification,
            pageSize: 500, // 1000
            subfolder: appName,
          );
        },
      ),
    );
  }
}
