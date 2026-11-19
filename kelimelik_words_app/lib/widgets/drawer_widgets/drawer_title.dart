// 📃 widgets/drawer_widgets/drawer_title.dart
// Drawer başlığını tek başına bir widget olarak tanımladık.
//

// 📌 Flutter paketleri
import 'package:material_ui/material_ui.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';

class DrawerTitleWidget extends StatelessWidget {
  const DrawerTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: drawerColor,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text('Menü (Kelimelik)', style: drawerMenuTitleText),
    );
  }
}
