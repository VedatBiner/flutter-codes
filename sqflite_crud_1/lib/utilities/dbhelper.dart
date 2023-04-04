import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dbName = "myDatabase.db"; // const ya da final ?
  static const _dbVersion = 1;
  static const _tableName = "myTable";

  static const columnId = "_id";
  static const columnName = "name";

  // singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initiateDatabase();
    return _database!;
  }

  // veritabanı oluştur
  _initiateDatabase() async {
    // Directory - dart.io paketinden geliyor.
    // burada eğer yoksa database oluşturuluyor.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  // tablo oluştur
  Future _onCreate(Database db, int version) {
    return db.execute('''
        CREATE TABLE $_tableName (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL)
        ''');
  }

  // ekleme işlemi
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  // tüm listeyi almak için
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  // güncelleme işlemi
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(
      _tableName,
      row,
      where: "$columnId = ?",
      whereArgs: [id],
    );
  }

  // silme işlemi
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      _tableName,
      where: "$columnId = ?",
      whereArgs: [id],
    );
  }
}
