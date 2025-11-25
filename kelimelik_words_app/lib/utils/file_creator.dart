// 📃 <----- lib/utils/file_creator.dart ----->
//
// Veri akışının tamamında tutarlılık raporu ve benchmark eklendi.
// -----------------------------------------------------------
// Akış:
//   1️⃣ CSV (asset) → Cihaz CSV (createOrUpdateDeviceCsvFromAsset)
//   2️⃣ CSV → JSON (createJsonFromAssetCsv)
//   3️⃣ CSV → Excel (createExcelFromAssetCsvSyncfusion)
//   4️⃣ JSON → SQL (importJsonToDatabaseFast)
//
// Bu dosya:
//   • Veritabanı doluysa yeniden oluşturmaz, sadece rapor çalıştırır.
//   • CSV / JSON / SQL kayıt sayılarını karşılaştırır.
//   • CSV & JSON için duplicate "Word" tespiti yapar (sadece Word alanı).
//   • JSON ’da olup SQL ’e girmemiş kelimeleri listeler.
//   • Pipeline için toplam süreyi loglar.
//   • ZIP dosyası her durumda oluşturulur (yeni özellik)
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

  // 1️⃣ CSV: asset → cihaz senkronizasyonu
  await createOrUpdateDeviceCsvFromAsset();

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
  // ✔ Veritabanı doluysa yeniden oluşturma yok — ama ZIP YİNE DE ÜRETİLİR
  // --------------------------------------------------------------
  if (dbExists && recordCount > 0) {
    log(
      '🟢 Veritabanı zaten dolu ($recordCount kayıt). Yeniden oluşturulmadı.',
      name: tag,
    );

    await _runConsistencyReport();

    // ** ZIP her zaman oluşturulsun (yeni özellik) **
    await createZipArchive();

    totalSw.stop();
    log(
      '⏱ initializeAppDataFlow toplam süre (sadece kontrol): ${totalSw.elapsedMilliseconds} ms',
      name: tag,
    );

    return;
  }

  // --------------------------------------------------------------
  // ✔ Veritabanı boşsa sıfırdan tüm pipeline çalıştırılır
  // --------------------------------------------------------------
  log('⚠️ Veritabanı boş. Veri oluşturma başlıyor…', name: tag);

  // 2️⃣ CSV → JSON
  await createJsonFromAssetCsv();

  // 3️⃣ CSV → Excel (Syncfusion)
  await createExcelFromAssetCsvSyncfusion();

  // 4️⃣ JSON → SQL
  final importedCount = await importJsonToDatabaseFast();
  log(
    'ℹ️ importJsonToDatabaseFast() sonrası SQL kayıt sayısı: $importedCount',
    name: tag,
  );

  // 5️⃣ Tutarlılık & duplicate raporu
  await _runConsistencyReport();

  // 6️⃣ ZIP arşivi oluştur (her zaman)
  await createZipArchive();

  totalSw.stop();
  log(
    '✅ initializeAppDataFlow tamamlandı. Toplam süre: ${totalSw.elapsedMilliseconds} ms',
    name: tag,
  );
}

