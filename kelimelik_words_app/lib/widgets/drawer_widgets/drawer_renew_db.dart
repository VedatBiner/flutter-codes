// 📃 widgets/drawer_widgets/drawer_renew_db_tile.dart
// Drawer 'daki "Veritabanını Yenile (SQL)" satırını bağımsız bir widget
// olarak çıkardık.
//

// 📌 Flutter paketleri
import 'package:material_ui/material_ui.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/text_constants.dart';
import '../../db/db_helper.dart';

/// Callback imzası: üst seviye widget 'tan gelir
/// ({ctx, onStatus}) → Future<void>
class DrawerRenewDbTile extends StatelessWidget {
  final Future<void> Function({
    required BuildContext ctx,
    required void Function(bool, double, String?, Duration) onStatus,
  })
  onLoadJsonData;

  const DrawerRenewDbTile({super.key, required this.onLoadJsonData});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Veritabanını Yenile',
      child: ListTile(
        leading: const Icon(Icons.refresh, color: Colors.amber, size: 32),
        title: const Text('Veritabanını Yenile (SQL)', style: drawerMenuText),
        onTap: () async {
          /// Drawer kapanmadan önce KÖK context 'i alalım
          final rootCtx = Navigator.of(context, rootNavigator: true).context;

          /// Drawer 'ı kapat
          Navigator.of(context).maybePop();
          await Future.delayed(const Duration(milliseconds: 300));

          /// 1️⃣ Yerel tabloyu sil
          final db = await DbHelper.instance.database;
          await db.delete('words');

          /// 2️⃣ Yeniden indir / yükle (kök context kullan!)
          if (!context.mounted) return;
          await onLoadJsonData(
            ctx: rootCtx,
            onStatus: (_, _, _, _) {}, // Drawer 'da ilerleme yok
          );
        },
      ),
    );
  }
}
