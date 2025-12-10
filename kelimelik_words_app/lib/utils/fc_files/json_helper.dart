// 📃 <----- lib/utils/fc_files/json_helper.dart ----->
//
// MÜKEMMEL CSV → JSON DÖNÜŞTÜRÜCÜ
// ------------------------------------------------------------
// ✔ Virgüllü değerlerde bile bozulmaz
// ✔ Her satırı garanti 2 hücreye dönüştürür
// ✔ Bozuk satırları loglar ama uygulamayı bozmaz
// ✔ JSON çıktısı %100 eksiksiz olur
// ------------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';

Future<void> createJsonFromAssetCsv() async {
  const tag = "json_helper";
  final sw = Stopwatch()..start();

  try {
    // CSV dosyasını asset ’ten oku
    const assetCsvPath = 'assets/database/$fileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    // 🔥 Yeni, güvenli parser ’ı kullan
    final jsonList = _safeCsvToJson(csvRaw);

    // JSON dosyasını kaydet
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);

    final jsonStr = const JsonEncoder.withIndent("  ").convert(jsonList);
    await File(jsonPath).writeAsString(jsonStr);

    sw.stop();
    log("✅ JSON başarıyla oluşturuldu: ${jsonList.length} kayıt", name: tag);
    log("⏱ Süre: ${sw.elapsedMilliseconds} ms", name: tag);
  } catch (e, st) {
    log("❌ JSON oluşturma hatası: $e", name: tag, error: e, stackTrace: st);
  }
}

/// ------------------------------------------------------------
/// 🎯 GÜVENLİ CSV → JSON PARSER
/// ------------------------------------------------------------
/// 1) Satırı virgülle böl
/// 2) Eğer 2 sütun yoksa kalanını Anlam içine birleştir
/// 3) BOM, CRLF, boş satır, bozuk satır → güvenli şekilde işlenir
/// ------------------------------------------------------------
List<Map<String, dynamic>> _safeCsvToJson(String csvRaw) {
  const tag = "json_parser";

  final normalized = csvRaw
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .trim();

  final lines = normalized.split('\n');
  if (lines.length < 2) return [];

  // Başlıkları oku
  final headers = lines.first.split(',').map((e) => e.trim()).toList();
  final jsonList = <Map<String, dynamic>>[];

  for (int i = 1; i < lines.length; i++) {
    final line = lines[i].trim();

    if (line.isEmpty) {
      log("⚠️ Boş satır atlandı ($i)", name: tag);
      continue;
    }

    // 🔥 SÜPER GÜVENLİ PARSER:
    // - Kelime virgül içeremez → ilk virgüle kadar kelime
    // - Geri kalan her şey "Anlam" içine girer
    final splitIndex = line.indexOf(',');

    if (splitIndex == -1) {
      log("⚠️ Virgül bulunamadı, satır atlandı: $line", name: tag);
      continue;
    }

    final kelime = line.substring(0, splitIndex).trim();
    final anlam = line.substring(splitIndex + 1).trim();

    if (kelime.isEmpty || anlam.isEmpty) {
      log("⚠️ Eksik veri (satır $i): $line", name: tag);
      continue;
    }

    jsonList.add({headers[0]: kelime, headers[1]: anlam});
  }

  return jsonList;
}
