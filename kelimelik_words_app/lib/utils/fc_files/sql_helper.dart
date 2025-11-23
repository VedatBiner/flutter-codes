// 📃 <----- lib/utils/fc_files/sql_helper.dart ----->
//
// 📚 Kelimelik App
// -----------------------------------------------------------
// JSON → SQL aktarımı işlemini hızlı ve UI dostu hale getirmek için
// compute() kullanılarak arka planda parse edilir.
// UI thread donmadan, büyük JSON dosyaları işlenebilir.
//
// Bu sürümde:
//  • JSON→SQL işlemi için ayrıntılı benchmark loglanır.
//  • Fonksiyon, veritabanındaki toplam kayıt sayısını döndürür.
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart'; // ✅ compute() burada
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';
import '../../db/db_helper.dart';
import '../../models/item_model.dart'; // Word modelini içerir

/// JSON → SQL batch import (compute() ile hızlandırılmış)
/// İşlem süresi alt kırılımlarıyla birlikte loglanır.
Future<int> importJsonToDatabaseFast() async {
  const tag = 'JSON→SQL Import (Compute)';
  final totalSw = Stopwatch()..start();

  try {
    // 📂 JSON dosya yolu
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);
    final file = File(jsonPath);

    if (!await file.exists()) {
      log('⚠️ JSON dosyası bulunamadı: $jsonPath', name: tag);
      totalSw.stop();
      return 0;
    }

    // 1️⃣ JSON dosyasını oku
    final readSw = Stopwatch()..start();
    final jsonStr = await file.readAsString();
    readSw.stop();

    // 2️⃣ compute() kullanarak ayrı isolate 'ta parse et
    final parseSw = Stopwatch()..start();
    final parsedWords = await compute(_parseJsonToWords, jsonStr);
    parseSw.stop();

    // 3️⃣ Batch olarak SQL 'e aktar
    final insertSw = Stopwatch()..start();
    await DbHelper.instance.insertBatch(parsedWords);
    insertSw.stop();

    final count = await DbHelper.instance.countRecords();

    totalSw.stop();

    log(
      '⏱ JSON okuma süresi      : ${readSw.elapsedMilliseconds} ms',
      name: tag,
    );
    log(
      '⏱ JSON parse (compute)   : ${parseSw.elapsedMilliseconds} ms',
      name: tag,
    );
    log(
      '⏱ SQL batch insert süresi: ${insertSw.elapsedMilliseconds} ms',
      name: tag,
    );
    log(
      '⏱ JSON→SQL toplam süre   : ${totalSw.elapsedMilliseconds} ms',
      name: tag,
    );
    log('✅ SQL batch aktarımı tamamlandı ($count kayıt).', name: tag);

    return count;
  } catch (e, st) {
    totalSw.stop();
    log('❌ JSON→SQL import hatası: $e', name: tag, error: e, stackTrace: st);
    return 0;
  }
}

/// 🔹 compute() içinde çalışan JSON parse fonksiyonu.
/// Ana thread 'den tamamen bağımsız çalışır.
List<Word> _parseJsonToWords(String jsonStr) {
  final List<dynamic> jsonList = json.decode(jsonStr);

  return jsonList.map((e) {
    // JSON örneği:
    // { "Word": "Ab", "Meaning": "Su" }
    final map = e as Map<String, dynamic>;
    final word = (map['Word'] ?? map['word'] ?? '').toString().trim();
    final meaning = (map['Meaning'] ?? map['meaning'] ?? '').toString().trim();

    return Word(word: word, meaning: meaning);
  }).toList();
}
