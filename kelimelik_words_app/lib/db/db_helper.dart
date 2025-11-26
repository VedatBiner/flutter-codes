// 📃 <----- db_helper.dart ----->
// Tüm veri tabanı işlemleri
// Tüm CSV JSON işlemleri
// Türkçe harflere göre sıralama metodu burada tanımlanıyor
//

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

/// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../models/item_model.dart';
import '../services/notification_service.dart';

class DbHelper {
  // Singleton pattern: Sınıfın tek bir örneği olmasını sağlar.
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  /// Veritabanı örneğini döndürür.
  /// Eğer veritabanı daha önce oluşturulmamışsa, `_initDB` ile başlatır.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(fileNameSql);
    return _database!;
  }

  /// Veritabanını cihazda başlatır.
  /// Uygulamanın belge dizininde veritabanı dosyasını açar veya oluşturur.
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Veritabanı ilk kez oluşturulduğunda `words` tablosunu yaratır.
  /// `word` sütunu, aynı kelimenin tekrar eklenmesini önlemek için UNIQUE'dir.
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $sqlTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL UNIQUE,
        meaning TEXT NOT NULL
      )
    ''');
  }

  /// Veritabanı dosyasını diskten tamamen siler.
  /// Önce veritabanı bağlantısını kapatır, sonra dosyayı siler.
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, fileNameSql);

    // Veritabanı bağlantısını güvenle kapat
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    // Veritabanı dosyasını fiziksel olarak sil
    if (await File(path).exists()) {
      await File(path).delete();
      log('Veritabanı dosyası silindi: $path', name: 'DbHelper');
    }
  }

  /// Veritabanındaki tüm kelime kayıtlarını alır ve Türkçe'ye göre sıralar.
  Future<List<Word>> getRecords() async {
    final db = await instance.database;
    final result = await db.query(sqlTableName);
    final words = result.map((e) => Word.fromMap(e)).toList();
    return _sortTurkish(words); // Türkçe karakterlere göre sıralama uygula
  }

  /// Belirli bir kelimeyi adına göre veritabanında arar.
  Future<Word?> getItem(String word) async {
    final db = await instance.database;
    final result = await db.query(
      sqlTableName,
      where: 'word = ?',
      whereArgs: [word],
    );
    return result.isNotEmpty ? Word.fromMap(result.first) : null;
  }

  /// Veritabanına yeni bir kelime ekler.
  Future<int> insertRecord(Word word) async {
    final db = await instance.database;
    return await db.insert(sqlTableName, word.toMap());
  }

  /// Var olan bir kelimeyi ID'sine göre günceller.
  Future<int> updateRecord(Word word) async {
    final db = await instance.database;
    return await db.update(
      sqlTableName,
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  /// Belirtilen ID'ye sahip kelimeyi veritabanından siler.
  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete(sqlTableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Veritabanındaki toplam kayıt sayısını döndürür.
  Future<int> countRecords() async {
    final db = await instance.database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $sqlTableName'),
    );
    return result ?? 0;
  }

  /// Veritabanındaki tüm kayıtları bir JSON dosyasına aktarır.
  /// Dosyayı uygulamanın belge dizinine kaydeder ve dosya yolunu döndürür.
  Future<String> exportRecordsToJson() async {
    final words = await getRecords();
    final wordMaps = words.map((w) => w.toMap()).toList();
    final jsonString = jsonEncode(wordMaps);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameJson';
    final file = File(filePath);
    await file.writeAsString(jsonString);
    return filePath;
  }

  /// Bir JSON dosyasından veritabanına kayıtları geri yükler.
  /// Önce mevcut tüm kayıtları siler, sonra JSON 'daki kayıtları ekler.
  Future<void> importRecordsFromJson(BuildContext context) async {
    const tag = 'db_helper';
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameJson';
      final file = File(filePath);

      if (!(await file.exists())) {
        log('❌ Yedek dosyası bulunamadı: $filePath', name: tag);
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
      await db.delete(sqlTableName); // Önce eski kayıtları temizle
      for (var item in jsonList) {
        final word = Word.fromMap(item);
        await insertRecord(word);
      }

      log(
        '✅ JSON yedeği başarıyla yüklendi. (${jsonList.length} kayıt)',
        name: tag,
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
      log('🚨 Geri yükleme hatası: $e', name: tag);
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

  /// Veritabanındaki tüm kayıtları bir CSV dosyasına aktarır.
  Future<String> exportRecordsToCsv() async {
    final words = await DbHelper.instance.getRecords();
    final buffer = StringBuffer();
    buffer.writeln('Kelime,Anlam'); // Başlık satırı
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

  /// Bir CSV dosyasından veritabanına kayıtları geri yükler.
  /// Önce mevcut kayıtları siler, sonra CSV'deki kayıtları ekler.
  Future<void> importRecordsFromCsv() async {
    const tag = 'db_helper';
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameCsv';
      final file = File(filePath);

      if (!(await file.exists())) {
        log('❌ CSV dosyası bulunamadı: $filePath', name: tag);
        return;
      }

      final lines = await file.readAsLines();
      if (lines.isEmpty) {
        log('❌ CSV dosyası boş.', name: tag);
        return;
      }

      final db = await database;
      await db.delete(sqlTableName); // Eski kayıtları temizle
      int count = 0;
      for (int i = 1; i < lines.length; i++) {
        // İlk satır başlık olduğu için atla
        final line = lines[i].trim();
        if (line.isEmpty) continue;
        final parts = line.split(',');
        if (parts.length < 2) continue;
        final kelime = parts[0].trim();
        final anlam = parts.sublist(1).join(',').trim();
        if (kelime.isNotEmpty && anlam.isNotEmpty) {
          final word = Word(word: kelime, meaning: anlam);
          await insertRecord(word);
          count++;
        }
      }

      log('✅ CSV yedeği başarıyla yüklendi. ($count kayıt)', name: tag);
      log('📂 CSV dosya konumu: $filePath', name: tag);
    } catch (e) {
      log('🚨 CSV yükleme hatası: $e', name: tag);
    }
  }

  /// Kelime listesini Türkçe alfabe kurallarına göre sıralar.
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

  /// Büyük bir kelime listesini veritabanına hızlı bir şekilde ekler.
  /// Yinelenen kayıtları (`UNIQUE` kısıtlaması sayesinde) göz ardı eder.
  Future<void> insertBatch(List<Word> items) async {
    if (items.isEmpty) return;
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final item in items) {
        batch.insert(
          sqlTableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      await batch.commit(noResult: true, continueOnError: true);
    });
  }

  Future<void> closeDb() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
    }
    _database = null;
  }
}
