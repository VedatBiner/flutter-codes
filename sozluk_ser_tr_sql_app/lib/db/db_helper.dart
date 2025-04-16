// 📃 <----- db_helper.dart ----->
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

import '../constants/file_info.dart';
import '../models/word_model.dart';
import '../providers/word_count_provider.dart';
import '../widgets/notification_service.dart';

class WordDatabase {
  static final WordDatabase instance = WordDatabase._init();
  static Database? _database;

  WordDatabase._init();

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
        sirpca TEXT NOT NULL,
        turkce TEXT NOT NULL,
        userEmail TEXT NOT NULL
      )
    ''');
  }

  /// 📌 Tüm kelimeleri alır.
  ///
  Future<List<Word>> getWords() async {
    final db = await instance.database;
    final result = await db.query('words'); // OrderBy kaldırıldı
    final words = result.map((e) => Word.fromMap(e)).toList();

    return _sortSerbian(words); // 👈 Sırpça sıralamayı uygula
  }

  /// 📌 Kelimeyi aramak için kullanılır.
  ///
  Future<Word?> getWord(String word) async {
    final db = await instance.database;
    final result = await db.query(
      'words',
      where: 'sirpca = ?',
      whereArgs: [word],
    );
    return result.isNotEmpty ? Word.fromMap(result.first) : null;
  }

  /// 📌 Yeni kelimeyi ekler.
  ///
  Future<int> insertWord(Word word) async {
    final db = await instance.database;
    final result = await db.insert('words', word.toMap());

    // ✅ Kelime sayısını güncelle
    WordCountProvider().updateCount(); // Bu çalışmaz çünkü context yok

    return result;
  }

  /// 📌 ID ye göre kelimeyi günceller.
  ///
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

  /// 📌 Toplam kelime sayısını döner.
  ///
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
    final words = await getWords();
    final wordMaps = words.map((w) => w.toMap()).toList();
    final jsonString = jsonEncode(wordMaps);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameJson';

    final file = File(filePath);
    await file.writeAsString(jsonString);

    log('📤 JSON yedeği başarıyla oluşturuldu.', name: 'Backup');
    log('📁 Dosya yolu: $filePath', name: 'Backup');

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
    }
  }

  /// 📌 CSV yedeği burada alınıyor.
  ///
  Future<String> exportWordsToCsv() async {
    final words = await getWords();
    final buffer = StringBuffer();

    buffer.writeln('Sirpca,Turkce');

    for (var word in words) {
      final kelime = word.sirpca.replaceAll(',', '');
      final anlam = word.turkce.replaceAll(',', '');
      buffer.writeln('$kelime,$anlam');
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameCsv';
    final file = File(filePath);

    await file.writeAsString(buffer.toString());

    log('📤 CSV yedeği başarıyla oluşturuldu.', name: 'Backup');
    log('📁 Dosya yolu: $filePath', name: 'Backup');

    return filePath;
  }

  /// 📌 CSV yedeği burada geri yükleniyor.
  ///
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

      final db = await database;
      await db.delete('words');

      int count = 0;
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split(',');
        if (parts.length < 2) continue;

        final kelime = parts[0].trim();
        final anlam = parts.sublist(1).join(',').trim();

        final word = Word(
          sirpca: kelime,
          turkce: anlam,
          userEmail: 'default@email.com',
        );

        await insertWord(word);
        count++;
      }

      log('✅ CSV yedeği başarıyla yüklendi. ($count kayıt)', name: 'Import');
    } catch (e) {
      log('🚨 CSV yükleme hatası: $e', name: 'Import');
    }
  }

  /// 📌 Türkçe sıralama yöntemi.
  ///
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

    words.sort((a, b) => turkishCompare(a.sirpca, b.sirpca));
    return words;
  }

  /// 📌 Sırpça sıralama yöntemi.
  ///
  List<Word> _sortSerbian(List<Word> words) {
    const serbianAlphabet = [
      'A',
      'a',
      'B',
      'b',
      'C',
      'c',
      'Č',
      'č',
      'Ć',
      'ć',
      'D',
      'd',
      'Dž',
      'dž',
      'Đ',
      'đ',
      'E',
      'e',
      'F',
      'f',
      'G',
      'g',
      'H',
      'h',
      'I',
      'i',
      'J',
      'j',
      'K',
      'k',
      'L',
      'l',
      'Lj',
      'lj',
      'M',
      'm',
      'N',
      'n',
      'Nj',
      'nj',
      'O',
      'o',
      'P',
      'p',
      'R',
      'r',
      'S',
      's',
      'Š',
      'š',
      'T',
      't',
      'U',
      'u',
      'V',
      'v',
      'Z',
      'z',
      'Ž',
      'ž',
    ];

    int serbianCompare(String a, String b) {
      int i = 0;
      while (i < a.length && i < b.length) {
        String aChar = a[i];
        String bChar = b[i];

        // Özel ikili harf kontrolleri (Dž, Lj, Nj)
        if (i + 1 < a.length) {
          final doubleChar = a.substring(i, i + 2);
          if (serbianAlphabet.contains(doubleChar)) {
            aChar = doubleChar;
          }
        }

        if (i + 1 < b.length) {
          final doubleChar = b.substring(i, i + 2);
          if (serbianAlphabet.contains(doubleChar)) {
            bChar = doubleChar;
          }
        }

        final ai = serbianAlphabet.indexOf(aChar);
        final bi = serbianAlphabet.indexOf(bChar);

        if (ai != bi) return ai.compareTo(bi);

        i += aChar.length; // Tek veya çift harf olabilir
      }

      return a.length.compareTo(b.length);
    }

    words.sort((a, b) => serbianCompare(a.sirpca, b.sirpca));
    return words;
  }
}
