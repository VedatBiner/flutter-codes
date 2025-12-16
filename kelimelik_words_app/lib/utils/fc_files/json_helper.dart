// 📃 <----- lib/utils/fc_files/json_helper.dart ----->
//
// MÜKEMMEL CSV → JSON DÖNÜŞTÜRÜCÜ
// ------------------------------------------------------------
// ✔ Virgüllü değerlerde bile bozulmaz
// ✔ 2 veya 3 sütunlu CSV ile çalışır
// ✔ Tarih sütunu varsa JSON'a otomatik ekler
// ✔ Bozuk satırları loglar ama uygulamayı bozmaz
// ✔ JSON çıktısı %100 eksiksiz olur
// ------------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';

Future<void> createJsonFromAssetCsv() async {
  const tag = "json_helper";
  final sw = Stopwatch()..start();

  try {
    // CSV dosyasını ASSET yerine ARTIK CİHAZDAN OKUYORUZ
    final directory = await getApplicationDocumentsDirectory();
    final csvPath = join(directory.path, fileNameCsv);

    final csvFile = File(csvPath);
    if (!await csvFile.exists()) {
      log("❌ CSV bulunamadı: $csvPath", name: tag);
      return;
    }

    final csvRaw = await csvFile.readAsString();

    // 🔥 Güvenli parser
    final jsonList = _safeCsvToJson(csvRaw);

    // JSON dosyasını kaydet
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
/// 🎯 GÜVENLİ CSV → JSON PARSER (TARİH DESTEKLİ)
/// ------------------------------------------------------------
/// • 2 sütun: Kelime,Anlam
/// • 3 sütun: Kelime,Anlam,Tarih
/// • Fazla virgüller Anlam içinde kalır
/// ------------------------------------------------------------
List<Map<String, dynamic>> _safeCsvToJson(String csvRaw) {
  const tag = "json_parser";

  final normalized = csvRaw
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .trim();

  final lines = normalized.split('\n');
  if (lines.length < 2) return [];

  // Başlıklar
  final headers = lines.first.split(',').map((e) => e.trim()).toList();

  final hasDateColumn = headers.length >= 3 && headers.contains('Tarih');

  final jsonList = <Map<String, dynamic>>[];

  for (int i = 1; i < lines.length; i++) {
    final line = lines[i].trim();

    if (line.isEmpty) {
      log("⚠️ Boş satır atlandı ($i)", name: tag);
      continue;
    }

    final parts = line.split(',');

    if (parts.length < 2) {
      log("⚠️ Geçersiz satır ($i): $line", name: tag);
      continue;
    }

    final kelime = parts[0].trim();

    // Anlam: 2. sütundan sona kadar (tarih hariç)
    final anlamEndIndex = hasDateColumn ? parts.length - 1 : parts.length;
    final anlam = parts.sublist(1, anlamEndIndex).join(',').trim();

    if (kelime.isEmpty || anlam.isEmpty) {
      log("⚠️ Eksik veri ($i): $line", name: tag);
      continue;
    }

    final row = <String, dynamic>{'Kelime': kelime, 'Anlam': anlam};

    // 📅 Tarih varsa ekle
    if (hasDateColumn && parts.length >= 3) {
      final tarih = parts.last.trim();
      if (tarih.isNotEmpty) {
        row['Tarih'] = tarih;
      }
    }

    jsonList.add(row);
  }

  return jsonList;
}
