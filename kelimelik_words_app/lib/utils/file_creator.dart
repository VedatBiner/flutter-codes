// 📃 <----- lib/utils/file_creator.dart ----->
//
// Veri akışının tamamında tutarlılık raporu, rebuild sistemi ve ZIP oluşturma içerir.
// -----------------------------------------------------------
// Akış:
//   1️⃣ CSV (asset) → Cihaz CSV (createOrUpdateDeviceCsvFromAsset)
//   2️⃣ CSV → JSON (createJsonFromAssetCsv)
//   3️⃣ CSV → Excel (createExcelFromAssetCsvSyncfusion)
//   4️⃣ JSON → SQL (importJsonToDatabaseFast)
//
// Bu dosya:
//   • Asset CSV cihaz CSV’den daha yeniyse TAM REBUILD çalıştırır.
//   • REBUILD sırasında DB bağlantısı kapatılır, DB tamamen silinir.
//   • CSV / JSON / SQL kayıt sayılarını karşılaştırır.
//   • CSV → JSON eksik kelimeleri raporlar.
//   • CSV & JSON duplicate Word tespiti yapar.
//   • JSON’da olup SQL’e girmeyen kayıtları listeler.
//   • ZIP dosyası her koşulda oluşturulur.
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:kelimelik_words_app/utils/zip_helper.dart';
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
  final totalSw = Stopwatch()..start();

  log('🚀 initializeAppDataFlow başladı', name: tag);

  // 1️⃣ CSV senkronizasyonu (Asset → Device)
  final csvSync = await createOrUpdateDeviceCsvFromAsset();

  // 📂 Dizin ve DB yolu
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

  // --------------------------------------------------------------
  // 🛠  Eğer Asset CSV → Device CSV daha yeniyse → TAM REBUILD
  // --------------------------------------------------------------
  if (csvSync.needsRebuild) {
    log(
      '⚠️ REBUILD gerekli bulundu → TAM YENİDEN KURULUM başlıyor...',
      name: tag,
    );

    // 1) Mevcut DB bağlantısını kapat
    log('🔄 DB bağlantısı kapatılıyor...', name: tag);
    await DbHelper.instance.closeDb();

    // 2) DB dosyasını sil
    if (await dbFile.exists()) {
      await dbFile.delete();
      log('🗑 DB silindi: $dbPath', name: tag);
    }

    // 3) JSON, CSV, Excel dosyalarını sil
    final filesToDelete = [
      join(directory.path, fileNameJson),
      join(directory.path, fileNameCsv),
      join(directory.path, fileNameXlsx),
    ];

    for (final path in filesToDelete) {
      final f = File(path);
      if (await f.exists()) {
        await f.delete();
        log('🗑 Silindi: $path', name: tag);
      }
    }

    // 4) Pipeline tamamen sıfırdan oluşturuluyor
    await createOrUpdateDeviceCsvFromAsset();
    await createJsonFromAssetCsv();
    await createExcelFromAssetCsvSyncfusion();

    // JSON → SQL
    await importJsonToDatabaseFast();

    // Rapor
    await _runConsistencyReport();

    // ZIP her zaman oluşturulsun
    await createZipArchive();

    log('✨ TAM REBUILD tamamlandı ✓', name: tag);

    totalSw.stop();
    log('⏱ REBUILD toplam süre: ${totalSw.elapsedMilliseconds} ms', name: tag);
    return;
  }

  // --------------------------------------------------------------
  // ✔ Eğer REBUILD gerekmezse normal kontrol modu
  // --------------------------------------------------------------
  if (dbExists && recordCount > 0) {
    log(
      '🟢 Veritabanı zaten dolu ($recordCount kayıt). Yeniden oluşturulmadı.',
      name: tag,
    );

    await _runConsistencyReport();
    await createZipArchive();

    totalSw.stop();
    log(
      '⏱ initializeAppDataFlow toplam süre (sadece kontrol): ${totalSw.elapsedMilliseconds} ms',
      name: tag,
    );
    return;
  }

  // --------------------------------------------------------------
  // ✔ Veritabanı boş → İlk kurulum
  // --------------------------------------------------------------
  log('⚠️ Veritabanı boş. İlk kurulum başlıyor…', name: tag);

  await createJsonFromAssetCsv();
  await createExcelFromAssetCsvSyncfusion();
  await importJsonToDatabaseFast();
  await _runConsistencyReport();
  await createZipArchive();

  totalSw.stop();
  log(
    '✅ initializeAppDataFlow tamamlandı. Toplam süre: ${totalSw.elapsedMilliseconds} ms',
    name: tag,
  );
}

