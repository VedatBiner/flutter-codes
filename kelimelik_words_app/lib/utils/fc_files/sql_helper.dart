// 📃 <----- lib/utils/fc_files/sql_helper.dart ----->
//
// JSON → SQL Import (compute)
// -----------------------------------------------------------
// • Benchmark: JSON parse + SQL batch süresi
// • SQL’e eklenemeyen kelimeleri TAM LİSTE olarak konsola yazar
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';
import '../../db/db_helper.dart';
import '../../models/item_model.dart';

Future<Map<String, dynamic>> importJsonToDatabaseFast() async {
  const tag = 'JSON→SQL Import';
  try {
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);

    final file = File(jsonPath);
    if (!await file.exists()) {
      log('⚠️ JSON dosyası bulunamadı.', name: tag);
      return {};
    }

    final jsonStr = await file.readAsString();

    // ⏱ JSON Parse
    final swParse = Stopwatch()..start();
    final parsedWords = await compute(_parseJsonToWords, jsonStr);
    swParse.stop();

    // ⏱ SQL Batch Insert
    final swSql = Stopwatch()..start();
    await DbHelper.instance.insertBatch(parsedWords);
    swSql.stop();

    // SQL sayısı
    final sqlWords = await DbHelper.instance.getRecords();
    final sqlSet = sqlWords.map((e) => e.word).toSet();

    // JSON sayısı
    final jsonCount = parsedWords.length;
    final sqlCount = sqlWords.length;

    // 🔎 Eksik kelimeleri bul
    final missingWords = parsedWords
        .where((w) => !sqlSet.contains(w.word))
        .toList();

    if (missingWords.isNotEmpty) {
      log(
        "❌ SQL’e eklenmeyen ${missingWords.length} kelime tespit edildi:",
        name: tag,
      );

      // 200 taneye kadar gösterelim
      final limit = missingWords.length > 200 ? 200 : missingWords.length;

      for (int i = 0; i < limit; i++) {
        log("   • ${missingWords[i].word}", name: tag);
      }

      if (missingWords.length > 200) {
        log("   ... (${missingWords.length - 200} adet daha)", name: tag);
      }
    } else {
      log("✅ Tüm kelimeler SQL veritabanına başarıyla eklendi.", name: tag);
    }

    // Benchmark log
    log('⏱ JSON parse: ${swParse.elapsedMilliseconds} ms', name: tag);
    log('⏱ SQL batch : ${swSql.elapsedMilliseconds} ms', name: tag);

    return {
      'jsonCount': jsonCount,
      'sqlCount': sqlCount,
      'missing': missingWords.length,
      'parseMs': swParse.elapsedMilliseconds,
      'sqlMs': swSql.elapsedMilliseconds,
    };
  } catch (e, st) {
    log('❌ JSON→SQL import hatası: $e', name: tag, error: e, stackTrace: st);
    return {};
  }
}

List<Word> _parseJsonToWords(String jsonStr) {
  final List<dynamic> jsonList = json.decode(jsonStr);
  return jsonList.map((e) {
    return Word(
      word: e['Word'] ?? e['word'],
      meaning: e['Meaning'] ?? e['meaning'],
    );
  }).toList();
}
