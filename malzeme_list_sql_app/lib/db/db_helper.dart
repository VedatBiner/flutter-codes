// 📃 <----- db_helper.dart ----->
// Tüm veri tabanı işlemleri
// Tüm CSV ve JSON işlemleri
// Türkçe harflere göre sıralama metodu burada tanımlanıyor

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/file_info.dart';
import '../models/malzeme_model.dart';
import '../widgets/notification_service.dart';

class MalzemeDatabase {
  /// Singleton örnek
  static final MalzemeDatabase instance = MalzemeDatabase._init();
  static Database? _database;

  MalzemeDatabase._init();

  /// 📌 SQLite veritabanı örneğini döndürür (oluşturulmamışsa oluşturur).
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(fileNameSql);
    return _database!;
  }

  /// 📌 SQLite dosyasını oluşturur ve konumlandırır.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    log('📁 SQLite veritabanı konumu: $path');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// 📌 Veritabanında "malzemeler" tablosunu oluşturur.
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE malzemeler (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        malzeme TEXT NOT NULL,
        miktar INTEGER
      )
    ''');
  }

  /// 📌 Tüm malzemeleri getirir ve Türkçe 'ye göre sıralar.
  Future<List<Malzeme>> getWords() async {
    final db = await instance.database;
    final result = await db.query('malzemeler');
    final malzemeler = result.map((e) => Malzeme.fromMap(e)).toList();
    return _sortTurkish(malzemeler);
  }

  /// 📌 Belirli bir malzeme adına göre arama yapar.
  Future<Malzeme?> getWord(String malzeme) async {
    final db = await instance.database;
    final result = await db.query(
      'malzemeler',
      where: 'malzeme = ?',
      whereArgs: [malzeme],
    );
    return result.isNotEmpty ? Malzeme.fromMap(result.first) : null;
  }

  /// 📌 Yeni malzeme ekler.
  Future<int> insertWord(Malzeme malzeme) async {
    final db = await instance.database;
    return await db.insert('malzemeler', malzeme.toMap());
  }

  /// 📌 ID 'ye göre malzeme günceller.
  Future<int> updateWord(Malzeme malzeme) async {
    final db = await instance.database;
    return await db.update(
      'malzemeler',
      malzeme.toMap(),
      where: 'id = ?',
      whereArgs: [malzeme.id],
    );
  }

  /// 📌 ID 'ye göre malzeme siler.
  Future<int> deleteWord(int id) async {
    final db = await instance.database;
    return await db.delete('malzemeler', where: 'id = ?', whereArgs: [id]);
  }

  /// 📌 Toplam malzeme sayısını döndürür.
  Future<int> countWords() async {
    final db = await instance.database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM malzemeler'),
    );
    return result ?? 0;
  }

  /// 📌 Tüm veriyi JSON formatında dışa aktarır.
  Future<String> exportWordsToJson() async {
    final malzemeler = await getWords();
    final wordMaps = malzemeler.map((w) => w.toMap()).toList();
    final jsonString = jsonEncode(wordMaps);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameJson';
    final file = File(filePath);
    await file.writeAsString(jsonString);

    log('📤 JSON yedeği başarıyla oluşturuldu.', name: 'Backup');
    log('📁 Dosya yolu: $filePath', name: 'Backup');
    return filePath;
  }

  /// 📌 JSON yedeğini içe aktarır.
  Future<void> importWordsFromJson(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameJson';
      final file = File(filePath);

      if (!(await file.exists())) {
        log('❌ JSON dosyası bulunamadı: $filePath', name: 'Import');
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
      await db.delete('malzemeler');

      for (var item in jsonList) {
        final malzeme = Malzeme.fromMap(item);
        await insertWord(malzeme);
      }

      log(
        '✅ JSON yedeği başarıyla yüklendi. (${jsonList.length} kayıt)',
        name: 'Import',
      );
      if (context.mounted) {
        NotificationService.showCustomNotification(
          context: context,
          title: 'JSON Yedeği Yüklendi',
          message: Text('${jsonList.length} malzeme başarıyla yüklendi.'),
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

  /// 📌 Veritabanını CSV formatında dışa aktarır.
  Future<String> exportWordsToCsv() async {
    final words = await getWords();
    final buffer = StringBuffer();
    buffer.writeln('Malzeme,Miktar');

    for (var word in words) {
      final kelime = word.malzeme.replaceAll(',', '');
      final miktar = (word.miktar ?? '').toString().replaceAll(',', '');
      buffer.writeln('$kelime,$miktar');
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameCsv';
    final file = File(filePath);
    await file.writeAsString(buffer.toString());

    log('📤 CSV yedeği başarıyla oluşturuldu.', name: 'Backup');
    log('📁 CSV dosya yolu: $filePath', name: 'Backup');
    return filePath;
  }

  /// 📌 CSV yedeğini içe aktarır.
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
      await db.delete('malzemeler');

      int count = 0;
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split(',');
        if (parts.length < 2) continue;

        final malzeme = parts[0].trim();
        final miktarStr = parts[1].trim();
        final miktar = int.tryParse(miktarStr) ?? 0;

        if (malzeme.isNotEmpty) {
          final word = Malzeme(malzeme: malzeme, miktar: miktar);
          await insertWord(word);
          count++;
        }
      }

      log('✅ CSV yedeği başarıyla yüklendi. ($count kayıt)', name: 'Import');
      log('📂 CSV dosya konumu: $filePath', name: 'Import');
    } catch (e) {
      log('🚨 CSV yükleme hatası: $e', name: 'Import');
    }
  }

  /// 📌 Türkçe alfabe sıralamasına göre liste sıralar.
  List<Malzeme> _sortTurkish(List<Malzeme> malzemeler) {
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

    malzemeler.sort((a, b) => turkishCompare(a.malzeme, b.malzeme));
    return malzemeler;
  }
}
