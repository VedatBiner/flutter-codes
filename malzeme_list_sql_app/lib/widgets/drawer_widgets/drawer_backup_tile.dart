// 📃 widgets/drawer_backup_tile.dart

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../../utils/backup_notification_helper.dart';
import '../show_malzeme_dialog_handler.dart';

class DrawerBackupTile extends StatelessWidget {
  const DrawerBackupTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'JSON/CSV/XLSX/SQL yedeği oluştur',
      child: ListTile(
        leading: Icon(Icons.download, color: downLoadButtonColor, size: 32),
        title: const Text(
          'Yedek Oluştur \n(JSON/CSV/XLSX/SQL)',
          style: drawerMenuText,
        ),
        onTap: () async {
          await backupNotificationHelper(
            context: context,
            onStatusChange: (_) {},
            onExportingChange: (_) {},

            // ✅ BAŞARILI SONUÇTA BİLDİRİM
            onSuccessNotify: (ctx, res) {
              // res içinden alanları kullan
              showBackupNotification(
                rootCtx: ctx,
                jsonPathInApp: '-',
                csvPathInApp: '-',
                excelPathInApp: '-',
                jsonPathDownload: res.jsonPath,
                csvPathDownload: res.csvPath,
                excelPathDownload: res.xlsxPath,
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
