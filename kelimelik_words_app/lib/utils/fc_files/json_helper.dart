// 📃 <----- lib/utils/fc_files/json_helper.dart ----->
//
// CSV → JSON dönüştürür (compute içinde)
// -----------------------------------------------------------
// • Bozuk satırlar loglanır: eksik hücre / fazla hücre / boş satır.
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

Future<void> createJsonFromAssetCsv() async {
  const tag = 'json_helper';
  try {
    const assetCsvPath = 'assets/database/$fileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    /// 🧠 compute() içinde parse
    final jsonList = await compute(_parseCsvToJson, csvRaw);

    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);

    await File(jsonPath).writeAsString(jsonStr);

    log(
      '✅ JSON oluşturuldu/güncellendi: $jsonPath (${jsonList.length} kayıt)',
      name: tag,
    );
  } catch (e, st) {
    log(
      '❌ CSV→JSON dönüştürme hatası: $e',
      name: tag,
      error: e,
      stackTrace: st,
    );
  }
}

/// 🔹 compute() içinde çalışan CSV→JSON dönüştürücü
///   • Bozuk satırları satır numarasıyla birlikte loglar.
List<Map<String, dynamic>> _parseCsvToJson(String csvRaw) {
  const tag = 'json_helper_parser';

  final normalized = csvRaw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final rows = const CsvToListConverter(eol: '\n').convert(normalized);

  if (rows.length < 2) return [];

  final headers = rows[0].map((h) => h.toString().trim()).toList();

  final List<Map<String, dynamic>> jsonList = [];
  int emptyRowCount = 0;
  int shortRowCount = 0;
  int longRowCount = 0;

  for (int i = 1; i < rows.length; i++) {
    final row = rows[i];

    // 🔎 Boş satır
    if (row.isEmpty || row.every((e) => e.toString().trim().isEmpty)) {
      emptyRowCount++;
      log("⚠️ Boş satır atlandı (satır $i)", name: tag);
      continue;
    }

    // 🔎 Eksik hücre
    if (row.length < headers.length) {
      shortRowCount++;
      log("⚠️ Eksik hücre tespit edildi (satır $i): $row", name: tag);
      continue;
    }

    // 🔎 Fazla hücre
    if (row.length > headers.length) {
      longRowCount++;
      log("⚠️ Fazla hücre tespit edildi (satır $i): $row", name: tag);
    }

    final map = <String, dynamic>{};
    for (int j = 0; j < headers.length; j++) {
      map[headers[j]] = row[j].toString().trim();
    }
    jsonList.add(map);
  }

  // Özet log (orta seviye rapor için güzel bir özet)
  log(
    '📊 CSV parse özeti → Boş: $emptyRowCount • Eksik hücre: $shortRowCount • Fazla hücre: $longRowCount',
    name: tag,
  );

  return jsonList;
}
