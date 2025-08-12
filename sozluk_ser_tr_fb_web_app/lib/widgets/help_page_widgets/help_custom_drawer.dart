// 📃 <----- help_custom_drawer.dart ----->

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../custom_drawer.dart';

Widget buildHelpDrawer() {
  return CustomDrawer(
    onDatabaseUpdated: () {},
    appVersion: '',
    isFihristMode: true,
    onToggleViewMode: () {},
    onLoadJsonData:
        ({
          required BuildContext ctx,
          required void Function(bool, double, String?, Duration) onStatus,
        }) async {
          // Bir şey yapmıyorsan bile, boş bir işlem tanımlanmalı:
          onStatus(false, 0.0, null, Duration.zero);
        },
  );
}
