// 📃 widgets/drawer_backup_tile.dart
// Drawer içindeki "Yedek Oluştur (JSON/CSV/XLSX)" satırını bağımsız
// bir widget ’a taşıdık. Böylece custom_drawer.dart daha okunur oldu.
//

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../../utils/fx_files/backup_notification_helper.dart';
import '../show_notification_handler.dart';

class DrawerBackupTile extends StatelessWidget {
  const DrawerBackupTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'JSON/CSV/XLSX/SQL/ZIP\nyedeği oluştur',
      child: ListTile(
        leading: Icon(Icons.download, color: downLoadButtonColor, size: 32),
        title: const Text('Yedek Oluştur', style: drawerMenuText),
        subtitle: Text(
          "Aşağıdaki formatlarda \nyedek oluşturur: \n(JSON / CSV / XLSX / SQL / ZIP )",
          style: drawerMenuSubtitleText,
        ),
        onTap: () async {
          await backupNotificationHelper(
            context: context,
            onStatusChange: (_) {}, // istersen burada SnackBar/Log yapabilirsin
            onExportingChange:
                (_) {}, // istersen burada loading state bağlarsın
            // ✅ Gerçek callback: ExportResultX → handler bildirimi
            onSuccessNotify: (ctx, res) {
              showBackupNotification(
                ctx,
                res.jsonPath ??
                    '', // Hata düzeltildi: Null ise boş string gönder
                res.csvPath ??
                    '', // Hata düzeltildi: Null ise boş string gönder
                res.xlsxPath ??
                    '', // Hata düzeltildi: Null ise boş string gönder
                res.sqlPath ??
                    '', // Hata düzeltildi: Null ise boş string gönder
                res.zipPath ??
                    '', // Hata düzeltildi: Null ise boş string gönder
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
