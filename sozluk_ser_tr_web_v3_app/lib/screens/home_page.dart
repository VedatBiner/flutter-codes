// <📜 ----- home_page.dart ----->

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:developer' show log;

/// 📌 Flutter hazır paketleri
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../utils/json_saver.dart'; // <-- IMPORT EN ÜSTE ALINDI

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

  Future<T> _retryWithBackoff<T>(
    Future<T> Function() task, {
    String name = '',
    int maxAttempts = 5,
    Duration initialDelay = const Duration(milliseconds: 500),
  }) async {
    var attempt = 0;
    var delay = initialDelay;
    while (true) {
      try {
        return await task();
      } catch (e, st) {
        attempt++;
        final msg = e.toString();
        final isTransient =
            msg.contains('UNAVAILABLE') || msg.contains('unavailable');
        if (attempt >= maxAttempts || !isTransient) {
          log(
            '❌ Retry bitti ($name): $e',
            name: 'retry',
            error: e,
            stackTrace: st,
            level: 1000,
          );
          rethrow;
        }
        log(
          '⏳ Geçici hata, tekrar denenecek ($name, deneme $attempt/$maxAttempts, ${delay.inMilliseconds}ms)...',
          name: 'retry',
        );
        await Future.delayed(delay);
        delay *= 2; // exponential backoff
      }
    }
  }

  Future<void> _readKelimeler() async {
    try {
      final col = FirebaseFirestore.instance.collection(collectionName);

      log(
        '📥 "$collectionName" koleksiyonu okunuyor ...',
        name: collectionName,
      );

      // Ağ kapalı kalmış olabilir, emin olmak için:
      await FirebaseFirestore.instance.enableNetwork();

      final agg = await _retryWithBackoff(
        () => col.count().get(),
        name: 'count',
      );
      log('✅ Toplam kayıt sayısı : ${agg.count}', name: collectionName);

      final snap = await _retryWithBackoff(
        () => col.limit(1).get(),
        name: 'get',
      );
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
        name: collectionName,
        error: e,
        stackTrace: st,
        level: 1000,
      );
      setState(() => status = 'Hata: $e');
    }
  }

  /// Tüm koleksiyonu sayfalı çek → JSON hazırla → indir/kaydet (platforma göre)
  Future<void> _exportAllToJson({int pageSize = 1000}) async {
    if (exporting) return;
    setState(() {
      exporting = true;
      status = 'JSON hazırlanıyor...';
    });

    final sw = Stopwatch()..start();
    final all = <Map<String, dynamic>>[];

    try {
      final col = FirebaseFirestore.instance.collection(collectionName);

      // docId ile stabil sayfalama (ek indeks gerekmez)
      Query<Map<String, dynamic>> base = col.orderBy(FieldPath.documentId);
      String? lastId;

      while (true) {
        var q = base.limit(pageSize);
        if (lastId != null) q = q.startAfter([lastId]);

        final snap = await q.get();
        if (snap.docs.isEmpty) break;

        for (final d in snap.docs) {
          final norm = _normalizeForJson(d.data());
          norm['id'] = d.id;
          all.add(norm);
        }

        lastId = snap.docs.last.id;
        if (snap.docs.length < pageSize) break; // son sayfa
      }

      final jsonStr = const JsonEncoder.withIndent('  ').convert(all);
      final ts = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filename = fileNameJson;

      // Downloads 'a yaz ve YOLU al
      final savedAt = await JsonSaver.saveToDownloads(
        jsonStr,
        filename,
        subfolder: 'kelimelik_words_app',
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

  /// JSON’a uygun hale getir (Timestamp/GeoPoint/DocRef vs.)
  Map<String, dynamic> _normalizeForJson(Map<String, dynamic> src) {
    dynamic walk(dynamic value) {
      if (value is Timestamp) {
        return {'_ts': value.toDate().toIso8601String()};
      } else if (value is GeoPoint) {
        return {
          '_geo': {'lat': value.latitude, 'lng': value.longitude},
        };
      } else if (value is DocumentReference) {
        return {'_ref': value.path};
      } else if (value is Map) {
        return value.map((k, v) => MapEntry(k.toString(), walk(v)));
      } else if (value is List) {
        return value.map(walk).toList();
      } else {
        return value;
      }
    }

    final out = walk(src);
    return (out as Map).cast<String, dynamic>();
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
