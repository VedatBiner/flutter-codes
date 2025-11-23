// 📃 <----- lib/utils/fc_files/csv_helper.dart ----->
//
// CSV → Cihaz CSV Güncelleme
// -----------------------------------------------------------
// • Asset CSV ile cihaz CSV karşılaştırılır.
// • Duplicate kelimeler (Word sütunu) tespit edilir ve loglanır.
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';

/// Asset içindeki CSV dosyasını, cihazdaki mevcut CSV ile karşılaştırır.
/// Asset 'teki kayıt sayısı daha fazlaysa, cihazdaki dosyayı günceller.
/// Cihazda dosya yoksa, dosyayı oluşturur.
Future<void> createOrUpdateDeviceCsvFromAsset() async {
  const tag = 'csv_helper';
  try {
    // 1. Asset 'teki CSV dosyasını ve kayıt sayısını al
    const assetCsvPath = 'assets/database/$fileNameCsv';
    final assetCsvRaw = await rootBundle.loadString(assetCsvPath);

    // 🔍 Duplicate kontrolü
    _logCsvDuplicates(assetCsvRaw);

    final assetRecordCount = _countCsvLines(assetCsvRaw);

    if (assetRecordCount <= 1) {
      // 1 = sadece başlık satırı olabilir
      log('⚠️ Asset CSV boş veya sadece başlık içeriyor.', name: tag);
      return;
    }

    // 2. Cihazdaki CSV dosyasının yolunu al
    final directory = await getApplicationDocumentsDirectory();
    final outPath = join(directory.path, fileNameCsv);
    final deviceFile = File(outPath);

    // 3. Karşılaştır ve işlem yap
    if (await deviceFile.exists()) {
      // Cihazda dosya var, kayıt sayılarını karşılaştır
      final deviceCsvRaw = await deviceFile.readAsString();
      final deviceRecordCount = _countCsvLines(deviceCsvRaw);

      if (assetRecordCount > deviceRecordCount) {
        // Asset 'teki dosya daha fazla kayıt içeriyor, üzerine yaz
        await deviceFile.writeAsString(assetCsvRaw);
        log(
          '✅ CSV güncellendi (Asset > Cihaz). Kayıt sayısı: $assetRecordCount (Eski: $deviceRecordCount)',
          name: tag,
        );
      } else {
        // Cihazdaki dosya aynı veya daha fazla kayıt içeriyor, işlem yapma
        log(
          'ℹ️ Cihazdaki CSV aynı veya daha yeni. İşlem yapılmadı. (Asset: $assetRecordCount, Cihaz: $deviceRecordCount)',
          name: tag,
        );
      }
    } else {
      // Cihazda dosya yok, doğrudan oluştur
      await deviceFile.writeAsString(assetCsvRaw);
      log('✅ CSV oluşturuldu. Kayıt sayısı: $assetRecordCount', name: tag);
    }
  } catch (e, st) {
    log(
      '❌ CSV oluşturma/güncelleme hatası: $e',
      name: 'csv_helper',
      error: e,
      stackTrace: st,
    );
  }
}

/// 🔎 CSV içindeki duplicate Word kayıtlarını tespit et ve logla.
void _logCsvDuplicates(String csvRaw) {
  const tag = 'csv_helper_duplicates';

  final lines = csvRaw.split('\n').where((e) => e.trim().isNotEmpty).toList();
  if (lines.length <= 1) return;

  final Map<String, int> counter = {};

  for (int i = 1; i < lines.length; i++) {
    final columns = lines[i].split(',');
    if (columns.isEmpty) continue;

    final word = columns.first.trim();
    if (word.isEmpty) continue;

    counter[word] = (counter[word] ?? 0) + 1;
  }

  final duplicates = counter.entries.where((e) => e.value > 1).toList();

  if (duplicates.isNotEmpty) {
    log('🔁 CSV DUPLICATE LISTESİ', name: tag);
    for (final d in duplicates) {
      log('• ${d.key}  →  ${d.value} kez', name: tag);
    }
  }
}

int _countCsvLines(String rawCsv) {
  if (rawCsv.isEmpty) return 0;
  final normalized = rawCsv.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  return normalized.split('\n').where((line) => line.trim().isNotEmpty).length;
}
