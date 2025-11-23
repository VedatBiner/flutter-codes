// 📃 <----- lib/utils/file_creator.dart ----->
//
// Veri akışının tamamında:
// • Benchmark raporu
// • SQL’e eklenmeyen kelimelerin listesi
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../db/db_helper.dart';
import 'fc_files/csv_helper.dart';
import 'fc_files/excel_helper.dart';
import 'fc_files/json_helper.dart';
import 'fc_files/sql_helper.dart';

Future<void> initializeAppDataFlow() async {
  const tag = 'file_creator';
  log('🚀 initializeAppDataFlow başladı', name: tag);

  await createOrUpdateDeviceCsvFromAsset();

  final directory = await getApplicationDocumentsDirectory();
  final dbPath = join(directory.path, fileNameSql);
  final dbFile = File(dbPath);

  bool dbExists = await dbFile.exists();
  int recordCount = 0;

  if (dbExists) {
    try {
      recordCount = await DbHelper.instance.countRecords();
    } catch (_) {}
  }

  if (dbExists && recordCount > 0) {
    log('🟢 Veritabanı zaten dolu ($recordCount kayıt).', name: tag);
    await _runConsistencyReport();
    return;
  }

  log('⚠️ Veritabanı boş. Veri oluşturma başlıyor…', name: tag);

  final csvJsonMs = await createJsonFromAssetCsv();
  await createExcelFromAssetCsvSyncfusion();
  final sqlResult = await importJsonToDatabaseFast();

  log("⏱ CSV→JSON: $csvJsonMs ms", name: tag);
  log("⏱ JSON parse: ${sqlResult['parseMs']} ms", name: tag);
  log("⏱ SQL insert: ${sqlResult['sqlMs']} ms", name: tag);
  log(
    "⏱ TOPLAM: ${csvJsonMs + (sqlResult['parseMs'] ?? 0) + (sqlResult['sqlMs'] ?? 0)} ms",
    name: tag,
  );

  await _runConsistencyReport();

  log('✅ initializeAppDataFlow tamamlandı.', name: tag);
}

/// 📊 CSV / JSON / SQL veri tutarlılık raporu
Future<void> _runConsistencyReport() async {
  const tag = 'file_creator';

  final directory = await getApplicationDocumentsDirectory();

  final csvPath = join(directory.path, fileNameCsv);
  final csvRaw = await File(csvPath).readAsString();
  final csvCount = csvRaw.split('\n').length - 1;

  final jsonPath = join(directory.path, fileNameJson);
  final jsonList = jsonDecode(await File(jsonPath).readAsString()) as List;
  final jsonCount = jsonList.length;

  final sqlCount = await DbHelper.instance.countRecords();

  log('-------------------------------------------------', name: tag);
  log('📊 VERİ TUTARLILIK RAPORU', name: tag);
  log('CSV kayıt sayısı : $csvCount', name: tag);
  log('JSON kayıt sayısı: $jsonCount', name: tag);
  log('SQL kayıt sayısı : $sqlCount', name: tag);

  if (csvCount == jsonCount && jsonCount == sqlCount) {
    log('✅ TÜM DOSYALAR UYUMLU ✔', name: tag);
  } else {
    log('❌ TUTARSIZLIK VAR! ✔ Kontrol edilmeli.', name: tag);
    log('ℹ JSON → SQL farkı: ${jsonCount - sqlCount}', name: tag);
  }
  log('-------------------------------------------------', name: tag);
  // --------------------------------------------
  //  JSON → SQL eksik kayıtları bul (detaylı)
  // --------------------------------------------
  if (jsonCount != sqlCount) {
    log("🔎 Eksik SQL kayıtları analiz ediliyor…", name: tag);

    // JSON'daki kelimeler (Word alanı)
    final jsonWords = jsonList
        .map((e) => (e['Word'] ?? e['word'] ?? '').toString().trim())
        .where((e) => e.isNotEmpty)
        .toSet();

    // SQL'den tüm kelimeleri çek
    final sqlWordsList = await DbHelper.instance.getRecords();
    final sqlWords = sqlWordsList
        .map((e) => e.word.trim())
        .where((e) => e.isNotEmpty)
        .toSet();

    // SQL'e girmeyenler = JSON - SQL
    final missing = jsonWords.difference(sqlWords);

    if (missing.isEmpty) {
      log(
        "🟢 SQL eksik kayıt yok (UNIQUE nedeni ile sayı farkı yanılgısı olabilir).",
        name: tag,
      );
    } else {
      log("❌ SQL 'e aktarılmayan ${missing.length} kelime bulundu:", name: tag);
      for (final m in missing.take(50)) {
        log("   • $m", name: tag);
      }

      if (missing.length > 50) {
        log("… ve ${missing.length - 50} kelime daha.", name: tag);
      }
    }
  }
}
