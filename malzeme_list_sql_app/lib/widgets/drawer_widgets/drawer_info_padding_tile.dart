// 📃 widgets/drawer_widgets/info_padding_tile.dart
// Versiyon ve yazılımcı bilgileri burada gösterilir.

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/text_constants.dart';

class InfoPaddingTile extends StatelessWidget {
  final String appVersion;

  const InfoPaddingTile({super.key, required this.appVersion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Text(appVersion, textAlign: TextAlign.center, style: versionText),
          Text('Vedat Biner', style: nameText),
          Text('© 2025, vbiner@gmail.com', style: nameText),
        ],
      ),
    );
  }
}
