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
    final path = join(dbPath, 'ser_tr_dict.db');

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
      // Aynı verinin zaten olup olmadığını kontrol et
      final existingData = await db.query(
        'words',
        where: 'sirpca = ? AND turkce = ? AND userEmail = ?',
        whereArgs: [item['sirpca'], item['turkce'], item['userEmail']],
      );

      if (existingData.isEmpty) {
        // Eğer veri yoksa ekle
        await db.insert('words', {
          'sirpca': item['sirpca'],
          'turkce': item['turkce'],
          'userEmail': item['userEmail'],
        });
      } else {
        print("⚠️ Bu veri zaten var: ${item['sirpca']} - ${item['turkce']}");
      }
    }

    print("Veriler SQLite veritabanına eklendi.");
  }

  /// 📌 **Bu yeni metodu ekledik!**
  Future<void> resetDatabase() async {
    final db = await instance.database;
    await db.delete('words'); // Veritabanındaki tüm verileri siler
    print("🗑️ Veritabanı sıfırlandı!");
  }

  /// 📌 **Bu yeni metodu ekledik!**
  Future<void> insertSingleItem(Map<String, dynamic> item) async {
    final db = await instance.database;

    await db.insert(
      'words',
      {
        'sirpca': item['sirpca'],
        'turkce': item['turkce'],
        'userEmail': item['userEmail'],
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // Tekrar eden verileri önlemek için
    );

    print("📥 Tekil veri eklendi: ${item['sirpca']} - ${item['turkce']}");
  }


}
