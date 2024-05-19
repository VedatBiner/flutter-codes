/// <----- app_database.dart ----->
library;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_crud_3/models/task.dart';

/// veri tabanımızın adı
const String fileName = "tasks_database.db";

class AppDatabase {
  AppDatabase._init();
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  /// veritabanının başlatılıp, başlatılmadığının kontrolü
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB(fileName);
    return _database!;
  }

  /// veri tabanı oluşturan metot
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $idField $idType,
        $titleField $textType,
        $descriptionField $textTypeNullable,
        $dueDateField $textType,
        $taskTypeField $textType,
        $isDoneField $boolType,
      )
    ''');
  }

  Future<Database> _initializeDB(String fileName) async {
    /// veri tabanı yolunu alalım
    final dbPath = await getDatabasesPath();

    /// dosya konumunu alalım
    final path = join(dbPath, fileName);

    /// veri tabanını açalım
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// yeni task oluşturan metot
  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert(tableName, task.toJson());
    return task.copyWith(id: id);
  }

  /// bütün taskları okuyan metot
  Future<List<Task?>> readAllTask() async {
    final db = await instance.database;
    final result = await db.query(tableName, orderBy: "$dueDateField DESC");

    /// verileri listeye dönüştürüyoruz.
    return result.map((json) => Task.fromJson(json)).toList();
  }

  /// veri tabanını kapatalım
  Future<void> close() async {
    final db = await instance.database;
    return db.close();
  }

  /// update database
  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update(
      tableName,
      task.toJson(),
      where: "$idField = ?",
      whereArgs: [task.id],
    );
  }

  /// delete record
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableName,
      where: "$idField = ?",
      whereArgs: [id],
    );
  }
}
