// 📃 <----- lib/utils/fc_files/json_helper.dart ----->
//
// 🧩 JSON Helper – Asset içindeki CSV 'den JSON dosyası üretici
//
// Amaç:
// -----------------------------------------------------------
//  • Uygulama asset klasöründeki CSV dosyasını okur.
//  • Tarih formatını ABD formatından (MM/DD/YY) Avrupa formatına (DD/MM/YY) çevirir.
//  • Her satırı bir JSON objesi haline getirir.
//  • Sonuçları cihazın "application documents" dizininde
//    [fileNameJson] adında bir dosyaya yazar.
//
// Kullanım:
// -----------------------------------------------------------
// import 'fc_files/json_helper.dart';
//
// await createJsonFromAssetCsv();
//
// Eğer dosya zaten mevcutsa tekrar oluşturmaz, sadece log ’a yazar.
//
// Gereken diğer dosyalar:
//  • constants/file_info.dart
//  • fc_files/date_formatter.dart (tarih dönüştürme için)
//
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';
import 'date_formatter.dart';

/// 📦 Asset CSV → JSON dönüştürme fonksiyonu.
///
/// - Tarihler "aa/gg/yy" → "gg/aa/yy" şeklinde düzeltilir.
/// - Dosya zaten varsa yeniden oluşturulmaz.
/// - Oluşturulan JSON dosyası cihazın belgeler dizinine kaydedilir.
///
/// Örnek çıktı konumu:
///   /data/user/0/<package>/app_flutter/netflix_list_backup.json
Future<void> createJsonFromAssetCsv() async {
  const tag = 'json_helper';

  try {
    // 1️⃣ Asset CSV dosyasının yolu
    const assetCsvPath = 'assets/database/$assetsFileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    // 2️⃣ CSV verisini ayrıştır
    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvRaw);

    if (rows.isEmpty) {
      log('⚠️ Asset CSV boş!', name: tag);
      return;
    }

    // 3️⃣ Başlık satırını ve tarih sütununu bul
    final headers = rows.first.map((e) => e.toString().trim()).toList();
    final dateIdx = headers.indexWhere(
      (h) => h.toLowerCase() == 'date' || h.toLowerCase() == 'watched date',
    );

    // 4️⃣ JSON listesi oluştur
    final List<Map<String, dynamic>> jsonList = [];
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length != headers.length) continue;

      final record = <String, dynamic>{};
      for (int j = 0; j < headers.length; j++) {
        var value = row[j].toString().trim();
        if (j == dateIdx) value = formatUsToEuDate(value);
        record[headers[j]] = value;
      }
      jsonList.add(record);
    }

    // 5️⃣ JSON string üret (güzel biçimli)
    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);

    // 6️⃣ Dosyaya kaydet (mevcutsa atla)
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);
    final file = File(jsonPath);

    if (!await file.exists()) {
      await file.writeAsString(jsonStr);
      log('✅ JSON dosyası oluşturuldu: $jsonPath', name: tag);
      log('📦 Kayıt sayısı: ${jsonList.length}', name: tag);
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
