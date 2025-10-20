// 📃 utils/json_parse_isolate.dart
//
// Büyük JSON parse + ilerleme.
// Girdi: { "jsonString": String }
// Çıktı: List<Map<String, dynamic>> (veya List<Word>’ün map karşılığı)
//
// Not: Burada sadece CPU-yoğun parse var. Veritabanı yazımı ana izolede yapılmalı.

import 'dart:convert';
import 'dart:isolate';

void jsonParseEntryPoint(SendPort sendPort, dynamic initialMessage) {
  try {
    final jsonString = (initialMessage as Map)['jsonString'] as String;
    final List<dynamic> raw = json.decode(jsonString) as List<dynamic>;

    final total = raw.isEmpty ? 1 : raw.length;
    final List<Map<String, dynamic>> maps = [];
    for (var i = 0; i < raw.length; i++) {
      final e = raw[i] as Map<String, dynamic>;
      maps.add(e);

      // her 500 öğede bir ilerleme bildir
      if (i % 500 == 0 || i == raw.length - 1) {
        sendPort.send({'type': 'progress', 'value': (i + 1) / total});
      }
    }

    // çıktı (map listesi)
    sendPort.send({'type': 'data', 'value': maps});
    sendPort.send({'type': 'done'});
  } catch (e) {
    sendPort.send({'type': 'error', 'error': e.toString()});
    sendPort.send({'type': 'done'});
  }
}
