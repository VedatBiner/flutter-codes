// 📃 <----- firestore_collection_tools.dart ----->
//
// Firestore koleksiyon yardımcıları (ortak kullanıma uygun)
// - clearCollection: bir koleksiyondaki tüm belgeleri batched delete ile temizler.
//

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Tüm belgeleri siler (sayfalı/batched).
Future<void> clearCollection(
  String collectionPath, {
  int pageSize = 400,
  Duration pause = const Duration(milliseconds: 100),
}) async {
  final col = FirebaseFirestore.instance.collection(collectionPath);

  while (true) {
    final snap = await col.limit(pageSize).get();
    if (snap.docs.isEmpty) break;

    final batch = FirebaseFirestore.instance.batch();
    for (final d in snap.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();

    // Küçük bir bekleme (okuma/yazma kotalarına saygılı olmak için)
    if (pause > Duration.zero) {
      await Future.delayed(pause);
    }
  }
}
