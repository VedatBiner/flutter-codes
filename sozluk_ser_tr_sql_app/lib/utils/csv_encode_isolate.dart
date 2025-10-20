// 📃 utils/csv_encode_isolate.dart
//
// Girdi: { "rows": List<Map<String, dynamic>> }
// Çıktı: String (CSV)
//
// Not: CSV üretimi büyük veri setlerinde CPU-yoğun olabilir; bu yüzden izoleye alınır.

import 'dart:isolate';

void csvEncodeEntryPoint(SendPort sendPort, dynamic initialMessage) {
  try {
    final rows = (initialMessage as Map)['rows'] as List<Map<String, dynamic>>;
    if (rows.isEmpty) {
      sendPort.send({'type': 'data', 'value': ''});
      sendPort.send({'type': 'done'});
      return;
    }

    final headers = rows.first.keys.toList();
    final sb = StringBuffer();
    sb.writeln(headers.join(','));

    final total = rows.length;
    for (var i = 0; i < rows.length; i++) {
      final r = rows[i];
      final line = headers
          .map((h) {
            final v = r[h];
            final s = (v ?? '').toString().replaceAll('"', '""');
            return '"$s"';
          })
          .join(',');
      sb.writeln(line);

      if (i % 1000 == 0 || i == rows.length - 1) {
        sendPort.send({'type': 'progress', 'value': (i + 1) / total});
      }
    }

    sendPort.send({'type': 'data', 'value': sb.toString()});
    sendPort.send({'type': 'done'});
  } catch (e) {
    sendPort.send({'type': 'error', 'error': e.toString()});
    sendPort.send({'type': 'done'});
  }
}
