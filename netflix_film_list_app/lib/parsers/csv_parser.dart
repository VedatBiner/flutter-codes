// 📃 csv_parser.dart
import 'dart:developer';

import 'package:csv/csv.dart';

/// NetflixFilmHistory.csv dosyasını okuyup
/// List<Map<String, String>> formatında döndürür.
/// Tarihleri otomatik olarak "MM/DD/YY" → "DD/MM/YYYY" formatına çevirir.
Future<List<Map<String, String>>> parseCsvData(String csvContent) async {
  try {
    final List<List<dynamic>> rows = const CsvToListConverter(
      eol: '\n',
    ).convert(csvContent);

    if (rows.isEmpty) {
      log('⚠️ CSV dosyası boş görünüyor.');
      return [];
    }

    // Başlıklar (örnek: Title, Date, Device Type ...)
    final headers = rows.first.map((e) => e.toString().trim()).toList();
    final List<Map<String, String>> data = [];

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final map = <String, String>{};
      for (int j = 0; j < headers.length && j < row.length; j++) {
        final key = headers[j];
        var value = row[j].toString().trim();

        // 📅 Eğer sütun adı "Date" veya "Start Time" ise formatı düzelt
        if (key.toLowerCase().contains('date') ||
            key.toLowerCase().contains('time')) {
          value = _convertDateFormat(value);
        }

        map[key] = value;
      }
      data.add(map);
    }

    log('✅ CSV başarıyla parse edildi. Satır sayısı: ${data.length}');
    return data;
  } catch (e) {
    log('❌ CSV parse hatası: $e');
    return [];
  }
}

/// 📅 Tarih formatını dönüştürür.
/// Örn:  "5/23/22" → "23/05/2022"
String _convertDateFormat(String input) {
  try {
    // Sadece sayısal ve '/' içerenleri dönüştür
    if (!input.contains('/')) return input;

    final parts = input.split('/');
    if (parts.length < 3) return input;

    final month = parts[0].padLeft(2, '0');
    final day = parts[1].padLeft(2, '0');
    final year = parts[2].length == 2 ? '20${parts[2]}' : parts[2];

    return '$day/$month/$year';
  } catch (e) {
    log('⚠️ Tarih dönüşüm hatası: $e - $input');
    return input;
  }
}
