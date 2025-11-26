// 📃 <----- lib/utils/fc_files/csv_helper.dart ----->
//
// CSV senkronizasyon ve asset → cihaz kopyalama işlemleri
// -----------------------------------------------------------
// Yeni Özellikler:
// • Asset CSV cihaz CSV’den daha yeni mi? (checkCsvSyncStatus)
// • Asset daha yeniyse REBUILD kararı file_creator.dart tarafından alınır
// • createOrUpdateDeviceCsvFromAsset artık rebuild kontrol sonucu döndürür
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

/// Asset CSV cihaz CSV ’den yeni mi?
/// Rebuild kararını üretir.
Future<CsvSyncResult> checkCsvSyncStatus() async {
  const tag = 'csv_helper';

  const assetCsvPath = 'assets/database/$fileNameCsv';
  final assetCsvRaw = await rootBundle.loadString(assetCsvPath);
  final assetCount = _countCsvLines(assetCsvRaw);

  final directory = await getApplicationDocumentsDirectory();
  final devicePath = join(directory.path, fileNameCsv);
  final deviceFile = File(devicePath);

  if (!await deviceFile.exists()) {
    log(
      '📊 CSV Sync: Cihaz CSV yok → Asset daha yeni (ilk kurulum)',
      name: tag,
    );

    return CsvSyncResult(
      deviceExists: false,
      assetIsNewer: true,
      needsRebuild: true,
      assetCount: assetCount,
      deviceCount: 0,
    );
  }

  final deviceRaw = await deviceFile.readAsString();
  final deviceCount = _countCsvLines(deviceRaw);

  final assetNewer = assetCount > deviceCount;
  final rebuild = assetCount != deviceCount;

  log(
    '📊 CSV Sync – Asset: $assetCount, Device: $deviceCount, Asset > Device = $assetNewer',
    name: tag,
  );

  return CsvSyncResult(
    deviceExists: true,
    assetIsNewer: assetNewer,
    needsRebuild: rebuild,
    assetCount: assetCount,
    deviceCount: deviceCount,
  );
}

/// Asset içindeki CSV cihazdaki CSV 'den daha yeniyse cihaz dosyasını günceller.
/// Return → REBUILD kararı + CSV durum bilgileri
Future<CsvSyncResult> createOrUpdateDeviceCsvFromAsset() async {
  const tag = 'csv_helper';

  final assetCsv = await loadAssetCsv();
  final deviceCsv = await loadDeviceCsv();

  final assetCount = assetCsv.length;
  final deviceCount = deviceCsv.length;

  final assetIsNewer = assetCount > deviceCount;
  final rebuildNeeded = assetCount != deviceCount;

  if (assetIsNewer) {
    await saveDeviceCsv(assetCsv);
    log('📁 CSV güncellendi. Yeni kayıt sayısı: $assetCount', name: tag);
  }

  return CsvSyncResult(
    deviceExists: true,
    assetIsNewer: assetIsNewer,
    needsRebuild: rebuildNeeded,
    assetCount: assetCount,
    deviceCount: deviceCount,
  );
}

/// CSV satır sayısı (boş satırlar hariç)
int _countCsvLines(String rawCsv) {
  if (rawCsv.isEmpty) return 0;

  final normalized = rawCsv.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  return normalized.split('\n').where((line) => line.trim().isNotEmpty).length;
}

/// Asset CSV oku
Future<List<String>> loadAssetCsv() async {
  const path = 'assets/database/$fileNameCsv';
  final raw = await rootBundle.loadString(path);

  final normalized = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  return normalized.split('\n').where((l) => l.trim().isNotEmpty).toList();
}

/// Device CSV oku
Future<List<String>> loadDeviceCsv() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, fileNameCsv);
  final file = File(path);

  if (!await file.exists()) return [];

  final raw = await file.readAsString();
  final normalized = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  return normalized.split('\n').where((l) => l.trim().isNotEmpty).toList();
}

/// Device CSV kaydet
Future<void> saveDeviceCsv(List<String> lines) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, fileNameCsv));
  await file.writeAsString(lines.join('\n'));
}
