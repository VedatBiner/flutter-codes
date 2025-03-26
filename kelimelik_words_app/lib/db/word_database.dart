import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/word_model.dart';

class WordDatabase {
  static final WordDatabase instance = WordDatabase._init();
  static Database? _database;

  WordDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('words.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    log('📁 SQLite veritabanı konumu: $path');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        meaning TEXT NOT NULL
      )
    ''');
  }

  Future<List<Word>> getWords() async {
    final db = await instance.database;
    final result = await db.query('words', orderBy: 'word ASC');
    return result.map((e) => Word.fromMap(e)).toList();
  }

  Future<Word?> getWord(String word) async {
    final db = await instance.database;
    final result = await db.query(
      'words',
      where: 'word = ?',
      whereArgs: [word],
    );
    return result.isNotEmpty ? Word.fromMap(result.first) : null;
  }

  Future<int> insertWord(Word word) async {
    final db = await instance.database;
    return await db.insert('words', word.toMap());
  }

  Future<int> updateWord(Word word) async {
    final db = await instance.database;
    return await db.update(
      'words',
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<int> deleteWord(int id) async {
    final db = await instance.database;
    return await db.delete('words', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countWords() async {
    final db = await instance.database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM words'),
    );
    return result ?? 0;
  }

  Future<String> exportWordsToJson() async {
    final words = await getWords(); // tüm kelimeleri al
    final wordMaps = words.map((w) => w.toMap()).toList();
    final jsonString = jsonEncode(wordMaps);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/kelimelik_backup.json';

    final file = File(filePath);
    await file.writeAsString(jsonString);

    // 📢 Konsola tam dosya yolunu yaz
    log('📤 JSON yedeği başarıyla oluşturuldu.', name: 'Backup');
    log('📁 Dosya yolu: $filePath', name: 'Backup');

    return filePath;
  }

  Future<void> importWordsFromJson() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/kelimelik_backup.json';
      final file = File(filePath);

      if (!(await file.exists())) {
        log('❌ Yedek dosyası bulunamadı: $filePath', name: 'Import');
        return;
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);

      // İstersen önce veritabanını temizleyebilirsin:
      final db = await database;
      await db.delete('words');

      for (var item in jsonList) {
        final word = Word.fromMap(item);
        await insertWord(word);
      }

      log(
        '✅ Yedek başarıyla geri yüklendi. (${jsonList.length} kayıt)',
        name: 'Import',
      );
      log('📂 Kaynak dosya: $filePath', name: 'Import');
    } catch (e) {
      log('🚨 Geri yükleme hatası: $e', name: 'Import');
    }
  }
}
