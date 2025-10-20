// 📃 utils/json_saver.dart
//
// Büyük veri setlerini dışa aktarmada (CSV/JSON string üretimi) izole kullanımı.
// - buildCsvWithIsolate: DB'den ana izolede rows alır, CSV encode'u izoleye taşır.
// - buildJsonWithIsolate: JSON string üretimini izolede yapar (opsiyonel).
//
// Notlar:
// - Burada sadece string üretimi var. Dosyaya yazma, paylaşılan yöntemlerinle (IO/Share)
//   ana izolede yapılmalı.

import 'dart:convert';
import 'dart:isolate';

import '../db/db_helper.dart';
import 'csv_encode_isolate.dart';
import 'isolate_runner.dart';

/// CSV üretimi (izole + progress)
Future<String> buildCsvWithIsolate({
  required void Function(double p) onProgress,
}) async {
  // DB 'den veriyi ana izolede çek
  final db = await DbHelper.instance.database;
  final rows = await db.query('words'); // List<Map<String, dynamic>>

  final runner = await runWithProgress<String>(
    entryPoint: _csvEncodeBridge, // bridge ile string döndürüyoruz
    initialMessage: {'rows': rows},
  );

  final sub = runner.progress.listen(onProgress);
  final csv = await runner.result;
  await sub.cancel();
  return csv;
}

/// JSON üretimi (isteğe bağlı). Genelde jsonEncode hızlıdır, ama çok büyük veri varsa izoleye alınabilir.
Future<String> buildJsonWithIsolate({
  required void Function(double p) onProgress,
}) async {
  final db = await DbHelper.instance.database;
  final rows = await db.query('words');

  // Burada computeWrapper da yeterli olabilir; progress istersen runWithProgress yazabilirsin.
  // Basitçe computeWrapper ile:
  final jsonString = await computeWrapper<List<Map<String, dynamic>>, String>(
    (data) => jsonEncode(data),
    rows,
  );
  // progress yoksa onProgress(1.0) gibi sabitleyebilirsin:
  onProgress(1.0);
  return jsonString;
}

/// csvEncodeEntryPoint, StringBuffer döndürmüyor; içerde Map mesajlar var.
/// Dolayısıyla küçük bir bridge ile 'data' değerindeki string 'i ana izoleye geçiriyoruz.
void _csvEncodeBridge(SendPort sp, dynamic initialMessage) {
  // mevcut entryPoint 'i doğrudan çağır
  // ancak ondan gelen 'data' mesajı zaten string, burada ek iş yok
  csvEncodeEntryPoint(sp, initialMessage);
}
