// 📃 <----- db_helper.dart ----->
//
// SQLite veritabanı işlemlerini yöneten yardımcı sınıf.
// Malzeme verilerini ekleme, silme, güncelleme, yedekleme işlemleri buradan yapılır.

// 📌 Flutter hazır paketleri
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// 📌 Yardımcı yüklemeler burada
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

  /// 📌 Veritabanını başlatır veya oluşturur
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// 📌 Veritabanı tablolarını oluşturur
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sqlTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        malzeme TEXT NOT NULL,
        miktar INTEGER,
        aciklama TEXT
      )
    ''');
  }

  /// 📌 Tüm malzemeleri getir
  Future<List<Malzeme>> getRecords() async {
    final db = await instance.database;
    final result = await db.query(sqlTableName);
    return result.map((e) => Malzeme.fromMap(e)).toList();
  }

  /// 📌 ID 'ye göre malzeme getir
  Future<Malzeme?> getMalzemeById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      sqlTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Malzeme.fromMap(result.first);
    }
    return null;
  }

  /// 📌 Malzeme adına göre getir (tekil kontrol için)
  Future<Malzeme?> getItem(String malzemeAdi) async {
    final db = await instance.database;
    final result = await db.query(
      sqlTableName,
      where: 'malzeme = ?',
      whereArgs: [malzemeAdi],
    );
    if (result.isNotEmpty) {
      return Malzeme.fromMap(result.first);
    }
    return null;
  }

  /// 📌 Yeni malzeme ekle
  Future<void> insertRecord(Malzeme malzeme) async {
    final db = await instance.database;
    await db.insert(sqlTableName, malzeme.toMap());
  }

  /// 📌 Mevcut malzemeyi güncelle
  Future<void> updateRecord(Malzeme malzeme) async {
    final db = await instance.database;
    await db.update(
      sqlTableName,
      malzeme.toMap(),
      where: 'id = ?',
      whereArgs: [malzeme.id],
    );
  }

  /// 📌 Malzeme sil
  Future<void> deleteRecord(int id) async {
    final db = await instance.database;
    await db.delete(sqlTableName, where: 'id = ?', whereArgs: [id]);
  }

  /// 📌 Toplam malzeme sayısı
  Future<int> countRecords() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $sqlTableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// 📌 Verileri JSON olarak dışa aktar
  Future<String> exportRecordsToJson() async {
    final items = await getRecords();
    final jsonData = jsonEncode(items.map((e) => e.toMap()).toList());
    final dir = await getApplicationDocumentsDirectory();
    final file = File(join(dir.path, fileNameJson));
    await file.writeAsString(jsonData);
    return file.path;
  }

  /// 📌 Verileri CSV olarak dışa aktar
  Future<String> exportRecordsToCsv() async {
    final items = await getRecords();
    final buffer = StringBuffer();
    buffer.writeln('id,malzeme,miktar,aciklama');
    for (final item in items) {
      final aciklama = (item.aciklama ?? '').replaceAll('"', '""');
      buffer.writeln(
        '${item.id},"${item.malzeme}",${item.miktar ?? 0},"$aciklama"',
      );
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File(join(dir.path, fileNameCsv));
    await file.writeAsString(buffer.toString());
    return file.path;
  }

  /// 📌 Tüm veritabanını sıfırla (malzeme tablosunu temizle)
  Future<void> resetDatabase() async {
    final db = await instance.database;
    await db.delete(sqlTableName);
  }

  /// 📌 Türkçe sıralama yöntemi.
  List<Malzeme> _sortTurkish(List<Malzeme> items) {
    const turkishAlphabet =
        'aAbBcCçÇdDeEfFgGğĞhHIıİijJkKlLmMnNoOöÖpPrRsSşŞtTuUüÜvVyYzZ';

    int turkishCompare(String a, String b) {
      a = a.toLowerCase();
      b = b.toLowerCase();

      for (int i = 0; i < a.length && i < b.length; i++) {
        final ai = turkishAlphabet.indexOf(a[i]);
        final bi = turkishAlphabet.indexOf(b[i]);
        if (ai != bi) return ai.compareTo(bi);
      }

      return a.length.compareTo(b.length);
    }

    items.sort((a, b) => turkishCompare(a.malzeme, b.malzeme));
    return items;
  }
}
