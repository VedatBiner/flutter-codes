// 📃 <----- lib/utils/fc_files/sql_helper.dart ----->
//
// 🎬 Netflix Film List App
// -----------------------------------------------------------
// Bu yardımcı dosya JSON → SQL (SQLite) toplu aktarım işlemini (batch import)
// yüksek performansla ve güvenli şekilde yapar.
//
// Adımlar:
//  1️⃣ Uygulama dizinindeki JSON dosyasını okur.
//  2️⃣ JSON verilerini `NetflixItem` modeline dönüştürür.
//  3️⃣ `DbHelper.insertBatch()` yöntemi ile veritabanına toplu ekleme yapar.
//  4️⃣ Konsola detaylı log mesajları yazar.
//  5️⃣ Hata durumlarında işlem güvenli şekilde sonlandırılır.
//
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../db/db_helper.dart';
import '../../models/item_model.dart';

/// 🚀 JSON dosyasını SQLite veritabanına hızlı şekilde aktarır.
///  • Dosya: `app_flutter/netflix_list_backup.json`
///  • Batch olarak çalışır → performanslı.
///  • Veritabanı boşsa veriler eklenir; doluysa işlem yapılmaz.
/// JSON → SQL batch import (compute() ile)
Future<void> importJsonToDatabaseFast() async {
  const tag = 'JSON→SQL Import (Compute)';
  try {
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, 'netflix_list_backup.json');
    final file = File(jsonPath);

    if (!await file.exists()) {
      log('⚠️ JSON dosyası bulunamadı.', name: tag);
      return;
    }

    // 1️⃣ JSON içeriğini oku
    final jsonStr = await file.readAsString();

    // 2️⃣ compute() ile başka isolate 'ta parse et
    final parsedItems = await compute(_parseJsonToItems, jsonStr);

    // 3️⃣ SQL ’e batch olarak yaz
    await DbHelper.instance.insertBatch(parsedItems);

    final count = await DbHelper.instance.countRecords();
    log('✅ SQL batch aktarımı tamamlandı ($count kayıt).', name: tag);
  } catch (e, st) {
    log('❌ JSON→SQL import hatası: $e', name: tag, error: e, stackTrace: st);
  }
}

/// 🧠 compute() içinde çalışan fonksiyon (UI thread ’den bağımsız)
List<NetflixItem> _parseJsonToItems(String jsonStr) {
  final List<dynamic> jsonList = json.decode(jsonStr);
  return jsonList.map((e) {
    return NetflixItem(
      netflixItemName: e['Title'] ?? '',
      watchDate: e['Date'] ?? '',
    );
  }).toList();
}
