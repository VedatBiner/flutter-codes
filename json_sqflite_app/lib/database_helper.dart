import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_data.db');

    print("📂 SQLite veritabanı konumu: $path"); // Veritabanı yolunu yazdır

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE words (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sirpca TEXT,
            turkce TEXT,
            userEmail TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await instance.database;
    return await db.query('words');
  }

  Future<void> insertDataFromJson(List<dynamic> jsonData) async {
    final db = await instance.database;
    for (var item in jsonData) {
      await db.insert('words', {
        'sirpca': item['sirpca'],
        'turkce': item['turkce'],
        'userEmail': item['userEmail'],
      });
    }
    print("Veriler SQLite veritabanına eklendi.");
  }
}
