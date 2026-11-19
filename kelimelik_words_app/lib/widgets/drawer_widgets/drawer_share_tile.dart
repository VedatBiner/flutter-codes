// 📁 lib/widgets/drawer_widgets/drawer_share_tile.dart
//
// Kelimelik Words App
// -----------------------------------------------------------
// Bu widget, Drawer menüsünde yer alan “Yedekleri Paylaş” seçeneğini
// tek başına yönetir.
//
// Görevleri:
//  • Download/{appName} klasöründeki CSV, JSON, Excel, SQL dosyalarını paylaşır.
//  • share_helper.dart dosyasındaki shareBackupFolder() metodunu çağırır.
//  • Başarılı veya başarısız durumlarda log üretir.
//
// Kullanım:
//   import 'drawer_widgets/drawer_share_tile.dart';
//   ...
//   const DrawerShareTile();
//
// Gereken dosyalar:
//   - lib/utils/fc_files/share_helper.dart  → shareBackupFolder()
//   - permission_handler / share_plus paketleri
// -----------------------------------------------------------

import 'package:material_ui/material_ui.dart';

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
        "Download klasöründeki dosyaları paylaş",
        style: drawerMenuSubtitleText,
      ),
      onTap: () async {
        await shareBackupFolder(); // 📤 paylaşım işlemi başlatılıyor
        if (!context.mounted) return;
        if (context.mounted) Navigator.pop(context);
        showShareFilesNotification(context);
      },
    );
  }
}