// ======================================================================
// 📊 CSV / JSON / SQL veri tutarlılık + eksik kayıt raporu
// ======================================================================
Future<void> _runConsistencyReport() async {
  const tag = 'file_creator';
  final directory = await getApplicationDocumentsDirectory();

  // ---------- CSV OKUMA ----------
  final csvPath = join(directory.path, fileNameCsv);
  final csvFile = File(csvPath);
  if (!await csvFile.exists()) {
    log('⚠️ CSV bulunamadı: $csvPath', name: tag);
    return;
  }

  final csvRaw = await csvFile.readAsString();
  final normalizedCsv = csvRaw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final csvLines = normalizedCsv
      .split('\n')
      .where((l) => l.trim().isNotEmpty)
      .toList();

  int csvCount = 0;
  final Map<String, int> csvWordCounts = {};
  final Map<String, List<int>> csvLineNumbers = {};
  final Map<String, String> csvDisplayWord = {};

  if (csvLines.length > 1) {
    final data = csvLines.sublist(1);
    csvCount = data.length;

    for (int i = 0; i < data.length; i++) {
      final line = data[i];
      final parts = line.split(',');
      if (parts.isEmpty) continue;

      final word = parts.first.trim();
      final key = word.toLowerCase();

      csvWordCounts[key] = (csvWordCounts[key] ?? 0) + 1;
      csvDisplayWord.putIfAbsent(key, () => word);
      csvLineNumbers.putIfAbsent(key, () => []).add(i + 2);
    }
  }

  final csvDuplicates = csvWordCounts.entries
      .where((e) => e.value > 1)
      .toList();

  // ---------- JSON OKUMA ----------
  final jsonPath = join(directory.path, fileNameJson);
  final jsonFile = File(jsonPath);
  if (!await jsonFile.exists()) {
    log('⚠️ JSON bulunamadı: $jsonPath', name: tag);
    return;
  }

  final jsonRaw = await jsonFile.readAsString();
  final List<dynamic> jsonList = jsonDecode(jsonRaw);
  final int jsonCount = jsonList.length;

  String wordKey = 'Word';
  if (jsonList.isNotEmpty) {
    final first = jsonList.first;
    for (final k in first.keys) {
      if (k.toString().toLowerCase() == 'word') {
        wordKey = k;
        break;
      }
    }
  }

  final Map<String, int> jsonWordCounts = {};
  final Map<String, String> jsonDisplayWord = {};

  for (final entry in jsonList) {
    final map = entry as Map<String, dynamic>;
    final word = map[wordKey]?.toString().trim() ?? '';
    if (word.isEmpty) continue;

    final key = word.toLowerCase();
    jsonWordCounts[key] = (jsonWordCounts[key] ?? 0) + 1;
    jsonDisplayWord.putIfAbsent(key, () => word);
  }

  final jsonDuplicates = jsonWordCounts.entries
      .where((e) => e.value > 1)
      .toList();

  // ---------- SQL ----------
  final dbWords = await DbHelper.instance.getRecords();
  final int sqlCount = dbWords.length;

  final sqlWordsLower = dbWords.map((w) => w.word.trim().toLowerCase()).toSet();

  final jsonWordsLower = jsonWordCounts.keys.toSet();

  final missingInJson = csvWordCounts.keys.toSet().difference(jsonWordsLower);

  // ---------- RAPOR ----------
  log(logLine, name: tag);
  log('📊 VERİ TUTARLILIK RAPORU', name: tag);
  log('CSV kayıt sayısı : $csvCount', name: tag);
  log('JSON kayıt sayısı: $jsonCount', name: tag);
  log('SQL kayıt sayısı : $sqlCount', name: tag);

  if (csvCount == jsonCount && jsonCount == sqlCount) {
    log('✅ TÜM DOSYALAR UYUMLU', name: tag);
  } else {
    log('❌ TUTARSIZLIK VAR → Kontrol edilmeli!', name: tag);
  }

  // CSV duplicate
  if (csvDuplicates.isEmpty) {
    log('✅ CSV duplicate yok.', name: tag);
  } else {
    log('🔁 CSV duplicate listesi:', name: tag);
    for (final e in csvDuplicates) {
      final w = csvDisplayWord[e.key]!;
      final lines = csvLineNumbers[e.key]!;
      log(
        ' • "$w" → ${e.value} kez (satırlar: ${lines.join(', ')})',
        name: tag,
      );
    }
  }

  // JSON duplicate
  if (jsonDuplicates.isEmpty) {
    log('✅ JSON duplicate yok.', name: tag);
  } else {
    log('🔁 JSON duplicate listesi:', name: tag);
    for (final e in jsonDuplicates) {
      final w = jsonDisplayWord[e.key]!;
      log(' • "$w" → ${e.value} kez', name: tag);
    }
  }

  // CSV → JSON eksik kelimeler
  final missingList = missingInJson.toList()..sort();

  if (missingList.isNotEmpty) {
    log(
      '❌ CSV → JSON eksik kelimeler (${missingList.length} adet):',
      name: tag,
    );
    for (final key in missingList) {
      final w = csvDisplayWord[key]!;
      final lines = csvLineNumbers[key]!;
      log(' • "$w" (satırlar: ${lines.join(', ')})', name: tag);
    }
  } else {
    log('✅ CSV → JSON tüm kelimeler aktarılmış.', name: tag);
  }

  log(logLine, name: tag);
}
