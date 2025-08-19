// <📜 ----- home_page.dart ----->

// 📌 Dart hazır paketleri
import 'dart:developer' show log;

/// 📌 Flutter hazır paketleri
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../models/word_model.dart';
import '../services/export_words.dart'; // <-- export servisi burada

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String status = 'Hazır. Konsolu kontrol edin.';
  bool exporting = false;

  @override
  void initState() {
    super.initState();
    _readKelimeler(); // açılışta çalıştır
  }

  Future<void> _readKelimeler() async {
    try {
      // Model ile tipli referans (withConverter)
      final col = FirebaseFirestore.instance
          .collection(collectionName)
          .withConverter<Word>(
            fromFirestore: Word.fromFirestore,
            toFirestore: (w, _) => w.toFirestore(),
          );

      log('📥 "$collectionName" (model) okunuyor ...', name: collectionName);

      final agg = await col.count().get(); // Aggregate count
      log('✅ Toplam kayıt sayısı : ${agg.count}', name: collectionName);

      final snap = await col.limit(1).get();
      if (snap.docs.isNotEmpty) {
        final Word w = snap.docs.first.data();
        log(
          '🔎 Örnek: ${w.id} -> ${w.sirpca} ➜ ${w.turkce} (userEmail: ${w.userEmail})',
          name: collectionName,
        );
      } else {
        log('ℹ️ Koleksiyonda belge yok.', name: collectionName);
      }

      setState(() => status = 'Okuma tamam. Console ’a yazıldı.');
    } catch (e, st) {
      log(
        '❌ Hata ($collectionName okuma): $e',
        name: collectionName,
        error: e,
        stackTrace: st,
        level: 1000,
      );
      setState(() => status = 'Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sırpça-Türkçe Sözlük - WEB')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(status, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: exporting
                      ? null
                      : () async {
                          setState(() {
                            exporting = true;
                            status = 'JSON hazırlanıyor...';
                          });
                          try {
                            // ↪️ Ayrı servis dosyasına taşınmış export
                            final savedAt = await exportWordsToJson(
                              pageSize: 1000,
                              subfolder:
                                  'kelimelik_words_app', // istersen değiştir/kaldır
                            );
                            if (!mounted) return;
                            setState(
                              () => status = 'JSON kaydedildi: $savedAt',
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Kaydedildi: $savedAt')),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            setState(() => status = 'Hata: $e');
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('Hata: $e')));
                          } finally {
                            if (mounted) {
                              setState(() => exporting = false);
                            }
                          }
                        },
                  icon: const Icon(Icons.download),
                  label: const Text('Tüm Veriyi JSON Dışa Aktar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
