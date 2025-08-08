// 📃 widgets/drawer_widgets/drawer_renew_db_tile.dart
// Drawer 'daki "Veritabanını Yenile (SQL)" satırını bağımsız bir widget
// olarak çıkardık.
//

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

import '../sql_loading_overlay.dart';

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
        leading: const Icon(Icons.refresh, color: Colors.amber),
        title: const Text(
          'Veritabanını Yenile (SQL)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () async {
          // Drawer 'ı kapat
          Navigator.of(context).maybePop();
          await Future.delayed(const Duration(milliseconds: 300));
          if (!context.mounted) return;

          // ✅ Overlay erişimi
          final overlay = Navigator.of(context).overlay;
          final overlayEntry = OverlayEntry(
            builder: (context) => const SQLLoadingCardOverlay(),
          );
          overlay?.insert(overlayEntry);

          // 🔄 JSON 'dan veri yükle ve ilerlemeyi overlay 'e yansıt
          await onLoadJsonData(
            ctx: context,
            onStatus: (loading, progress, currentWord, elapsed) {
              SQLLoadingCardOverlay.update(
                progress: progress,
                loadingWord: currentWord,
                elapsedTime: elapsed,
                show: loading,
              );

              if (!loading) {
                // ✅ Overlay kaldırma işlemini güvenli şekilde zamanla
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (overlayEntry.mounted) {
                    overlayEntry.remove();
                  }
                });
              }
            },
          );
        },
      ),
    );
  }
}
