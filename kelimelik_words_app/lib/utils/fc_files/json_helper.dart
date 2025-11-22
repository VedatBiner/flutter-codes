// 📃 <----- lib/utils/fc_files/json_helper.dart ----->
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
Future<void> createJsonFromAssetCsv() async {
  const tag = 'json_helper';
  try {
    const assetCsvPath = 'assets/database/$fileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    /// 🧠 compute() içinde parse işlemi
    final jsonList = await compute(_parseCsvToJson, csvRaw);

    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);

    if (!await File(jsonPath).exists()) {
      await File(jsonPath).writeAsString(jsonStr);
      log('✅ JSON oluşturuldu: $jsonPath', name: tag);
    } else {
      log('ℹ️ JSON zaten mevcut, yeniden oluşturulmadı.', name: tag);
    }
  } catch (e, st) {
    log(
      '❌ CSV→JSON dönüştürme hatası: $e',
      name: tag,
      error: e,
      stackTrace: st,
    );
  }
}

/// 🔹 compute() ile ayrı isolate ’ta çalışan CSV→JSON dönüştürücü
List<Map<String, dynamic>> _parseCsvToJson(String csvRaw) {
  // Farklı OS 'lerden gelen satır sonu karakterlerini ('\r\n', '\r') standart '\n' formatına getir.
  final normalizedRaw = csvRaw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  final rows = const CsvToListConverter(
    eol: '\n',
    shouldParseNumbers: false,
  ).convert(normalizedRaw);

  if (rows.isEmpty) return [];

  final headers = rows.first.map((e) => e.toString().trim()).toList();

  final List<Map<String, dynamic>> jsonList = [];
  for (int i = 1; i < rows.length; i++) {
    final row = rows[i];
    if (row.length != headers.length) continue;

    final record = <String, dynamic>{};
    for (int j = 0; j < headers.length; j++) {
      final value = row[j].toString().trim();
      record[headers[j]] = value;
    }
    jsonList.add(record);
  }

  return jsonList;
}
