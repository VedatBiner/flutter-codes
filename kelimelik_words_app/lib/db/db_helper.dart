// 📃 <----- db_helper.dart ----->
//
// Tüm veri tabanı işlemleri
// Tüm CSV JSON işlemleri
// Türkçe harflere göre sıralama metodu burada tanımlanıyor
//

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

/// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- asset DB kopyalamak için eklendi
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../models/item_model.dart';

class DbHelper {
  // Singleton pattern: Sınıfın tek bir örneği olmasını sağlar.
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  /// Veritabanı örneğini döndürür.
  /// Eğer veritabanı daha önce oluşturulmamışsa, `_initDB` ile başlatır.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(fileNameSql);
    return _database!;
  }

  /// --------------------------------------------------------------------------
  /// 🚀 VERİTABANI BAŞLATMA + ASSET'TEN OTOMATİK KOPYALAMA
  /// --------------------------------------------------------------------------
  ///
  /// Eğer cihazda kelimelik_words_app.db yoksa → assets/database klasöründen
  /// birebir veritabanı dosyası kopyalanır.
  ///
  Future<Database> _initDB(String fileName) async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbFullPath = join(dbDir.path, fileName);

    final dbFile = File(dbFullPath);

    // 📌 Eğer veritabanı yoksa — assets/database içinden kopyala
    if (!await dbFile.exists()) {
      log(
        "📂 DB bulunamadı → asset'ten kopyalanıyor: $dbFullPath",
        name: "DbHelper",
      );

      try {
        // Asset içindeki DB'yi oku
        final data = await rootBundle.load("assets/database/$fileNameSql");

        // Bytes formatına çevir
        final bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );

        // Cihaza veritabanı olarak yaz
        await dbFile.writeAsBytes(bytes, flush: true);

        log("✅ Asset DB başarıyla kopyalandı.", name: "DbHelper");
      } catch (e) {
        log("❌ Asset DB kopyalama hatası: $e", name: "DbHelper");
      }
    } else {
      log("📌 DB zaten mevcut, doğrudan açılıyor…", name: "DbHelper");
    }

    // 📌 DB artık var → read/write modunda açılır
    return await openDatabase(
      dbFullPath,
      version: 1,
      onCreate: _createDB, // Eğer hiç yoksa tabloyu oluşturur
    );
  }

  /// Veritabanı ilk kez oluşturulduğunda `words` tablosunu yaratır.
  /// `word` sütunu, aynı kelimenin tekrar eklenmesini önlemek için UNIQUE'dir.
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $sqlTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL UNIQUE,
        meaning TEXT NOT NULL
      )
    ''');
  }

  /// --------------------------------------------------------------------------
  /// 📌 Veritabanı dosyasını tamamen sil
  /// --------------------------------------------------------------------------
  Future<void> deleteDatabaseFile() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final path = join(dbDir.path, fileNameSql);

    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    if (await File(path).exists()) {
      await File(path).delete();
      log('🗑 Veritabanı dosyası silindi: $path', name: 'DbHelper');
    }
  }

  /// Veritabanındaki tüm kelime kayıtlarını alır ve Türkçe'ye göre sıralar.
  Future<List<Word>> getRecords() async {
    final db = await instance.database;
    final result = await db.query(sqlTableName);
    final words = result.map((e) => Word.fromMap(e)).toList();
    return _sortTurkish(words);
  }

  /// Belirli bir kelimeyi adına göre veritabanında arar.
  Future<Word?> getItem(String word) async {
    final db = await instance.database;
    final result = await db.query(
      sqlTableName,
      where: 'word = ?',
      whereArgs: [word],
    );
    return result.isNotEmpty ? Word.fromMap(result.first) : null;
  }

  /// Veritabanına yeni bir kelime ekler.
  Future<int> insertRecord(Word word) async {
    final db = await instance.database;
    return await db.insert(sqlTableName, word.toMap());
  }

  /// Var olan bir kelimeyi ID'sine göre günceller.
  Future<int> updateRecord(Word word) async {
    final db = await instance.database;
    return await db.update(
      sqlTableName,
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  /// Belirtilen ID'ye sahip kelimeyi veritabanından siler.
  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete(sqlTableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Veritabanındaki toplam kayıt sayısını döndürür.
  Future<int> countRecords() async {
    final db = await instance.database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $sqlTableName'),
    );
    return result ?? 0;
  }

  /// --------------------------------------------------------------------------
  /// JSON EXPORT
  /// --------------------------------------------------------------------------
  Future<String> exportRecordsToJson() async {
    final words = await getRecords();
    final maps = words.map((w) => w.toMap()).toList();
    final jsonStr = jsonEncode(maps);
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/$fileNameJson";
    await File(path).writeAsString(jsonStr);
    return path;
  }

  /// JSON IMPORT
  Future<void> importRecordsFromJson(BuildContext context) async {
    const tag = 'db_helper';

    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = "${dir.path}/$fileNameJson";
      final file = File(path);

      if (!await file.exists()) {
        log("❌ JSON bulunamadı: $path", name: tag);
        return;
      }

      final jsonStr = await file.readAsString();
      final List<dynamic> list = jsonDecode(jsonStr);

      final db = await database;
      await db.delete(sqlTableName);

      for (final item in list) {
        await insertRecord(Word.fromMap(item));
      }

      log("✅ JSON Import tamamlandı (${list.length} kayıt)", name: tag);
    } catch (e) {
      log("🚨 JSON import hatası: $e", name: tag);
    }
  }

  /// --------------------------------------------------------------------------
  /// CSV EXPORT
  /// --------------------------------------------------------------------------
  Future<String> exportRecordsToCsv() async {
    final words = await getRecords();
    final buffer = StringBuffer();

    buffer.writeln("Kelime,Anlam");

    for (var w in words) {
      final kelime = w.word.replaceAll(",", "");
      final anlam = w.meaning.replaceAll(",", "");
      buffer.writeln("$kelime,$anlam");
    }

    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/$fileNameCsv";
    await File(path).writeAsString(buffer.toString());
    return path;
  }

  /// --------------------------------------------------------------------------
  /// CSV IMPORT
  /// --------------------------------------------------------------------------
  Future<void> importRecordsFromCsv() async {
    const tag = 'db_helper';
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = "${dir.path}/$fileNameCsv";
      final file = File(path);

      if (!await file.exists()) {
        log("❌ CSV bulunamadı", name: tag);
        return;
      }

      final lines = await file.readAsLines();
      if (lines.isEmpty) return;

      final db = await database;
      await db.delete(sqlTableName);

      int count = 0;
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split(",");
        if (parts.length < 2) continue;

        final kelime = parts[0].trim();
        final anlam = parts.sublist(1).join(",").trim();

        if (kelime.isNotEmpty && anlam.isNotEmpty) {
          await insertRecord(Word(word: kelime, meaning: anlam));
          count++;
        }
      }

      log("✅ CSV import tamamlandı ($count kayıt)", name: tag);
    } catch (e) {
      log("🚨 CSV import hatası: $e", name: tag);
    }
  }

  /// --------------------------------------------------------------------------
  /// TÜRKÇE SIRALAMA
  /// --------------------------------------------------------------------------
  List<Word> _sortTurkish(List<Word> words) {
    const alphabet =
        "AaBbCcÇçDdEeFfGgĞğHhIıİiJjKkLlMmNnOoÖöPpRrSsŞşTtUuÜüVvYyZz";

    int trCompare(String a, String b) {
      for (int i = 0; i < a.length && i < b.length; i++) {
        final ai = alphabet.indexOf(a[i]);
        final bi = alphabet.indexOf(b[i]);
        if (ai != bi) return ai.compareTo(bi);
      }
      return a.length.compareTo(b.length);
    }

    words.sort((a, b) => trCompare(a.word, b.word));
    return words;
  }

  /// --------------------------------------------------------------------------
  /// HIZLI BATCH INSERT
  /// --------------------------------------------------------------------------
  Future<void> insertBatch(List<Word> items) async {
    if (items.isEmpty) return;
    final db = await database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final item in items) {
        batch.insert(
          sqlTableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      await batch.commit(noResult: true);
    });
  }

  /// --------------------------------------------------------------------------
  /// DB Bağlantısını kapat
  /// --------------------------------------------------------------------------
  Future<void> closeDb() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
    }
    _database = null;
  }
}
