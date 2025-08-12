// 📃 widgets/drawer_widgets/drawer_renew_db_tile.dart
// Drawer 'daki "Veritabanını Yenile" satırını bağımsız bir widget
// olarak çıkardık.
//
// 📌 Flutter paketleri
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/text_constants.dart';

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
        title: const Text('Veritabanını Yenile', style: drawerMenuText),
        onTap: () async {
          // Drawer kapanmadan önce KÖK context 'i alalım
          final rootCtx = Navigator.of(context, rootNavigator: true).context;

          // Drawer 'ı kapat
          Navigator.of(context).maybePop();
          await Future.delayed(const Duration(milliseconds: 300));

          // 1️⃣ Firestore koleksiyonunu sil
          const pageSize = 400;
          final colRef = FirebaseFirestore.instance.collection('kelimeler');
          while (true) {
            final snapshot = await colRef.limit(pageSize).get();
            if (snapshot.docs.isEmpty) break;
            final batch = FirebaseFirestore.instance.batch();
            for (final doc in snapshot.docs) {
              batch.delete(doc.reference);
            }
            await batch.commit();
            await Future.delayed(const Duration(milliseconds: 100));
          }

          // 2️⃣ Yeniden indir / yükle (kök context kullan!)
          await onLoadJsonData(
            ctx: rootCtx,
            onStatus: (_, __, ___, ____) {}, // Drawer 'da ilerleme yok
          );
        },
      ),
    );
  }
}
