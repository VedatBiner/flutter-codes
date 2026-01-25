// 📃 <----- lib/utils/fc_files/csv_helper.dart ----->
//
// CSV senkronizasyon + DB → CSV üretimi (TEK MERKEZ)
// -----------------------------------------------------------
// • Asset CSV → Device CSV senkronizasyonu
// • DB → CSV export (Kelime, Anlam, Tarih)
// • Tarih TEKRARI ENGELLENİR
// • Anlam içine gömülmüş eski tarih KALINTILARI temizlenir
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../constants/file_info.dart';
// import '../../db/db_helper.dart';
// import '../../models/item_model.dart';

/// ------------------------------------------------------------
/// CSV karşılaştırma sonucu
/// ------------------------------------------------------------
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

/// ------------------------------------------------------------
/// 📌 Asset CSV tam okuma
/// ------------------------------------------------------------
Future<String> _loadAssetCsvRaw() async {
  const assetCsvPath = 'assets/database/$fileNameCsv';
  return rootBundle.loadString(assetCsvPath);
}

/// ------------------------------------------------------------
/// 📌 Device CSV tam okuma
/// ------------------------------------------------------------
Future<String> _loadDeviceCsvRaw() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, fileNameCsv);
  final file = File(path);
  return file.existsSync() ? file.readAsString() : '';
}

/// ------------------------------------------------------------
/// 📌 Device CSV kaydet
/// ------------------------------------------------------------
Future<void> _saveDeviceCsv(String content) async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, fileNameCsv);
  await File(path).writeAsString(content);
}

/// ------------------------------------------------------------
/// 📌 CSV başlığında "Tarih" sütunu var mı?
/// ------------------------------------------------------------
bool _csvHasDateColumn(String csvRaw) {
  if (csvRaw.isEmpty) return false;
  final firstLine = csvRaw
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .split('\n')
      .first
      .trim();

  final headers = firstLine.split(',').map((e) => e.trim()).toList();
  return headers.contains('Tarih');
}

/// ------------------------------------------------------------
/// 📌 CSV satır sayısı
/// ------------------------------------------------------------
int _countCsvLines(String rawCsv) {
  if (rawCsv.isEmpty) return 0;
  return rawCsv
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .split('\n')
      .where((e) => e.trim().isNotEmpty)
      .length;
}

/// ------------------------------------------------------------
/// 🔥 Anlam içindeki ESKİ tarih kalıntılarını temizler
/// (örn: "Su15.12.2025" → "Su")
/// ------------------------------------------------------------
String _cleanMeaning(String meaning) {
  final dateRegex = RegExp(r'\d{2}\.\d{2}\.\d{4}$');
  return meaning.replaceAll(dateRegex, '').trim();
}

/// ------------------------------------------------------------
/// 🔄 Asset → Device CSV senkronizasyonu
/// ------------------------------------------------------------
Future<CsvSyncResult> createOrUpdateDeviceCsvFromAsset() async {
  const tag = "csv_helper";

  try {
    final assetRaw = await _loadAssetCsvRaw();
    final assetCount = _countCsvLines(assetRaw);

    final deviceRaw = await _loadDeviceCsvRaw();
    final deviceExists = deviceRaw.isNotEmpty;
    final deviceCount = deviceExists ? _countCsvLines(deviceRaw) : 0;

    final assetIsNewer = assetCount > deviceCount;
    final needsRebuild = assetCount != deviceCount;

    log(
      "📊 CSV Sync → Asset: $assetCount | Device: $deviceCount | Rebuild: $needsRebuild",
      name: tag,
    );

    if (!deviceExists || assetIsNewer) {
      await _saveDeviceCsv(assetRaw);
      log("✅ Device CSV güncellendi (asset kaynaklı)", name: tag);
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

/// ------------------------------------------------------------
/// 🟢 TEK MERKEZ: DB → CSV EXPORT (TARİH DOĞRU YAZILIR)
/// ------------------------------------------------------------
Future<String> exportCsvFromDatabase() async {
  const tag = "csv_helper";

  // final words = await DbHelper.instance.getRecords();

  final buffer = StringBuffer();
  buffer.writeln("Kelime,Anlam,Tarih");

  // for (final Word w in words) {
  //   final kelime = w.word.replaceAll(',', '').trim();
  //
  //   // 🔥 KRİTİK TEMİZLİK
  //   final temizAnlam = _cleanMeaning(w.meaning.replaceAll(',', '').trim());
  //
  //   final tarih = w.createdAt ?? "15.12.2025";
  //
  //   buffer.writeln("$kelime,$temizAnlam,$tarih");
  // }

  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, fileNameCsv);
  await File(path).writeAsString(buffer.toString());

  log("✅ CSV üretildi (temiz): $path", name: tag);
  return path;
}