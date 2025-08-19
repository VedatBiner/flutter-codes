// <📜 ----- home_page.dart ----->

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:developer' show log;

/// 📌 Flutter hazır paketleri
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../models/word_model.dart';
import '../utils/json_saver.dart';

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

  /// Tüm koleksiyonu (model ile) sayfalı çek → JSON hazırla → indir/kaydet (platforma göre)
  Future<void> _exportAllToJson({int pageSize = 1000}) async {
    if (exporting) return;
    setState(() {
      exporting = true;
      status = 'JSON hazırlanıyor...';
    });

    final sw = Stopwatch()..start();
    final all = <Word>[];

    try {
      // Model ile tipli referans
      final col = FirebaseFirestore.instance
          .collection(collectionName)
          .withConverter<Word>(
            fromFirestore: Word.fromFirestore,
            toFirestore: (w, _) => w.toFirestore(),
          );

      // docId ile stabil sayfalama (ek indeks gerekmez)
      Query<Word> base = col.orderBy(FieldPath.documentId);
      String? lastId;

      while (true) {
        var q = base.limit(pageSize);
        if (lastId != null) q = q.startAfter([lastId]);

        final snap = await q.get();
        if (snap.docs.isEmpty) break;

        for (final d in snap.docs) {
          // fromFirestore zaten id alanını doc.id olarak set ediyor
          final w = d.data();
          all.add(w);
        }

        lastId = snap.docs.last.id;
        if (snap.docs.length < pageSize) break; // son sayfa
      }

      // Model → JSON (ID dahil)
      final jsonStr = const JsonEncoder.withIndent(
        '  ',
      ).convert(all.map((w) => w.toJson(includeId: true)).toList());

      // 📛 Dosya adı: file_info.dart içindeki sabit
      final filename = fileNameJson; // örn: 'ser_tr_dict.json'

      // ✅ Koşullu implementasyon: Web'de indirme, mobil/desktop'ta Downloads’a yaz
      final savedAt = await JsonSaver.saveToDownloads(
        jsonStr,
        filename,
        subfolder: 'kelimelik_words_app', // istersen kaldır/değiştir
      );

      sw.stop();
      log(
        '📦 JSON hazırlandı: ${all.length} kayıt, ${sw.elapsedMilliseconds} ms',
        name: collectionName,
      );

      if (!mounted) return;
      setState(() => status = 'JSON kaydedildi: $savedAt');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kaydedildi: $savedAt')));
    } catch (e, st) {
      sw.stop();
      log(
        '❌ Hata (JSON export): $e',
        name: collectionName,
        error: e,
        stackTrace: st,
        level: 1000,
      );
      if (!mounted) return;
      setState(() => status = 'Hata: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata: $e')));
    } finally {
      if (mounted) setState(() => exporting = false);
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
                      : () => _exportAllToJson(pageSize: 1000),
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
