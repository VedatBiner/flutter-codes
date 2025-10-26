// 📃 db_helper.dart
import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('netflix_history.db');
    return _database!;
  }

  // 📂 Veritabanı oluşturma
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE netflix_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            watch_date TEXT,
            imdb_title TEXT,
            imdb_rating TEXT,
            imdb_poster TEXT
          )
        ''');
        log('✅ Tablo oluşturuldu: netflix_history');
      },
    );
  }

  // 🧩 Kayıt ekleme
  Future<void> insertRecord(Map<String, dynamic> record) async {
    final db = await database;
    await db.insert(
      'netflix_history',
      record,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 📜 Tüm kayıtları getir
  Future<List<Map<String, dynamic>>> fetchAll() async {
    final db = await database;
    return await db.query('netflix_history', orderBy: 'id DESC');
  }

  // 🧹 Tüm kayıtları sil
  Future<void> clearTable() async {
    final db = await database;
    await db.delete('netflix_history');
  }

  // 🔍 IMDb bilgisi olmayan kayıtları getir
  Future<List<Map<String, dynamic>>> fetchWithoutImdb() async {
    final db = await database;
    return await db.query(
      'netflix_history',
      where: 'imdb_rating IS NULL OR imdb_rating = ""',
    );
  }
}
