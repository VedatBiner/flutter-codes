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

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';
import '../../db/db_helper.dart';
import '../../models/item_model.dart';

/// 🚀 JSON dosyasını SQLite veritabanına hızlı şekilde aktarır.
///  • Dosya: `app_flutter/netflix_list_backup.json`
///  • Batch olarak çalışır → performanslı.
///  • Veritabanı boşsa veriler eklenir; doluysa işlem yapılmaz.
Future<void> importJsonToDatabaseFast() async {
  const tag = 'sql_helper';

  try {
    log('⚙️ JSON → SQL batch aktarımı başlatıldı...', name: tag);

    // 1️⃣ Uygulama içi dizini bul
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);
    final file = File(jsonPath);

    if (!await file.exists()) {
      log('⚠️ JSON dosyası bulunamadı: $jsonPath', name: tag);
      return;
    }

    // 2️⃣ Veritabanı zaten doluysa yeniden yükleme yapma
    final existingCount = await DbHelper.instance.countRecords();
    if (existingCount > 0) {
      log(
        'ℹ️ Veritabanı zaten dolu ($existingCount kayıt). Aktarım yapılmadı.',
        name: tag,
      );
      return;
    }

    // 3️⃣ JSON içeriğini oku
    final jsonStr = await file.readAsString();
    final List<dynamic> jsonList = json.decode(jsonStr);

    if (jsonList.isEmpty) {
      log('⚠️ JSON listesi boş.', name: tag);
      return;
    }

    // 4️⃣ JSON verilerini modele dönüştür
    final items = jsonList.map((e) {
      final title = (e['Title'] ?? e['title'] ?? '').toString().trim();
      final date = (e['Date'] ?? e['date'] ?? '').toString().trim();
      return NetflixItem(netflixItemName: title, watchDate: date);
    }).toList();

    log('📦 Aktarılacak kayıt sayısı: ${items.length}', name: tag);

    // 5️⃣ Toplu ekleme (batch insert)
    await DbHelper.instance.insertBatch(items);

    // 6️⃣ Kontrol
    final count = await DbHelper.instance.countRecords();
    log('✅ SQL batch aktarımı tamamlandı ($count kayıt).', name: tag);
  } catch (e, st) {
    log('❌ JSON→SQL import hatası: $e', name: tag, error: e, stackTrace: st);
  }
}
