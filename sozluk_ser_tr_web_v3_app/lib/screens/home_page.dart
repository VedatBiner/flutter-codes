// <📜 ----- home_page.dart ----->

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:developer' show log;

/// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

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
  bool exporting = false;

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
        name: collectionName,
        error: e,
        stackTrace: st,
        level: 1000,
      );
      setState(() => status = 'Hata: $e');
    }
  }

  /// WEB: JSON 'u tarayıcıda indirt
  void _downloadJsonWeb(String json, String suggestedName) {
    final bytes = utf8.encode(json);
    final blob = html.Blob([bytes], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = suggestedName
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  /// Tüm koleksiyonu sayfalı çek → JSON hazırla → indir (WEB)
  Future<void> _exportAllToJsonWeb({int pageSize = 1000}) async {
    if (exporting) return;
    setState(() {
      exporting = true;
      status = 'JSON hazırlanıyor...';
    });

    final sw = Stopwatch()..start();
    final all = <Map<String, dynamic>>[];

    try {
      final col = FirebaseFirestore.instance.collection(collectionName);

      // ✅ DÜZELTME: FieldPath.documentId parantezsiz kullanılmalı
      Query<Map<String, dynamic>> base = col.orderBy(FieldPath.documentId);

      String? lastId;

      while (true) {
        Query<Map<String, dynamic>> q = base.limit(pageSize);
        if (lastId != null) {
          q = q.startAfter([lastId]);
        }

        final snap = await q.get();
        if (snap.docs.isEmpty) break;

        for (final d in snap.docs) {
          final norm = _normalizeForJson(d.data());
          norm['id'] = d.id; // doc id ’yi de ekleyelim
          all.add(norm);
        }

        lastId = snap.docs.last.id;

        // İlerleme log 'u
        if (all.length % (pageSize * 5) == 0) {
          log(
            '⏳ İlerleme: ${all.length} kayıt toplandı...',
            name: collectionName,
          );
        }

        if (snap.docs.length < pageSize) break; // son sayfa
      }

      final jsonStr = const JsonEncoder.withIndent('  ').convert(all);
      final ts = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filename = '${collectionName}_export_$ts.json';

      _downloadJsonWeb(jsonStr, filename);
      sw.stop();
      log(
        '📦 JSON hazırlandı: ${all.length} kayıt, ${sw.elapsedMilliseconds} ms',
        name: collectionName,
      );
      setState(() => status = 'JSON indirildi: $filename');
    } catch (e, st) {
      sw.stop();
      log(
        '❌ Hata (JSON export): $e',
        name: collectionName,
        error: e,
        stackTrace: st,
        level: 1000,
      );
      setState(() => status = 'Hata: $e');
    } finally {
      setState(() => exporting = false);
    }
  }

  /// JSON ’a uygun hale getir (Timestamp/GeoPoint/DocRef vs.)
  Map<String, dynamic> _normalizeForJson(Map<String, dynamic> src) {
    // ✅ DÜZELTME: dynamic döndürmeli; List/primitive gelebilir
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

    // src Map olduğu için sonuç da Map olur; güvenli cast
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
                      : () => _exportAllToJsonWeb(pageSize: 1000),
                  icon: const Icon(Icons.download),
                  label: const Text('Tüm Veriyi JSON İndir (Web)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
