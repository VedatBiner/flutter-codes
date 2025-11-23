// 📃 <----- lib/utils/fc_files/json_helper.dart ----->
//
// CSV → JSON dönüştürür (compute içinde)
// -----------------------------------------------------------
// • Bozuk satırlar loglanır: eksik hücre / fazla hücre / boş satır.
// • İşlem süresi loglanır (benchmark).
//   - CSV parse + JSON oluşturma toplam süresi
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart'; // ✅ compute burada
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';

/// CSV → JSON dönüştürür ve cihaz dizinine kaydeder.
/// Bozuk satırlar parse sırasında loglanır (compute içindeki fonksiyonda).
Future<void> createJsonFromAssetCsv() async {
  const tag = 'json_helper';
  final sw = Stopwatch()..start();

  try {
    const assetCsvPath = 'assets/database/$fileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    /// 🧠 compute() içinde parse işlemi
    final jsonList = await compute(_parseCsvToJson, csvRaw);

    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);

    // Dosya varsa bile üzerine yaz, çünkü CSV güncellenmiş olabilir.
    await File(jsonPath).writeAsString(jsonStr);

    sw.stop();
    log(
      '✅ JSON oluşturuldu/güncellendi: $jsonPath (${jsonList.length} kayıt)',
      name: tag,
    );
    log('⏱ CSV→JSON toplam süre: ${sw.elapsedMilliseconds} ms', name: tag);
  } catch (e, st) {
    sw.stop();
    log(
      '❌ CSV→JSON dönüştürme hatası: $e',
      name: tag,
      error: e,
      stackTrace: st,
    );
  }
}

/// 🔹 compute() ile ayrı isolate ’ta çalışan CSV→JSON dönüştürücü
///  • Boş satırlar atlanır.
///  • Eksik / fazla hücre barındıran satırlar loglanır.
List<Map<String, dynamic>> _parseCsvToJson(String csvRaw) {
  const tag = 'json_helper_parser';

  // Farklı OS 'lerden gelen satır sonu karakterlerini ('\r\n', '\r')
  // standart '\n' formatına getir.
  final normalized = csvRaw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  // CSV 'yi satır listesine çevir
  final List<List<dynamic>> rows = const CsvToListConverter(
    eol: '\n',
  ).convert(normalized);

  if (rows.length < 2) {
    // Başlık veya veri satırı yoksa boş liste döndür.
    return [];
  }

  // İlk satırı başlık (anahtarlar) olarak al.
  final headers = rows[0].map((header) => header.toString().trim()).toList();
  final List<Map<String, dynamic>> jsonList = [];

  // 1. satırdan (ilk veri satırı) başlayarak döngüye gir.
  for (int i = 1; i < rows.length; i++) {
    final values = rows[i];

    // 🔎 Bozuk satır: tamamen boş
    if (values.isEmpty || values.every((e) => e.toString().trim().isEmpty)) {
      log("⚠️ Boş satır atlandı (satır $i)", name: tag);
      continue;
    }

    // 🔎 Bozuk satır: eksik hücre
    if (values.length < headers.length) {
      log("⚠️ Eksik hücre tespit edildi (satır $i): $values", name: tag);
      continue;
    }

    // 🔎 Bozuk satır: fazla hücre
    if (values.length > headers.length) {
      log("⚠️ Fazla hücre tespit edildi (satır $i): $values", name: tag);
    }

    final record = <String, dynamic>{};
    for (int j = 0; j < headers.length; j++) {
      // Başlık ve değerleri eşleştir.
      final value = values[j]?.toString().trim() ?? '';
      record[headers[j]] = value;
    }
    jsonList.add(record);
  }

  return jsonList;
}
