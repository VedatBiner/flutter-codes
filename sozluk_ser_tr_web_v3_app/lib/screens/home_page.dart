// <📜 ----- home_page.dart ----->

// 📌 Dart hazır paketleri
import 'dart:developer';

/// 📌 Flutter hazır paketleri
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String status = 'Hazır. Konsolu kontrol edin.';

  @override
  void initState() {
    super.initState();
    _readKelimeler(); // açılışta çalıştır
  }

  Future<void> _readKelimeler() async {
    try {
      final col = FirebaseFirestore.instance.collection(collectionName);

      log(
        '📥 "$collectionName" koleksiyonu okunuyor ...',
        name: collectionName,
      );
      final agg = await col.count().get(); // Aggregate count
      log('✅ Toplam kayıt sayısı : ${agg.count}', name: collectionName);

      final snap = await col.limit(1).get();
      if (snap.docs.isNotEmpty) {
        final d = snap.docs.first;
        log(
          '🔎 Örnek belge: ${d.id} -> ${_preview(d.data())}',
          name: collectionName,
        );
      } else {
        log('ℹ️ Koleksiyonda belge yok.', name: collectionName);
      }

      setState(() => status = 'Okuma tamam. Console ’a yazıldı.');
    } catch (e, st) {
      log(
        '❌ Hata ($collectionName okuma): $e',
        name: 'collectionName',
        error: e,
        stackTrace: st,
        level: 1000,
      );
      setState(() => status = 'Hata: $e');
    }
  }

  String _preview(Map<String, dynamic> m) {
    final s = m.toString();
    return s.length > 300 ? '${s.substring(0, 300)} …' : s;
    // Konsolu şişirmemek için kısa önizleme
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sırpça-Türkçe Sözlük - WEB')),
      body: Center(child: Text(status)),
    );
  }
}
