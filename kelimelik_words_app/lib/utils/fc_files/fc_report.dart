// 📃 <----- lib/utils/fc_files/fc_report.dart ----->
//
// Gelişmiş Tutarlılık Raporu + Benchmark Analizleri
// --------------------------------------------------------
// ✔ CSV → JSON analiz
// ✔ JSON → SQL analiz
// ✔ Duplicate tespiti (CSV & JSON)
// ✔ CSV → JSON eksik kayıtlar
// ✔ CREATE hız analizi: En yavaş 10 insert
// ✔ Pipeline benchmark: csvToJsonMs, jsonToSqlMs, totalMs
// --------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';

const tag = "fc_report";

/// ✔ insert süreleri listesi:
///   { "word": "Ab", "ms": 3 }
typedef InsertDuration = Map<String, dynamic>;

Future<void> runFullDataReport({
  required int csvToJsonMs,
  required int jsonToSqlMs,
  required int totalPipelineMs,
  required List<InsertDuration> insertDurations,
}) async {
  log(logLine, name: tag);
  log("📊 BENCHMARK + VERİ ANALİZİ RAPORU BAŞLADI", name: tag);
  log(logLine, name: tag);

  // ----------------------------------------------------
  // 📂 DOSYA YOLLARI
  // ----------------------------------------------------
  final directory = await getApplicationDocumentsDirectory();
  final csvPath = join(directory.path, fileNameCsv);
  final jsonPath = join(directory.path, fileNameJson);

  // ----------------------------------------------------
  // 📌 CSV OKUMA
  // ----------------------------------------------------
  final csvRaw = await File(csvPath).readAsString();
  final csvLines = csvRaw
      .replaceAll("\r\n", "\n")
      .replaceAll("\r", "\n")
      .split("\n")
      .where((e) => e.trim().isNotEmpty)
      .toList();

  final csvCount = csvLines.length - 1;

  // Duplicate analiz:
  final Map<String, int> csvWordCounts = {};
  final Map<String, List<int>> csvLineNumbers = {};
  final Map<String, String> csvDisplayWord = {};

  for (int i = 1; i < csvLines.length; i++) {
    final parts = csvLines[i].split(',');
    if (parts.isEmpty) continue;

    final word = parts.first.trim();
    final key = word.toLowerCase();

    csvWordCounts[key] = (csvWordCounts[key] ?? 0) + 1;
    csvDisplayWord.putIfAbsent(key, () => word);
    csvLineNumbers.putIfAbsent(key, () => []).add(i + 1);
  }

  final csvDuplicates = csvWordCounts.entries
      .where((e) => e.value > 1)
      .toList();

  // ----------------------------------------------------
  // 📌 JSON OKUMA
  // ----------------------------------------------------
  final jsonList = jsonDecode(await File(jsonPath).readAsString()) as List;
  final jsonCount = jsonList.length;

  String wordKey = "Word";
  if (jsonList.isNotEmpty) {
    for (final k in (jsonList.first as Map).keys) {
      if (k.toString().toLowerCase() == "word") {
        wordKey = k;
        break;
      }
    }
  }

  final Map<String, int> jsonWordCounts = {};
  for (final entry in jsonList) {
    final map = entry as Map<String, dynamic>;
    final word = map[wordKey]?.toString().trim() ?? "";
    final key = word.toLowerCase();
    jsonWordCounts[key] = (jsonWordCounts[key] ?? 0) + 1;
  }

  final jsonDuplicates = jsonWordCounts.entries
      .where((e) => e.value > 1)
      .toList();

  // ----------------------------------------------------
  // 📌 SQL Kayıt Sayısı
  // ----------------------------------------------------
  // SQL sayısı file_creator.dart tarafından gönderilecek
  // Bu modül sadece CSV & JSON & insert-speed analiz yapar

  // ----------------------------------------------------
  // 📌 CSV → JSON eksik kelimeler
  // ----------------------------------------------------
  final missingCsvToJson = csvWordCounts.keys.toSet().difference(
    jsonWordCounts.keys.toSet(),
  );

  // ----------------------------------------------------
  // 📌 BENCHMARK BÖLÜMÜ
  // ----------------------------------------------------
  log("⚡ BENCHMARK", name: tag);
  log("• CSV → JSON: ${csvToJsonMs} ms", name: tag);
  log("• JSON → SQL: ${jsonToSqlMs} ms", name: tag);
  log("• TOPLAM Pipeline: ${totalPipelineMs} ms", name: tag);
  log(logLine, name: tag);

  // ----------------------------------------------------
  // 🐌 EN YAVAŞ 10 INSERT ANALİZİ
  // ----------------------------------------------------
  log("🐌 En Yavaş 10 INSERT (ms)", name: tag);

  final sorted = [...insertDurations]
    ..sort((a, b) => (b["ms"] as int).compareTo(a["ms"] as int));

  final slowest = sorted.take(10).toList();

  for (final item in slowest) {
    log("• ${item['word']} → ${item['ms']} ms", name: tag);
  }

  log(logLine, name: tag);

  // ----------------------------------------------------
  // 🔁 CSV Duplicate
  // ----------------------------------------------------
  if (csvDuplicates.isEmpty) {
    log("✅ CSV duplicate yok", name: tag);
  } else {
    log("🔁 CSV duplicate (${csvDuplicates.length})", name: tag);
    for (final e in csvDuplicates) {
      log(
        "• ${csvDisplayWord[e.key]} → ${e.value} kez | satırlar: ${csvLineNumbers[e.key]}",
        name: tag,
      );
    }
  }

  log(logLine, name: tag);

  // ----------------------------------------------------
  // 🔁 JSON Duplicate
  // ----------------------------------------------------
  if (jsonDuplicates.isEmpty) {
    log("✅ JSON duplicate yok", name: tag);
  } else {
    log("🔁 JSON duplicate (${jsonDuplicates.length})", name: tag);
    for (final e in jsonDuplicates) {
      log("• ${e.key} → ${e.value} kez", name: tag);
    }
  }

  log(logLine, name: tag);

  // ----------------------------------------------------
  // ❌ CSV → JSON eksik kelimeler
  // ----------------------------------------------------
  if (missingCsvToJson.isEmpty) {
    log("✅ Tüm CSV kelimeleri JSON’a aktarılmış", name: tag);
  } else {
    log("❌ CSV → JSON eksik kelimeler (${missingCsvToJson.length})", name: tag);
    for (final w in missingCsvToJson) {
      log("• ${csvDisplayWord[w]} (satır: ${csvLineNumbers[w]})", name: tag);
    }
  }

  log(logLine, name: tag);
  log("📊 RAPOR TAMAMLANDI", name: tag);
  log(logLine, name: tag);
}
