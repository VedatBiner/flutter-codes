// 📃 <----- db_helper.dart ----->
//
// SQLite veritabanı işlemlerini yöneten yardımcı sınıf.
// Malzeme verilerini ekleme, silme, güncelleme, yedekleme işlemleri buradan yapılır.

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/file_info.dart';
import '../models/malzeme_model.dart';

class MalzemeDatabase {
  static final MalzemeDatabase instance = MalzemeDatabase._init();
  static Database? _database;

  MalzemeDatabase._init();

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
      CREATE TABLE malzemeler (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        malzeme TEXT NOT NULL,
        miktar INTEGER,
        aciklama TEXT
      )
    ''');
  }

  /// 📌 Tüm malzemeleri getir
  Future<List<Malzeme>> getWords() async {
    final db = await instance.database;
    final result = await db.query('malzemeler');
    return result.map((e) => Malzeme.fromMap(e)).toList();
  }

  /// 📌 ID 'ye göre malzeme getir
  Future<Malzeme?> getMalzemeById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'malzemeler',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Malzeme.fromMap(result.first);
    }
    return null;
  }

  /// 📌 Malzeme adına göre getir (tekil kontrol için)
  Future<Malzeme?> getWord(String malzemeAdi) async {
    final db = await instance.database;
    final result = await db.query(
      'malzemeler',
      where: 'malzeme = ?',
      whereArgs: [malzemeAdi],
    );
    if (result.isNotEmpty) {
      return Malzeme.fromMap(result.first);
    }
    return null;
  }

  /// 📌 Yeni malzeme ekle
  Future<void> insertWord(Malzeme malzeme) async {
    final db = await instance.database;
    await db.insert('malzemeler', malzeme.toMap());
  }

  /// 📌 Mevcut malzemeyi güncelle
  Future<void> updateWord(Malzeme malzeme) async {
    final db = await instance.database;
    await db.update(
      'malzemeler',
      malzeme.toMap(),
      where: 'id = ?',
      whereArgs: [malzeme.id],
    );
  }

  /// 📌 Malzeme sil
  Future<void> deleteWord(int id) async {
    final db = await instance.database;
    await db.delete('malzemeler', where: 'id = ?', whereArgs: [id]);
  }

  /// 📌 Toplam malzeme sayısı
  Future<int> countWords() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM malzemeler');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// 📌 Verileri JSON olarak dışa aktar
  Future<String> exportWordsToJson() async {
    final items = await getWords();
    final jsonData = jsonEncode(items.map((e) => e.toMap()).toList());
    final dir = await getApplicationDocumentsDirectory();
    final file = File(join(dir.path, fileNameJson));
    await file.writeAsString(jsonData);
    return file.path;
  }

  /// 📌 Verileri CSV olarak dışa aktar
  Future<String> exportWordsToCsv() async {
    final items = await getWords();
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
    await db.delete('malzemeler');
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