// ======================================================================
// 📊 CSV / JSON / SQL veri tutarlılık + duplicate + eksik kayıt raporu
// ======================================================================
Future<void> _runConsistencyReport() async {
  const tag = 'file_creator';

  final directory = await getApplicationDocumentsDirectory();

  // ---------- CSV OKUMA ----------
  final csvPath = join(directory.path, fileNameCsv);
  final csvFile = File(csvPath);
  if (!await csvFile.exists()) {
    log('⚠️ CSV dosyası bulunamadı: $csvPath', name: tag);
    return;
  }

  final csvRaw = await csvFile.readAsString();
  final normalizedCsv = csvRaw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final csvLines = normalizedCsv
      .split('\n')
      .where((l) => l.trim().isNotEmpty)
      .toList();

  int csvRecordCount = 0;
  final Map<String, int> csvWordCounts = {};
  final Map<String, String> csvDisplayWord = {};
  final Map<String, List<int>> csvLineNumbers = {};

  if (csvLines.length > 1) {
    final dataLines = csvLines.sublist(1);
    csvRecordCount = dataLines.length;

    for (int i = 0; i < dataLines.length; i++) {
      final line = dataLines[i];
      final parts = line.split(',');
      if (parts.isEmpty) continue;

      final word = parts.first.trim();
      if (word.isEmpty) continue;

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
    log('⚠️ JSON dosyası bulunamadı: $jsonPath', name: tag);
    return;
  }

  final jsonRaw = await jsonFile.readAsString();
  final List<dynamic> jsonList = jsonDecode(jsonRaw) as List<dynamic>;
  final int jsonCount = jsonList.length;

  String? wordKey;
  if (jsonList.isNotEmpty) {
    final first = jsonList.first as Map<String, dynamic>;
    for (final k in first.keys) {
      if (k.toString().toLowerCase() == 'word') {
        wordKey = k;
        break;
      }
    }
    wordKey ??= first.keys.first;
  }

  final Map<String, int> jsonWordCounts = {};
  final Map<String, String> jsonDisplayWord = {};

  for (final entry in jsonList) {
    final map = entry as Map<String, dynamic>;
    final value = map[wordKey] ?? '';
    final word = value.toString().trim();
    if (word.isEmpty) continue;

    final key = word.toLowerCase();
    jsonWordCounts[key] = (jsonWordCounts[key] ?? 0) + 1;
    jsonDisplayWord.putIfAbsent(key, () => word);
  }

  final jsonDuplicates = jsonWordCounts.entries
      .where((e) => e.value > 1)
      .toList();

  // ---------- SQL OKUMA ----------
  final dbWords = await DbHelper.instance.getRecords();
  final int sqlCount = dbWords.length;
  final Set<String> sqlWordsLower = dbWords
      .map((w) => w.word.trim().toLowerCase())
      .toSet();

  final Set<String> jsonWordsLower = jsonWordCounts.keys.toSet();

  final missingInSql = jsonWordsLower.difference(sqlWordsLower);
  final extraInSql = sqlWordsLower.difference(jsonWordsLower);

  // ---------- RAPOR ----------
  log(logLine, name: tag);
  log('📊 VERİ TUTARLILIK RAPORU', name: tag);
  log('CSV kayıt sayısı : $csvRecordCount', name: tag);
  log('JSON kayıt sayısı: $jsonCount', name: tag);
  log('SQL kayıt sayısı : $sqlCount', name: tag);

  if (csvRecordCount == jsonCount && jsonCount == sqlCount) {
    log('✅ TÜM DOSYALAR UYUMLU ✔', name: tag);
  } else {
    log('❌ TUTARSIZLIK VAR! ✔ Kontrol edilmeli.', name: tag);
  }

  // --- CSV duplicate ---
  if (csvDuplicates.isEmpty) {
    log('✅ CSV içinde duplicate Word yok.', name: tag);
  } else {
    log('🔁 CSV duplicate Word listesi:', name: tag);
    for (final e in csvDuplicates) {
      final w = csvDisplayWord[e.key]!;
      final lines = csvLineNumbers[e.key]!;
      log(
        '   • "$w" → ${e.value} kez (satırlar: ${lines.join(', ')})',
        name: tag,
      );
    }
  }

  // --- JSON duplicate ---
  if (jsonDuplicates.isEmpty) {
    log('✅ JSON içinde duplicate Word yok.', name: tag);
  } else {
    log('🔁 JSON duplicate Word listesi:', name: tag);
    for (final e in jsonDuplicates) {
      final w = jsonDisplayWord[e.key]!;
      log('   • "$w" → ${e.value} kez', name: tag);
    }
  }

  // --- JSON → SQL eksik aktarım ---
  if (missingInSql.isEmpty) {
    log('✅ JSON’daki tüm kelimeler SQL’e aktarılmış.', name: tag);
  } else {
    log('❌ JSON’da olup SQL’e girmeyen kelimeler:', name: tag);
    for (final key in missingInSql) {
      log('   • ${jsonDisplayWord[key]}', name: tag);
    }
  }

  // --- SQL’de fazladan ---
  if (extraInSql.isNotEmpty) {
    log(
      'ℹ️ Sadece SQL’de bulunan kelimeler (${extraInSql.length} adet):',
      name: tag,
    );
    int printed = 0;
    for (final key in extraInSql) {
      log('   • $key', name: tag);
      if (++printed >= 20) {
        log('   ... (ilk 20 gösterildi)', name: tag);
        break;
      }
    }
  }

  log(logLine, name: tag);
}
