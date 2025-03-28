// 📃 <----- word_database.dart ----->

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

  /// 📌 SQLite veritabanı nesnesini alır.
  ///
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('words.db');
    return _database!;
  }

  /// 📌 Yeni bir veritabanı oluşturur.
  ///
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    log('📁 SQLite veritabanı konumu: $path');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// 📌 Yeni bir veritabanı oluşturur.
  ///
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        meaning TEXT NOT NULL
      )
    ''');
  }

  /// 📌 Tüm kelimeleri alır.
  ///
  Future<List<Word>> getWords() async {
    final db = await instance.database;
    final result = await db.query('words', orderBy: 'word ASC');
    return result.map((e) => Word.fromMap(e)).toList();
  }

  /// 📌 Kelimeyi aramak için kullanılır.
  ///
  Future<Word?> getWord(String word) async {
    final db = await instance.database;
    final result = await db.query(
      'words',
      where: 'word = ?',
      whereArgs: [word],
    );
    return result.isNotEmpty ? Word.fromMap(result.first) : null;
  }

  /// 📌 Yeni kelimeyi ekler.
  ///
  Future<int> insertWord(Word word) async {
    final db = await instance.database;
    return await db.insert('words', word.toMap());
  }

  /// 📌 ID ye göre kelimeyi günceller.
  Future<int> updateWord(Word word) async {
    final db = await instance.database;
    return await db.update(
      'words',
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  /// 📌 ID ye göre kelimeyi siler.
  ///
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

  /// 📌 JSON yedeği burada alınıyor.
  ///
  Future<String> exportWordsToJson() async {
    final words = await getWords(); // tüm kelimeleri al
    final wordMaps = words.map((w) => w.toMap()).toList();
    final jsonString = jsonEncode(wordMaps);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/kelimelik_backup.json';

    final file = File(filePath);
    await file.writeAsString(jsonString);

    /// 🔥 Konsola yaz
    log('📤 JSON yedeği başarıyla oluşturuldu.', name: 'Backup');
    log('📁 Dosya yolu: $filePath', name: 'Backup');

    return filePath;
  }

  /// 📌 JSON yedeği burada geri yükleniyor.
  ///
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

      /// 🔥 Konsola yaz
      log(
        '✅ Yedek başarıyla geri yüklendi. (${jsonList.length} kayıt)',
        name: 'Import',
      );
      log('📂 Kaynak dosya: $filePath', name: 'Import');
    } catch (e) {
      log('🚨 Geri yükleme hatası: $e', name: 'Import');
    }
  }

  /// 📌 CSV yedeği burada alınıyor.
  ///
  Future<String> exportWordsToCsv() async {
    final words = await WordDatabase.instance.getWords();
    final buffer = StringBuffer();

    buffer.writeln('Kelime,Anlam');

    for (var word in words) {
      final kelime = word.word.replaceAll(',', '');
      final anlam = word.meaning.replaceAll(',', '');
      buffer.writeln('$kelime,$anlam');
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/kelimelik_backup.csv';
    final file = File(filePath);

    await file.writeAsString(buffer.toString());

    /// 🔥 Konsola yaz
    log('📤 CSV yedeği başarıyla oluşturuldu.', name: 'Backup');
    log('📁 CSV dosya yolu: $filePath', name: 'Backup');

    return filePath;
  }

  /// 📌 CSV yedeği burada geri yükleniyor.
  Future<void> importWordsFromCsv() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/kelimelik_backup.csv';
      final file = File(filePath);

      if (!(await file.exists())) {
        log('❌ CSV dosyası bulunamadı: $filePath', name: 'Import');
        return;
      }

      final lines = await file.readAsLines();

      if (lines.isEmpty) {
        log('❌ CSV dosyası boş.', name: 'Import');
        return;
      }

      // Veritabanını temizle
      final db = await database;
      await db.delete('words');

      // İlk satır başlık, atla
      int count = 0;
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split(',');
        if (parts.length < 2) continue;

        final kelime = parts[0].trim();
        final anlam =
            parts.sublist(1).join(',').trim(); // anlamda virgül olabilir

        if (kelime.isNotEmpty && anlam.isNotEmpty) {
          final word = Word(word: kelime, meaning: anlam);
          await insertWord(word);
          count++;
        }
      }

      /// 🔥 Konsola yaz
      log('✅ CSV yedeği başarıyla yüklendi. ($count kayıt)', name: 'Import');
      log('📂 CSV dosya konumu: $filePath', name: 'Import');
    } catch (e) {
      log('🚨 CSV yükleme hatası: $e', name: 'Import');
    }
  }
}
