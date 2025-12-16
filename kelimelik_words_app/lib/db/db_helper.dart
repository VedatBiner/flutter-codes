// 📃 <----- db_helper.dart ----->
//
// Tüm veri tabanı işlemleri
// Tüm CSV JSON işlemleri
// Türkçe harflere göre sıralama metodu burada tanımlanıyor
//

import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart'; // <-- asset DB kopyalamak için
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// 📌 Yardımcı yüklemeler
import '../constants/file_info.dart';
import '../models/item_model.dart';

const tag = "db_helper";

class DbHelper {
  // Singleton
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  /// --------------------------------------------------------------------------
  /// DATABASE INSTANCE
  /// --------------------------------------------------------------------------
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(fileNameSql);
    return _database!;
  }

  /// --------------------------------------------------------------------------
  /// 🚀 VERİTABANI BAŞLATMA + ASSET'TEN OTOMATİK KOPYALAMA
  /// --------------------------------------------------------------------------
  Future<Database> _initDB(String fileName) async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbFullPath = join(dbDir.path, fileName);

    final dbFile = File(dbFullPath);

    // 📌 Asset DB kopyalama
    if (!await dbFile.exists()) {
      log("📂 DB bulunamadı → asset 'ten kopyalanıyor: $dbFullPath", name: tag);

      try {
        final data = await rootBundle.load("assets/database/$fileNameSql");
        final bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        await dbFile.writeAsBytes(bytes, flush: true);
        log("✅ Asset DB başarıyla kopyalandı.", name: tag);
      } catch (e) {
        log("❌ Asset DB kopyalama hatası: $e", name: tag);
      }
    } else {
      log("📌 DB zaten mevcut, doğrudan açılıyor…", name: tag);
    }

    return await openDatabase(
      dbFullPath,
      version: 2, // 🔥 ARTIRILDI
      onCreate: _createDB,
      onUpgrade: _onUpgradeDB, // 🔥 MIGRATION
    );
  }

  /// --------------------------------------------------------------------------
  /// 🧱 İLK TABLO OLUŞTURMA
  /// --------------------------------------------------------------------------
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $sqlTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL UNIQUE,
        meaning TEXT NOT NULL,
        created_at TEXT
      )
    ''');

    // İlk kayıtlar için varsayılan tarih
    await db.execute('''
      UPDATE $sqlTableName
      SET created_at = '15.12.2025'
      WHERE created_at IS NULL
    ''');
  }

  /// --------------------------------------------------------------------------
  /// 🔁 MIGRATION (TARİH SÜTUNU EKLEME)
  /// --------------------------------------------------------------------------
  Future<void> _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      log("🔄 DB upgrade başlatıldı (v$oldVersion → v$newVersion)", name: tag);

      await db.execute("ALTER TABLE $sqlTableName ADD COLUMN created_at TEXT");

      await db.execute('''
        UPDATE $sqlTableName
        SET created_at = '15.12.2025'
        WHERE created_at IS NULL
      ''');

      log("✅ created_at sütunu eklendi ve dolduruldu", name: tag);
    }
  }

  /// --------------------------------------------------------------------------
  /// 🗑 DB DOSYASINI TAMAMEN SİL
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
      log('🗑 Veritabanı silindi: $path', name: tag);
    }
  }

  /// --------------------------------------------------------------------------
  /// 📥 TÜM KAYITLAR
  /// --------------------------------------------------------------------------
  Future<List<Word>> getRecords() async {
    final db = await instance.database;
    final result = await db.query(sqlTableName);
    final words = result.map((e) => Word.fromMap(e)).toList();
    return _sortTurkish(words);
  }

  Future<Word?> getItem(String word) async {
    final db = await instance.database;
    final result = await db.query(
      sqlTableName,
      where: 'word = ?',
      whereArgs: [word],
    );
    return result.isNotEmpty ? Word.fromMap(result.first) : null;
  }

  Future<int> insertRecord(Word word) async {
    final db = await instance.database;
    final map = word.toMap();

    map['created_at'] ??= '15.12.2025';

    return await db.insert(sqlTableName, map);
  }

  Future<int> updateRecord(Word word) async {
    final db = await instance.database;
    return await db.update(
      sqlTableName,
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete(sqlTableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countRecords() async {
    final db = await instance.database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $sqlTableName'),
    );
    return result ?? 0;
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
  /// BATCH INSERT
  /// --------------------------------------------------------------------------
  Future<void> insertBatch(List<Word> items) async {
    if (items.isEmpty) return;
    final db = await database;

    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final item in items) {
        final map = item.toMap();
        map['created_at'] ??= '15.12.2025';
        batch.insert(
          sqlTableName,
          map,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  /// --------------------------------------------------------------------------
  /// DB KAPAT
  /// --------------------------------------------------------------------------
  Future<void> closeDb() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
    }
    _database = null;
  }
}
