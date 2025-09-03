// 📃 widgets/drawer_backup_tile.dart
// Drawer içindeki "Yedek Oluştur (JSON/CSV/XLSX)" satırını bağımsız
// bir widget ’a taşıdık. Böylece custom_drawer.dart daha okunur oldu.
//

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../../utils/backup_notification_helper.dart';
import '../show_word_dialog_handler.dart';

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

        // 📃 widgets/drawer_widgets/drawer_backup_tile.dart
        onTap: () async {
          await triggerBackupExport(
            context: context,
            onStatusChange: (_) {}, // istersen burada SnackBar/Log yapabilirsin
            onExportingChange:
                (_) {}, // istersen burada loading state bağlarsın
            // ✅ Gerçek callback: ExportResultX → handler bildirimi
            onSuccessNotify: (ctx, res) {
              showBackupNotification(
                ctx,
                // // "in-app" placeholders (Downloads ile aynı veriliyor)
                // res.jsonPath, // jsonPathInApp
                // res.csvPath, // csvPathInApp
                // res.xlsxPath, // excelPathInApp
                // Downloads
                res.jsonPath, // jsonPathDownload
                res.csvPath, // csvPathDownload
                res.xlsxPath, // excelPathDownload
                res.sqlPath, // sqlPathDownload
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
