// 📃 widgets/drawer_widgets/drawer_title.dart
// Drawer başlığını tek başına bir widget olarak tanımladık.
//

import 'package:flutter/material.dart';

import '../../constants/text_constants.dart';

class DrawerTitleWidget extends StatelessWidget {
  const DrawerTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Arka plan rengi, üst widget olan CustomDrawer'dan gelecek.
    // Bu, temanın aydınlık veya karanlık olmasına göre rengin
    // dinamik olarak ayarlanmasını sağlar.
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text('🎬 Menü (Netflix)', style: drawerMenuTitleText),
    );
  }
}
