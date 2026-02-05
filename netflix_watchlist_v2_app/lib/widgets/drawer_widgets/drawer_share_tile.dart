// 📁 lib/widgets/drawer_widgets/drawer_share_tile.dart

import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../../utils/share_helper.dart';
import '../show_notification_handler.dart';

class DrawerShareTile extends StatelessWidget {
  const DrawerShareTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.share, color: downLoadButtonColor, size: 32),
      title: const Text("Yedekleri Paylaş", style: drawerMenuText),
      subtitle: Text(
        "Download klasöründeki\ndosyaları paylaş",
        style: drawerMenuSubtitleText,
      ),
      onTap: () async {
        // Drawer context’i kapanacağı için rootCtx’yi yakala
        final rootCtx = context;

        // Drawer’ı önce kapat (UX daha iyi)
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        await shareBackupFolder();

        if (!rootCtx.mounted) return;
        showShareFilesNotification(rootCtx);
      },
    );
  }
}
