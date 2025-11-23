// 📃 <----- lib/utils/fc_files/sql_helper.dart ----->
//
// 📚 Kelimelik App
// -----------------------------------------------------------
// JSON → SQL aktarımı işlemini hızlı ve UI dostu hale getirmek için
// compute() kullanılarak arka planda parse edilir.
// UI thread donmadan, büyük JSON dosyaları işlenebilir.
//
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
Future<void> importJsonToDatabaseFast() async {
  const tag = 'sql_helper';
  try {
    // 📂 JSON dosya yolu
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);
    final file = File(jsonPath);

    if (!await file.exists()) {
      log('⚠️ JSON dosyası bulunamadı.', name: tag);
      return;
    }

    // 1️⃣ JSON dosyasını oku
    final jsonStr = await file.readAsString();

    // 2️⃣ compute() kullanarak ayrı isolate 'ta parse et
    final parsedWords = await compute(_parseJsonToWords, jsonStr);

    // 3️⃣ Batch olarak SQL 'e aktar
    await DbHelper.instance.insertBatch(parsedWords);

    final count = await DbHelper.instance.countRecords();
    log('✅ SQL batch aktarımı tamamlandı ($count kayıt).', name: tag);
  } catch (e, st) {
    log('❌ JSON→SQL import hatası: $e', name: tag, error: e, stackTrace: st);
  }
}

/// 🔹 compute() içinde çalışan JSON parse fonksiyonu.
/// Ana thread 'den tamamen bağımsız çalışır.
List<Word> _parseJsonToWords(String jsonStr) {
  final List<dynamic> jsonList = json.decode(jsonStr);

  return jsonList.map((e) {
    /// JSON içindeki farklı başlık ihtimalleri:
    final word = e['word'] ?? e['Word'] ?? e['kelime'] ?? e['Kelime'] ?? '';

    final meaning =
        e['meaning'] ?? e['Meaning'] ?? e['anlam'] ?? e['Anlam'] ?? '';

    return Word(word: word.toString(), meaning: meaning.toString());
  }).toList();
}
