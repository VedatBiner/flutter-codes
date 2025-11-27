// 📃 <----- lib/utils/fc_files/csv_helper.dart ----->
//
// CSV senkronizasyon ve asset → cihaz kopyalama işlemleri
// -----------------------------------------------------------
// • CsvSyncResult: asset / device CSV karşılaştırma sonuçları
// • createOrUpdateDeviceCsvFromAsset():
//     - Asset ve cihaz CSV 'yi okur
//     - Kayıt sayılarını karşılaştırır
//     - Asset daha yeni ise cihaz CSV 'yi günceller
//     - needsRebuild = assetCount != deviceCount
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';

/// CSV karşılaştırma sonucu veri sınıfı
class CsvSyncResult {
  final bool deviceExists;
  final bool assetIsNewer;
  final bool needsRebuild;
  final int assetCount;
  final int deviceCount;

  CsvSyncResult({
    required this.deviceExists,
    required this.assetIsNewer,
    required this.needsRebuild,
    required this.assetCount,
    required this.deviceCount,
  });
}

/// Asset CSV tam metin okuma
Future<String> _loadAssetCsvRaw() async {
  const assetCsvPath = 'assets/database/$fileNameCsv';
  return rootBundle.loadString(assetCsvPath);
}

/// Cihaz CSV tam okuma
Future<String> _loadDeviceCsvRaw() async {
  final directory = await getApplicationDocumentsDirectory();
  final devicePath = join(directory.path, fileNameCsv);
  final file = File(devicePath);
  return file.existsSync() ? file.readAsString() : '';
}

/// Cihaz CSV kaydetme
Future<void> _saveDeviceCsv(String content) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, fileNameCsv);
  await File(path).writeAsString(content);
}

/// CSV senkronizasyonu (DETAYLI RAPOR + Rebuild kararı)
Future<CsvSyncResult> createOrUpdateDeviceCsvFromAsset() async {
  const tag = "csv_helper";

  try {
    // 🟦 Asset CSV
    final assetRaw = await _loadAssetCsvRaw();
    final assetCount = _countCsvLines(assetRaw);

    if (assetCount <= 1) {
      log("⚠ Asset CSV boş veya sadece başlık içeriyor.", name: tag);
      return CsvSyncResult(
        deviceExists: false,
        assetIsNewer: false,
        needsRebuild: false,
        assetCount: assetCount,
        deviceCount: 0,
      );
    }

    // 🟧 Device CSV
    final deviceRaw = await _loadDeviceCsvRaw();
    final deviceExists = deviceRaw.isNotEmpty;
    final deviceCount = deviceExists ? _countCsvLines(deviceRaw) : 0;

    // 🟨 Kararlar
    final assetIsNewer = assetCount > deviceCount;
    final needsRebuild = assetCount != deviceCount;

    log(
      "📊 CSV Sync → Asset: $assetCount | Device: $deviceCount | Newer: $assetIsNewer | Rebuild: $needsRebuild",
      name: tag,
    );

    // Cihaz CSV güncellemesi
    if (!deviceExists || assetIsNewer) {
      await _saveDeviceCsv(assetRaw);
      log(
        deviceExists
            ? "✅ CSV güncellendi → Asset > Device"
            : "📁 CSV ilk kez oluşturuldu",
        name: tag,
      );
    }

    return CsvSyncResult(
      deviceExists: deviceExists,
      assetIsNewer: assetIsNewer,
      needsRebuild: needsRebuild,
      assetCount: assetCount,
      deviceCount: deviceCount,
    );
  } catch (e, st) {
    log("❌ CSV sync hatası: $e", name: tag, error: e, stackTrace: st);
    return CsvSyncResult(
      deviceExists: false,
      assetIsNewer: false,
      needsRebuild: false,
      assetCount: 0,
      deviceCount: 0,
    );
  }
}

/// CSV satır sayısı (boşlar hariç)
int _countCsvLines(String rawCsv) {
  if (rawCsv.isEmpty) return 0;
  final normalized = rawCsv.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  return normalized.split("\n").where((e) => e.trim().isNotEmpty).length;
}
