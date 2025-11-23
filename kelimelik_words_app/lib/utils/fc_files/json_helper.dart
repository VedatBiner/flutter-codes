// 📃 <----- lib/utils/fc_files/json_helper.dart ----->
//
// CSV → JSON dönüştürür (compute içinde)
// -----------------------------------------------------------
// • Bozuk satırlar loglanır
// • Benchmark: CSV → JSON dönüşüm süresi ölçülür
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';

Future<int> createJsonFromAssetCsv() async {
  const tag = 'json_helper';
  final sw = Stopwatch()..start();

  try {
    const assetCsvPath = 'assets/database/$fileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    final jsonList = await compute(_parseCsvToJson, csvRaw);

    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);

    await File(jsonPath).writeAsString(jsonStr);

    sw.stop();
    log('⏱ CSV → JSON: ${sw.elapsedMilliseconds} ms', name: tag);

    log(
      '✅ JSON oluşturuldu/güncellendi: $jsonPath (${jsonList.length} kayıt)',
      name: tag,
    );

    return sw.elapsedMilliseconds;
  } catch (e, st) {
    log(
      '❌ CSV→JSON dönüştürme hatası: $e',
      name: tag,
      error: e,
      stackTrace: st,
    );
    return -1;
  }
}

/// 🔹 compute() içinde çalışan CSV→JSON dönüştürücü
List<Map<String, dynamic>> _parseCsvToJson(String csvRaw) {
  const tag = 'json_helper_parser';

  final normalized = csvRaw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final rows = const CsvToListConverter(eol: '\n').convert(normalized);

  if (rows.length < 2) return [];

  final headers = rows[0].map((h) => h.toString().trim()).toList();
  final List<Map<String, dynamic>> jsonList = [];

  for (int i = 1; i < rows.length; i++) {
    final row = rows[i];

    if (row.isEmpty || row.every((e) => e.toString().trim().isEmpty)) {
      log("⚠️ Boş satır atlandı (satır $i)", name: tag);
      continue;
    }

    if (row.length < headers.length) {
      log("⚠️ Eksik hücre tespit edildi (satır $i): $row", name: tag);
      continue;
    }

    if (row.length > headers.length) {
      log("⚠️ Fazla hücre tespit edildi (satır $i): $row", name: tag);
    }

    final map = <String, dynamic>{};
    for (int j = 0; j < headers.length; j++) {
      map[headers[j]] = row[j].toString().trim();
    }
    jsonList.add(map);
  }

  return jsonList;
}
