// 📃 widgets/drawer_widgets/drawer_change_view_tile.dart
// "Görünüm Değiştir" satırını bağımsız bir widget ’a taşıdık.
//

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';

class DrawerChangeViewTile extends StatelessWidget {
  final bool isFihristMode;
  final VoidCallback onToggleViewMode;

  const DrawerChangeViewTile({
    super.key,
    required this.isFihristMode,
    required this.onToggleViewMode,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Görünüm değiştir',
      child: ListTile(
        leading: Icon(Icons.swap_horiz, color: menuColor, size: 32),
        title: Text(
          isFihristMode ? 'Klasik Görünüm' : 'Fihristli Görünüm',
          style: drawerMenuText,
        ),
        onTap: () {
          onToggleViewMode();
          Navigator.of(context).maybePop();
        },
      ),
    );
  }
}
