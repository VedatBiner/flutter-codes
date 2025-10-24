// 📦 csv_parser.dart

// 📌 Flutter paketleri

import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

Future<List<List<dynamic>>> parseCsvData(String assetPath) async {
  try {
    final rawData = await rootBundle.loadString(assetPath);

    log(
      "[csv_parser] 📄 Asset içeriği (ilk 200 karakter): ${rawData.substring(0, 200)}",
    );

    final List<List<dynamic>> csvTable = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(rawData);

    log("[csv_parser] 📊 Toplam satır (başlık dahil): ${csvTable.length}");
    log("[csv_parser] ✅ Yüklenen veri satırı sayısı: ${csvTable.length - 1}");

    return csvTable;
  } catch (e) {
    log("[csv_parser] ❌ CSV yükleme hatası: $e");
    return [];
  }
}
