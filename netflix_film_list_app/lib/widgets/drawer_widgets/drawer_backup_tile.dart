// 📃 widgets/drawer_backup_tile.dart
// Drawer içindeki "Yedek Oluştur (JSON/CSV/XLSX)" satırını bağımsız
// bir widget ’a taşıdık. Böylece custom_drawer.dart daha okunur oldu.
//

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';

class DrawerBackupTile extends StatelessWidget {
  const DrawerBackupTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'JSON/CSV/XLSX/SQL\nyedeği oluştur',
      child: ListTile(
        leading: Icon(Icons.download, color: downLoadButtonColor, size: 32),
        title: const Text('Yedek Oluştur', style: drawerMenuText),
        subtitle: Text(
          "Aşağıdaki formatlarda yedek oluşturur: \n(JSON / CSV / XLSX /SQL)"
          "\ndosya gönderimi mail ile .zip formatında yapılır.",
          style: drawerMenuSubtitleText,
        ),
        onTap: () async {
          // await backupNotificationHelper(
          //   context: context,
          //   onStatusChange: (_) {}, // istersen burada SnackBar/Log yapabilirsin
          //   onExportingChange:
          //       (_) {}, // istersen burada loading state bağlarsın
          //   // ✅ Gerçek callback: ExportResultX → handler bildirimi
          //   onSuccessNotify: (ctx, res) {
          //     showBackupNotification(
          //       ctx,
          //       res.jsonPath, // jsonPathDownload
          //       res.csvPath, // csvPathDownload
          //       res.xlsxPath, // excelPathDownload
          //       res.sqlPath, // sqlPathDownload
          //     );
          //   },
          // );

          if (!context.mounted) return;
          Navigator.of(context).maybePop();
        },
      ),
    );
  }
}
