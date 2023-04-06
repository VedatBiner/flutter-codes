import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/model.dart';

abstract class DBHelper {
  static Database? _db;

  static int get _version => 1;

  // Database oluşturma
  static Future<void> init() async {
    if (_db != null) {
      return;
    }
    try {
      var databasePath = await getDatabasesPath();
      String _path = p.join(databasePath, 'flutter_sqflite.db');
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) async {
          await db.execute(
              'CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < newVersion) {
            await db.execute('ALTER TABLE users ADD COLUMN email TEXT');
          }
        },
      );
    } catch (ex) {
      print(ex);
    }
  }

  // tablo oluşturma metodu
  static void onCreate(Database db, int version) async {
    String sqlQuery =
        'CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, productName STRING, categoryId INTEGER, productDesc STRING, price REAL, productPic STRING)';
    await db.execute(sqlQuery);
  }

  static void onUpgrade(Database db, int oldVersion, int version) async {
    if (oldVersion > version) {
      // daha sonra gerekebilir.
    }
  }

  // SQL tablodan veri çekecek metot
  static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db!.query(table);
  }

  // Veri ekleme metodu
  static Future<int> insert(String table, Model model) async {
    return await _db!.insert(table, model.toJson());
  }

  // veri güncelleme metodu
  static Future<int> update(String table, Model model) async {
    return await _db!.update(
      table,
      model.toJson(),
      where: 'id=?',
      whereArgs: [model.id],
    );
  }

  // veri silme metodu
  static Future<int> delete(String table, Model model) async {
    return await _db!.delete(
      table,
      where: 'id=?',
      whereArgs: [model.id],
    );
  }

}
