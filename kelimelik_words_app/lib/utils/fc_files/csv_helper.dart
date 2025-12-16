// 📃 <----- lib/utils/fc_files/csv_helper.dart ----->
//
// CSV senkronizasyon + CSV üretimi (TEK MERKEZ)
// -----------------------------------------------------------
// • Asset CSV → Device CSV senkronizasyonu
// • DB → CSV üretimi
// • Tarih sütunu TEK YERDEN kontrol edilir
// • Asset CSV'de "Tarih" varsa ASLA tekrar eklenmez
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';
import '../../db/db_helper.dart';

const tag = "csv_helper";

/// ---------------------------------------------------------------------------
/// CSV karşılaştırma sonucu
/// ---------------------------------------------------------------------------
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

/// ---------------------------------------------------------------------------
/// Asset CSV oku
/// ---------------------------------------------------------------------------
Future<String> _loadAssetCsvRaw() async {
  const assetCsvPath = 'assets/database/$fileNameCsv';
  return rootBundle.loadString(assetCsvPath);
}

/// ---------------------------------------------------------------------------
/// Device CSV oku
/// ---------------------------------------------------------------------------
Future<String> _loadDeviceCsvRaw() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, fileNameCsv);
  final file = File(path);
  return file.existsSync() ? file.readAsString() : '';
}

/// ---------------------------------------------------------------------------
/// Device CSV yaz
/// ---------------------------------------------------------------------------
Future<void> _saveDeviceCsv(String content) async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, fileNameCsv);
  await File(path).writeAsString(content);
}

/// ---------------------------------------------------------------------------
/// CSV başlığında "Tarih" var mı?
/// ---------------------------------------------------------------------------
bool _csvHasDateColumn(String csvRaw) {
  if (csvRaw.isEmpty) return false;
  final firstLine = csvRaw.split('\n').first.trim();
  if (firstLine.isEmpty) return false;

  final headers = firstLine.split(',').map((e) => e.trim()).toList();
  return headers.contains('Tarih');
}

/// ---------------------------------------------------------------------------
/// CSV satır sayısı
/// ---------------------------------------------------------------------------
int _countCsvLines(String rawCsv) {
  if (rawCsv.isEmpty) return 0;
  return rawCsv
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .split('\n')
      .where((e) => e.trim().isNotEmpty)
      .length;
}

/// ---------------------------------------------------------------------------
/// 🔄 Asset → Device CSV senkronizasyonu
/// ---------------------------------------------------------------------------
Future<CsvSyncResult> createOrUpdateDeviceCsvFromAsset() async {
  try {
    final assetRaw = await _loadAssetCsvRaw();
    final assetCount = _countCsvLines(assetRaw);

    if (assetCount <= 1) {
      log("⚠ Asset CSV boş.", name: tag);
      return CsvSyncResult(
        deviceExists: false,
        assetIsNewer: false,
        needsRebuild: false,
        assetCount: assetCount,
        deviceCount: 0,
      );
    }

    final deviceRaw = await _loadDeviceCsvRaw();
    final deviceExists = deviceRaw.isNotEmpty;
    final deviceCount = deviceExists ? _countCsvLines(deviceRaw) : 0;

    final assetIsNewer = assetCount > deviceCount;
    final needsRebuild = assetCount != deviceCount;

    if (!deviceExists || assetIsNewer) {
      await _saveDeviceCsv(assetRaw);
      log("✅ Device CSV asset 'ten güncellendi", name: tag);
    }

    return CsvSyncResult(
      deviceExists: deviceExists,
      assetIsNewer: assetIsNewer,
      needsRebuild: needsRebuild,
      assetCount: assetCount,
      deviceCount: deviceCount,
    );
  } catch (e, st) {
    log("❌ CSV sync hatası: $e", name: tag, stackTrace: st);
    return CsvSyncResult(
      deviceExists: false,
      assetIsNewer: false,
      needsRebuild: false,
      assetCount: 0,
      deviceCount: 0,
    );
  }
}

/// ---------------------------------------------------------------------------
/// 🧾 DB → CSV ÜRETİMİ (TEK YER)
// ---------------------------------------------------------------------------
/// • Tarih DB 'den okunur (created_at)
/// • Header zaten "Tarih" içerir
/// • Asla ekstra sütun eklenmez
Future<String> exportCsvFromDatabase() async {
  const fixedDate = "14.12.2025";

  final words = await DbHelper.instance.getRecords();
  final buffer = StringBuffer();

  buffer.writeln("Kelime,Anlam,Tarih");

  for (final w in words) {
    final kelime = w.word.replaceAll(",", "");
    final anlam = w.meaning.replaceAll(",", "");
    final tarih = (w.createdAt?.isNotEmpty ?? false) ? w.createdAt! : fixedDate;

    buffer.writeln("$kelime,$anlam,$tarih");
  }

  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, fileNameCsv);

  await File(path).writeAsString(buffer.toString());

  log("📄 CSV üretildi: $path (${words.length} kayıt)", name: tag);

  return path;
}
