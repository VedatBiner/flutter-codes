// 📃 <----- db_helper.dart ----->
//
// SQLite veritabanı işlemlerini yöneten yardımcı sınıf.
// Malzeme verilerini ekleme, silme, güncelleme, sayma ve yedekleme
// işlemleri buradan yapılır.

// 📌 Dart
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

// 📌 Flutter / 3rd party
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// 📌 Proje
import '../constants/file_info.dart';
import '../models/item_model.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  /// 📌 Veritabanı örneğini getirir (singleton)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(fileNameSql);
    return _database!;
  }

  /// 📌 Veritabanını açar / oluşturur
  Future<Database> _initDB(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);

    log('📂 DB path: $path', name: 'DbHelper');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// 📌 Tabloları oluşturur (ilk kurulum)
  Future<void> _createDB(Database db, int version) async {
    log('🧱 Veritabanı oluşturuluyor...', name: 'DbHelper');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $sqlTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        malzeme TEXT NOT NULL,
        miktar INTEGER,
        aciklama TEXT
      )
    ''');

    log('✅ Tablo hazır: $sqlTableName', name: 'DbHelper');
  }

  /// 📌 Tablo var mı? (ilk açılış güvenliği)
  Future<bool> _tableExists(Database db) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [sqlTableName],
    );
    return result.isNotEmpty;
  }

  /// 📌 Gerekirse tabloyu oluştur (disk / kurulum sonrası güvenlik)
  Future<void> _ensureTable(Database db) async {
    final exists = await _tableExists(db);
    if (!exists) {
      log('⚠️ Tablo yok, yeniden oluşturuluyor...', name: 'DbHelper');
      await _createDB(db, 1);
    }
  }

  /// 📌 Tüm malzemeleri getir
  Future<List<Malzeme>> getRecords() async {
    final db = await database;
    await _ensureTable(db);

    final result = await db.query(sqlTableName);
    return result.map((e) => Malzeme.fromMap(e)).toList();
  }

  /// 📌 ID’ye göre getir
  Future<Malzeme?> getMalzemeById(int id) async {
    final db = await database;
    await _ensureTable(db);

    final result = await db.query(
      sqlTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Malzeme.fromMap(result.first) : null;
  }

  /// 📌 Ada göre getir (tekil kontrol)
  Future<Malzeme?> getItem(String malzemeAdi) async {
    final db = await database;
    await _ensureTable(db);

    final result = await db.query(
      sqlTableName,
      where: 'malzeme = ?',
      whereArgs: [malzemeAdi],
    );
    return result.isNotEmpty ? Malzeme.fromMap(result.first) : null;
  }

  /// 📌 Yeni malzeme ekle
  Future<void> insertRecord(Malzeme malzeme) async {
    final db = await database;
    await _ensureTable(db);

    await db.insert(sqlTableName, malzeme.toMap());
  }

  /// 📌 Güncelle
  Future<void> updateRecord(Malzeme malzeme) async {
    final db = await database;
    await _ensureTable(db);

    await db.update(
      sqlTableName,
      malzeme.toMap(),
      where: 'id = ?',
      whereArgs: [malzeme.id],
    );
  }

  /// 📌 Sil
  Future<void> deleteRecord(int id) async {
    final db = await database;
    await _ensureTable(db);

    await db.delete(sqlTableName, where: 'id = ?', whereArgs: [id]);
  }

  /// 📌 Toplam kayıt sayısı (ÇÖKMEZ)
  Future<int> countRecords() async {
    final db = await database;
    await _ensureTable(db);

    final result = await db.rawQuery('SELECT COUNT(*) FROM $sqlTableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// 📌 Veritabanını temizle
  Future<void> resetDatabase() async {
    final db = await database;
    await _ensureTable(db);

    await db.delete(sqlTableName);
    log('🧹 Veritabanı temizlendi', name: 'DbHelper');
  }

  /// 📌 JSON dışa aktar (opsiyonel legacy)
  Future<String> exportRecordsToJson() async {
    final items = await getRecords();
    final jsonData = jsonEncode(items.map((e) => e.toMap()).toList());

    final dir = await getApplicationDocumentsDirectory();
    final file = File(join(dir.path, fileNameJson));

    await file.writeAsString(jsonData);
    return file.path;
  }
}
