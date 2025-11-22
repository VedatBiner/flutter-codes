// <----- lib/utils/csv_parser.dart ----->

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../constants/file_info.dart';
import '../models/item_model.dart';

class CsvParser {
  /// Asset içindeki CSV dosyasını `compute` kullanarak verimli bir şekilde
  /// okur ve `Word` nesnelerinden oluşan bir liste olarak döndürür.
  static Future<List<Word>> parseWords() async {
    final raw = await rootBundle.loadString("assets/database/$fileNameCsv");

    /// `compute` → isolate içinde CSV satırlarını çıkarır
    final List<Map<String, String>> rows = await compute(_parseCsvIsolate, raw);

    final List<Word> words = rows.map((row) {
      return Word(word: row['word']!, meaning: row['meaning']!);
    }).toList();

    return words;
  }

  /// Isolate içinde çalışan, CSV verisini ayrıştıran fonksiyon.
  static List<Map<String, String>> _parseCsvIsolate(String raw) {
    // Farklı OS 'lerden gelen satır sonu karakterlerini standart hale getir.
    final normalizedRaw = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    final rows = const CsvToListConverter().convert(normalizedRaw, eol: "\n");

    // Başlık satırını kaldır.
    if (rows.isNotEmpty) {
      rows.removeAt(0);
    }

    // Satırları 'word' ve 'meaning' içeren map listesine dönüştür.
    return rows
        .where((r) => r.length >= 2) // Bozuk satırları atla
        .map(
          (r) => {
            'word': r[0].toString().trim(),
            'meaning': r[1].toString().trim(),
          },
        )
        .toList();
  }
}
