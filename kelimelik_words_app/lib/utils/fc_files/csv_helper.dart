// 📃 <----- lib/utils/fc_files/csv_helper.dart ----->
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

    // Toplam satır sayısı (başlık dahil, boş satırlar hariç)
    final assetTotalLines = countCsvLines(assetCsvRaw);
    // Gerçek kayıt sayısı = satır sayısı - 1 (başlık)
    final assetRecordCount = assetTotalLines > 0 ? assetTotalLines - 1 : 0;

    if (assetRecordCount <= 0) {
      // 0 = sadece başlık veya tamamen boş olabilir
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
      final deviceTotalLines = countCsvLines(deviceCsvRaw);
      final deviceRecordCount = deviceTotalLines > 0 ? deviceTotalLines - 1 : 0;

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
  } catch (e, st) {
    log(
      '❌ CSV oluşturma/güncelleme hatası: $e',
      name: 'csv_helper',
      error: e,
      stackTrace: st,
    );
  }
}

/// CSV metnindeki **satır sayısını** (boş satırları hariç tutarak) sayar.
/// - Dönen değer **başlık satırı dahil** satır sayısıdır.
/// - Gerçek kayıt sayısı için genelde `countCsvLines(...) - 1` kullanılır.
int countCsvLines(String rawCsv) {
  if (rawCsv.isEmpty) return 0;
  // Farklı OS'lerden gelen satır sonu karakterlerini standartlaştır.
  final normalized = rawCsv.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  // Boş olmayan satırları say.
  return normalized.split('\n').where((line) => line.trim().isNotEmpty).length;
}
