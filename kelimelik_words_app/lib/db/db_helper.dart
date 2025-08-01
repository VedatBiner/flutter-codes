// 📃 <----- word_database.dart ----->
// Tüm veri tabanı işlemleri
// Tüm CSV JSON işlemleri
// Türkçe harflere göre sıralama metodu burada tanımlanıyor
//

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../models/word_model.dart';
import '../utils/excel_backup_helper.dart';
import '../widgets/notification_service.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  /// 📌 SQLite veritabanı nesnesini alır.
  ///
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(fileNameSql);
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
    final result = await db.query('words'); // OrderBy kaldırıldı
    final words = result.map((e) => Word.fromMap(e)).toList();

    return _sortTurkish(words); // 👈 Türkçe sıralamayı uygula
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
    final filePath = '${directory.path}/$fileNameJson';

    final file = File(filePath);
    await file.writeAsString(jsonString);

    return filePath;
  }

  /// 📌 JSON yedeği burada geri yükleniyor.
  ///
  Future<void> importWordsFromJson(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameJson';
      final file = File(filePath);

      if (!(await file.exists())) {
        log('❌ Yedek dosyası bulunamadı: $filePath', name: 'Import');

        if (context.mounted) {
          NotificationService.showCustomNotification(
            context: context,
            title: 'Dosya Bulunamadı',
            message: const Text('JSON yedek dosyası bulunamadı.'),
            icon: Icons.error_outline,
            iconColor: Colors.red,
            progressIndicatorColor: Colors.red,
            progressIndicatorBackground: Colors.red.shade100,
          );
        }
        return;
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);

      final db = await database;
      await db.delete('words');

      for (var item in jsonList) {
        final word = Word.fromMap(item);
        await insertWord(word);
      }

      log(
        '✅ JSON yedeği başarıyla yüklendi. (${jsonList.length} kayıt)',
        name: 'Import',
      );

      if (context.mounted) {
        NotificationService.showCustomNotification(
          context: context,
          title: 'JSON Yedeği Yüklendi',
          message: Text('${jsonList.length} kelime başarıyla yüklendi.'),
          icon: Icons.upload_file,
          iconColor: Colors.green,
          progressIndicatorColor: Colors.green,
          progressIndicatorBackground: Colors.green.shade100,
        );
      }
    } catch (e) {
      log('🚨 Geri yükleme hatası: $e', name: 'Import');

      if (context.mounted) {
        NotificationService.showCustomNotification(
          context: context,
          title: 'Yükleme Hatası',
          message: Text('Bir hata oluştu: $e'),
          icon: Icons.error,
          iconColor: Colors.red,
          progressIndicatorColor: Colors.red,
          progressIndicatorBackground: Colors.red.shade100,
        );
      }
    }
  }

  /// 📌 CSV yedeği burada alınıyor.
  ///
  Future<String> exportWordsToCsv() async {
    final words = await DbHelper.instance.getWords();
    final buffer = StringBuffer();

    buffer.writeln('Kelime,Anlam');

    for (var word in words) {
      final kelime = word.word.replaceAll(',', '');
      final anlam = word.meaning.replaceAll(',', '');
      buffer.writeln('$kelime,$anlam');
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameCsv';
    final file = File(filePath);

    await file.writeAsString(buffer.toString());

    return filePath;
  }

  /// 📌 CSV yedeği burada geri yükleniyor.
  Future<void> importWordsFromCsv() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameCsv';
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

  /// 📌 Excel yedeği burada alınıyor.
  Future<String> exportWordsToExcel() async {
    // 1️⃣ Excel dosyasını oluşturacak yardımcıyı çağırıyoruz
    final filePath = await createExcelBackup();

    // 2️⃣ Path 'i geri döndürüyoruz
    return filePath;
  }

  /// 📌 Türkçe sıralama yöntemi.
  List<Word> _sortTurkish(List<Word> words) {
    const turkishAlphabet =
        'AaBbCcÇçDdEeFfGgĞğHhIıİiJjKkLlMmNnOoÖöPpRrSsŞşTtUuÜüVvYyZz';

    int turkishCompare(String a, String b) {
      for (int i = 0; i < a.length && i < b.length; i++) {
        final ai = turkishAlphabet.indexOf(a[i]);
        final bi = turkishAlphabet.indexOf(b[i]);
        if (ai != bi) return ai.compareTo(bi);
      }
      return a.length.compareTo(b.length);
    }

    words.sort((a, b) => turkishCompare(a.word, b.word));
    return words;
  }
}
