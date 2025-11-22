// 📃 <----- lib/utils/fc_files/csv_helper.dart ----->
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart'; // ✅ compute için
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';

/// Asset içindeki CSV verisini cihaz dizinine kopyalar.
Future<void> createDeviceCsvFromAsset() async {
  const tag = 'csv_helper';
  try {
    const assetCsvPath = 'assets/database/$fileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    // 🧠 compute() içinde parse et
    final rows = await compute(_parseCsvRaw, csvRaw);

    if (rows.isEmpty) {
      log('⚠️ Asset CSV boş!', name: tag);
      return;
    }

    final headers = rows.first.map((e) => e.toString()).toList();

    final List<List<dynamic>> out = [headers];
    for (int i = 1; i < rows.length; i++) {
      final row = List<dynamic>.from(rows[i]);
      out.add(row);
    }

    final csvOut = const ListToCsvConverter().convert(out);

    final directory = await getApplicationDocumentsDirectory();
    final outPath = join(directory.path, fileNameCsv);

    if (!await File(outPath).exists()) {
      await File(outPath).writeAsString(csvOut);
      log('✅ CSV oluşturuldu: $outPath', name: tag);
    } else {
      log('ℹ️ CSV zaten mevcut, yeniden oluşturulmadı.', name: tag);
    }
  } catch (e, st) {
    log('❌ CSV oluşturma hatası: $e', name: tag, error: e, stackTrace: st);
  }
}

/// 🔹 compute() içinde çalışan parse işlemi
List<List<dynamic>> _parseCsvRaw(String raw) {
  // Farklı işletim sistemlerinden gelebilecek satır sonu karakterlerini ('\r\n', '\n', '\r')
  // standart '\n' formatına getirelim ki parser her zaman doğru çalışsın.
  final normalizedRaw = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  return const CsvToListConverter(
    eol: '\n',
    shouldParseNumbers: false,
  ).convert(normalizedRaw);
}
