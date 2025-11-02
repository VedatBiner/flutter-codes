// 📃 <----- lib/db/db_helper.dart ----->
//
// 🎬 Netflix Film List App — Sqflite Yardımcısı
//
// Özellikler
// ----------
// • Veritabanı: netflix_list.db (file_info.dart içindeki fileNameSql)
// • Tablo: netflixItems (sqlTableName)
// • Şema:
//      id                INTEGER PRIMARY KEY AUTOINCREMENT
//      netflixItemName   TEXT    NOT NULL
//      watchDate         TEXT
//   + UNIQUE(netflixItemName, watchDate)  -- yinelenenleri önler
//
// • Performans:
//   - onConfigure: WAL, synchronous=NORMAL, foreign_keys=ON
//   - Batch ekleme (insertBatch) — hızlı toplu import
//
// • API:
//   - Future<List<NetflixItem>> getRecords()
//   - Future<NetflixItem?> getItemByName(String name)
//   - Future<int> insertRecord(NetflixItem item)
//   - Future<int> updateRecord(NetflixItem item)
//   - Future<int> deleteRecord(int id)
//   - Future<int> countRecords()
//   - Future<void> insertBatch(List<NetflixItem> items)
//
// Not:
//  initializeAppDataFlow() (file_creator.dart) veritabanı yoksa CSV→JSON→Excel→SQL
//  akışını başlatır. Veritabanı zaten varsa yeniden oluşturmuyor.
//
// ---------------------------------------------------------------

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/file_info.dart';
import '../models/item_model.dart';

class DbHelper {
  DbHelper._init();
  static final DbHelper instance = DbHelper._init();

  static Database? _database;

  /// ➤ Singleton DB örneği
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(fileNameSql);
    return _database!;
  }

  /// ➤ DB açılışı + performans ayarları
  Future<Database> _initDB(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        // YERİ: onConfigure (doğru yer burası)
        await db.execute('PRAGMA foreign_keys = ON'); // execute OK
        await db.rawQuery('PRAGMA journal_mode = WAL'); // ✅ rawQuery kullan
      },
      onCreate: _createDB,
    );
  }

  /// ➤ İlk kurulumda tablo + indeks oluşturma
  Future<void> _createDB(Database db, int version) async {
    // Temel tablo
    await db.execute('''
      CREATE TABLE $sqlTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        netflixItemName TEXT NOT NULL,
        watchDate TEXT
      );
    ''');

    // Yinelenenleri önlemek için eşsiz indeks
    await db.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_items_unique
      ON $sqlTableName (netflixItemName, watchDate);
    ''');

    // Hızlı arama için isim indeks (opsiyonel ama iyi)
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_items_name
      ON $sqlTableName (netflixItemName);
    ''');
  }

  // ----------------------------------------------------------------------
  // 🔎 Okuma
  // ----------------------------------------------------------------------

  /// Tüm kayıtları getirir (Türkçe sıralamayı uygulama tarafında yapar)
  Future<List<NetflixItem>> getRecords() async {
    final db = await database;
    final result = await db.query(sqlTableName);

    final items = result.map((e) => NetflixItem.fromMap(e)).toList();

    // Türkçe sıralama (uygulama tarafında)
    return _sortTurkish(items);
  }

  /// İsme göre tek kayıt
  Future<NetflixItem?> getItemByName(String name) async {
    final db = await database;
    final result = await db.query(
      sqlTableName,
      where: 'netflixItemName = ?',
      whereArgs: [name],
      limit: 1,
    );
    return result.isNotEmpty ? NetflixItem.fromMap(result.first) : null;
  }

  /// Kayıt sayısı
  Future<int> countRecords() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $sqlTableName'),
    );
    return count ?? 0;
  }

  // ----------------------------------------------------------------------
  // ✍️ Yazma / Güncelleme / Silme
  // ----------------------------------------------------------------------

  /// Tekli ekleme (UNIQUE çakışmalarını yok sayar)
  Future<int> insertRecord(NetflixItem item) async {
    final db = await database;
    return db.insert(
      sqlTableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore, // duplicate varsa atla
    );
  }

  /// Güncelleme (id ile)
  Future<int> updateRecord(NetflixItem item) async {
    if (item.id == null) return 0;
    final db = await database;
    return db.update(
      sqlTableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Silme (id ile)
  Future<int> deleteRecord(int id) async {
    final db = await database;
    return db.delete(sqlTableName, where: 'id = ?', whereArgs: [id]);
  }

  // ----------------------------------------------------------------------
  // 🚀 Hızlı Toplu Ekleme (Batch)
  // ----------------------------------------------------------------------

  /// Büyük listeleri hızlı eklemek için toplu insert.
  /// UNIQUE (netflixItemName, watchDate) sayesinde yinelenenler otomatik atlanır.
  Future<void> insertBatch(List<NetflixItem> items) async {
    if (items.isEmpty) return;

    final db = await database;

    // Daha da hızlı: Transaction + Batch
    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final item in items) {
        batch.insert(
          sqlTableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      // NoResult → bellek kullanımını azaltır
      await batch.commit(noResult: true, continueOnError: true);
    });
  }

  // ----------------------------------------------------------------------
  // 🧹 İsteğe Bağlı Yardımcılar
  // ----------------------------------------------------------------------

  /// Tüm tabloyu temizler (dikkat!)
  Future<void> clearAll() async {
    final db = await database;
    await db.delete(sqlTableName);
  }

  /// DB dosya yolunu getir (debug için yararlı)
  Future<String> getDatabasePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return join(dir.path, fileNameSql);
  }

  // ----------------------------------------------------------------------
  // 🇹🇷 Türkçe Sıralama (uygulama tarafı)
  // ----------------------------------------------------------------------

  List<NetflixItem> _sortTurkish(List<NetflixItem> items) {
    const alphabet =
        'AaBbCcÇçDdEeFfGgĞğHhIıİiJjKkLlMmNnOoÖöPpRrSsŞşTtUuÜüVvYyZz';

    int tcmp(String a, String b) {
      final la = a.length, lb = b.length;
      final min = la < lb ? la : lb;
      for (int i = 0; i < min; i++) {
        final ai = alphabet.indexOf(a[i]);
        final bi = alphabet.indexOf(b[i]);
        if (ai != bi) return ai.compareTo(bi);
      }
      return la.compareTo(lb);
    }

    items.sort((a, b) => tcmp(a.netflixItemName, b.netflixItemName));
    return items;
  }
}
