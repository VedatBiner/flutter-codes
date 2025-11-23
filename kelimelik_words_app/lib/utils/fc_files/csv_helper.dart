// 📃 <----- lib/utils/fc_files/csv_helper.dart ----->
//
// Asset CSV → Cihaz CSV senkronizasyonu
// -----------------------------------------------------------
// • Asset içindeki CSV dosyasını, cihazdaki mevcut CSV ile karşılaştırır.
// • Asset 'teki kayıt sayısı daha fazlaysa, cihazdaki dosyayı günceller.
// • Cihazda dosya yoksa, dosyayı oluşturur.
// • SON AŞAMADA: CSV içindeki duplicate "Word" değerleri raporlanır.
//   (Sadece 1. sütun = Word alanına göre kontrol)
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
///
/// Ek olarak:
///  • İşlem süresi loglanır (ms cinsinden).
///  • Son durumda kullanılan CSV dosyası içindeki duplicate "Word" değerleri
///    konsola yazdırılır.
Future<void> createOrUpdateDeviceCsvFromAsset() async {
  const tag = 'csv_helper';
  final sw = Stopwatch()..start();

  try {
    // 1. Asset 'teki CSV dosyasını ve kayıt sayısını al
    const assetCsvPath = 'assets/database/$fileNameCsv';
    final assetCsvRaw = await rootBundle.loadString(assetCsvPath);
    final assetRecordCount = _countCsvLines(assetCsvRaw);

    if (assetRecordCount <= 1) {
      // 1 = sadece başlık satırı olabilir
      log('⚠️ Asset CSV boş veya sadece başlık içeriyor.', name: tag);
      sw.stop();
      log(
        '⏱ CSV helper süresi (erken çıkış): ${sw.elapsedMilliseconds} ms',
        name: tag,
      );
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
        // Asset'teki dosya daha fazla kayıt içeriyor, üzerine yaz
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

    // 4. Son durumda kullanılan CSV dosyası için duplicate Word analizi
    if (await deviceFile.exists()) {
      final finalCsvRaw = await deviceFile.readAsString();
      _reportCsvDuplicateWords(finalCsvRaw);
    }

    sw.stop();
    log('⏱ CSV helper toplam süre: ${sw.elapsedMilliseconds} ms', name: tag);
  } catch (e, st) {
    sw.stop();
    log(
      '❌ CSV oluşturma/güncelleme hatası: $e',
      name: tag,
      error: e,
      stackTrace: st,
    );
  }
}

/// CSV metnindeki geçerli satır sayısını (boş satırları hariç tutarak) sayar.
int _countCsvLines(String rawCsv) {
  if (rawCsv.isEmpty) return 0;
  // Farklı OS'lerden gelen satır sonu karakterlerini standartlaştır.
  final normalized = rawCsv.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  // Boş olmayan satırları say.
  return normalized.split('\n').where((line) => line.trim().isNotEmpty).length;
}

/// CSV içindeki duplicate "Word" değerlerini raporlar.
/// Sadece 1. sütun temel alınır (Word,Meaning yapısında).
void _reportCsvDuplicateWords(String rawCsv) {
  const tag = 'csv_helper_duplicates';

  if (rawCsv.trim().isEmpty) {
    log('ℹ️ CSV boş, duplicate kontrolü yapılmadı.', name: tag);
    return;
  }

  final normalized = rawCsv.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final lines = normalized
      .split('\n')
      .where((l) => l.trim().isNotEmpty)
      .toList();
  if (lines.length <= 1) {
    log('ℹ️ CSV sadece başlık içeriyor, duplicate yok.', name: tag);
    return;
  }

  // 0. satır başlık → dataLines = geri kalan
  final dataLines = lines.sublist(1);

  final Map<String, int> counts = {};
  final Map<String, String> displayWord = {};
  final Map<String, List<int>> lineNumbers = {};

  for (int i = 0; i < dataLines.length; i++) {
    final line = dataLines[i];
    final parts = line.split(',');
    if (parts.isEmpty) continue;

    final word = parts.first.trim();
    if (word.isEmpty) continue;

    final key = word.toLowerCase();
    counts[key] = (counts[key] ?? 0) + 1;
    displayWord.putIfAbsent(key, () => word);
    lineNumbers.putIfAbsent(key, () => []).add(i + 2); // +2 = 1-based + header
  }

  final duplicates = counts.entries.where((e) => e.value > 1).toList();

  if (duplicates.isEmpty) {
    log('✅ CSV içinde duplicate Word yok.', name: tag);
  } else {
    log('🔁 CSV duplicate Word listesi:', name: tag);
    for (final e in duplicates) {
      final w = displayWord[e.key] ?? e.key;
      final lines = lineNumbers[e.key] ?? const [];
      log(
        '   • "$w" → ${e.value} kez (satırlar: ${lines.join(', ')})',
        name: tag,
      );
    }
  }
}
