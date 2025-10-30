// 📃 <----- word_database.dart ----->
// Tüm veri tabanı işlemleri
// Tüm CSV JSON işlemleri
// Türkçe harflere göre sıralama metodu burada tanımlanıyor
//

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/file_info.dart';
import '../../models/item_model.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  /// 📌 Veritabanı örneğini getirir (singleton)
  ///
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(fileNameSql);
    return _database!;
  }

  /// 📌 Veritabanını başlatır veya oluşturur
  ///
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// 📌 Yeni bir veritabanı oluşturur.
  ///
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $sqlTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        netflixItemName TEXT NOT NULL,
        watchDate TEXT
      )
    ''');
  }

  /// 📌 Tüm kayıtları alır.
  ///
  Future<List<NetflixItem>> getRecords() async {
    final db = await instance.database;
    final result = await db.query(sqlTableName);
    final items = result.map((e) => NetflixItem.fromMap(e)).toList();

    return _sortTurkish(items); // 👈 Türkçe sıralamayı uygula
  }

  /// 📌 Tek bir kaydı isme göre aramak için kullanılır.
  ///
  Future<NetflixItem?> getItemByName(String name) async {
    final db = await instance.database;
    final result = await db.query(
      sqlTableName,
      where: 'netflixItemName = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty ? NetflixItem.fromMap(result.first) : null;
  }

  /// 📌 Yeni kaydı ekler.
  ///
  Future<int> insertRecord(NetflixItem item) async {
    final db = await instance.database;
    return await db.insert(sqlTableName, item.toMap());
  }

  /// 📌 ID’ye göre kaydı günceller.
  ///
  Future<int> updateRecord(NetflixItem item) async {
    final db = await instance.database;
    return await db.update(
      sqlTableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  /// 📌 ID ’ye göre kaydı siler.
  ///
  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete(sqlTableName, where: 'id = ?', whereArgs: [id]);
  }

  /// 📌 Kelimeyi aramak için kullanılır.
  ///
  Future<NetflixItem?> getItem(String netflixItemName) async {
    final db = await instance.database;
    final result = await db.query(
      'words',
      where: 'word = ?',
      whereArgs: [netflixItemName],
    );
    return result.isNotEmpty ? NetflixItem.fromMap(result.first) : null;
  }

  /// 📌 Kayıt sayısını döndürür.
  ///
  Future<int> countRecords() async {
    final db = await instance.database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $sqlTableName'),
    );
    return result ?? 0;
  }

  /// 📌 JSON yedeği burada alınıyor.
  ///
  Future<String> exportRecordsToJson() async {
    final items = await getRecords(); // tüm kayıtları al
    final itemMaps = items.map((i) => i.toMap()).toList();
    final jsonString = jsonEncode(itemMaps);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameJson';

    final file = File(filePath);
    await file.writeAsString(jsonString);

    return filePath;
  }

  /// 📌 JSON yedeği burada geri yükleniyor.
  ///
  // Future<void> importRecordsFromJson(BuildContext context) async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final filePath = '${directory.path}/$fileNameJson';
  //     final file = File(filePath);
  //
  //     if (!(await file.exists())) {
  //       log('❌ Yedek dosyası bulunamadı: $filePath', name: 'Db_helper');
  //
  //       if (context.mounted) {
  //         NotificationService.showCustomNotification(
  //           context: context,
  //           title: 'Dosya Bulunamadı',
  //           message: const Text('JSON yedek dosyası bulunamadı.'),
  //           icon: Icons.error_outline,
  //           iconColor: Colors.red,
  //           progressIndicatorColor: Colors.red,
  //           progressIndicatorBackground: Colors.red.shade100,
  //         );
  //       }
  //       return;
  //     }
  //
  //     final jsonString = await file.readAsString();
  //     final List<dynamic> jsonList = jsonDecode(jsonString);
  //
  //     final db = await database;
  //     await db.delete($sqlTableName);
  //
  //     for (var item in jsonList) {
  //       final record = NetflixItem.fromMap(item);
  //       await insertRecord(record);
  //     }
  //
  //     log('✅ JSON yedeği başarıyla yüklendi. (${jsonList.length} kayıt)', name: 'Db_helper');
  //
  //   } catch (e) {
  //     log('🚨 Geri yükleme hatası: $e', name: 'Db_helper');
  //   }
  // }

  /// 📌 CSV yedeği burada alınıyor.
  ///
  Future<String> exportRecordsToCsv() async {
    final items = await DbHelper.instance.getRecords();
    final buffer = StringBuffer();

    buffer.writeln('İsim,İzlenme Tarihi');

    for (var item in items) {
      final name = item.netflixItemName.replaceAll(',', '');
      final date = item.watchDate.replaceAll(',', '');
      buffer.writeln('$name,$date');
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameCsv';
    final file = File(filePath);

    await file.writeAsString(buffer.toString());

    return filePath;
  }

  /// 📌 Türkçe sıralama yöntemi.
  List<NetflixItem> _sortTurkish(List<NetflixItem> items) {
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

    items.sort((a, b) => turkishCompare(a.netflixItemName, b.netflixItemName));
    return items;
  }
}
