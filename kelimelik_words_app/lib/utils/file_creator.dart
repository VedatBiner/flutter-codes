// 📃 <----- lib/utils/file_creator.dart ----->
//
// Veri akışının tamamında tutarlılık raporu eklendi.
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

  // 1️⃣ CSV: Asset → cihaz (gerekirse güncelle)
  await createOrUpdateDeviceCsvFromAsset();

  // 2️⃣ Veritabanı durumu
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

  // 3️⃣ JSON / Excel / SQL üretim zinciri
  await createJsonFromAssetCsv();
  await createExcelFromAssetCsvSyncfusion();
  await importJsonToDatabaseFast();

  // 4️⃣ Tutarlılık raporu
  await _runConsistencyReport();

  log('✅ initializeAppDataFlow tamamlandı.', name: tag);
}

/// 📊 CSV / JSON / SQL veri tutarlılık raporu (orta seviye)
Future<void> _runConsistencyReport() async {
  const tag = 'file_creator';

  final directory = await getApplicationDocumentsDirectory();

  // CSV → satır sayısı & kayıt sayısı
  final csvPath = join(directory.path, fileNameCsv);
  final csvRaw = await File(csvPath).readAsString();
  final csvTotalLines = countCsvLines(csvRaw); // başlık + veri satırları
  final csvCount = csvTotalLines > 0 ? csvTotalLines - 1 : 0;

  // JSON → kayıt sayısı
  final jsonPath = join(directory.path, fileNameJson);
  final jsonRaw = await File(jsonPath).readAsString();
  final jsonList = jsonDecode(jsonRaw) as List;
  final jsonCount = jsonList.length;

  // SQL → kayıt sayısı
  final sqlCount = await DbHelper.instance.countRecords();

  log('-------------------------------------------------', name: tag);
  log('📊 VERİ TUTARLILIK RAPORU', name: tag);
  log('CSV kayıt sayısı : $csvCount', name: tag);
  log('JSON kayıt sayısı: $jsonCount', name: tag);
  log('SQL kayıt sayısı : $sqlCount', name: tag);

  // 🔍 Orta seviye fark analizleri
  final diffCsvJson = csvCount - jsonCount;
  final diffJsonSql = jsonCount - sqlCount;

  if (diffCsvJson == 0 && diffJsonSql == 0) {
    log('✅ TÜM DOSYALAR UYUMLU ✔', name: tag);
  } else {
    log('❌ TUTARSIZLIK VAR! ✔ Kontrol edilmesi gerekiyor.', name: tag);

    if (diffCsvJson != 0) {
      if (diffCsvJson > 0) {
        log(
          '⚠️ CSV → JSON farkı: ${diffCsvJson.abs()} kayıt (JSON tarafında eksik).',
          name: tag,
        );
      } else {
        log(
          '⚠️ CSV → JSON farkı: ${diffCsvJson.abs()} kayıt (CSV tarafında eksik).',
          name: tag,
        );
      }
    }

    if (diffJsonSql != 0) {
      if (diffJsonSql > 0) {
        log(
          '⚠️ JSON → SQL farkı: ${diffJsonSql.abs()} kayıt (SQL tarafında eksik).',
          name: tag,
        );
        log(
          'ℹ️ Not: SQL sayısı JSON\'dan azsa, genellikle veritabanındaki UNIQUE kısıtı nedeniyle\n'
          '   yinelenen kelimelerin eklenmemesinden kaynaklanır.',
          name: tag,
        );
      } else {
        log(
          '⚠️ JSON → SQL farkı: ${diffJsonSql.abs()} kayıt (JSON tarafında eksik).',
          name: tag,
        );
      }
    }
  }

  log('-------------------------------------------------', name: tag);
}
