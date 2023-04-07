import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo_model.dart';

class DatabaseConnect {
  Database? _database;

  // veritabanını açmak için bir getter
  Future<Database> get database async {
    final dbpath = await getDatabasesPath();
    const dbname = 'todo.db';
    final path = join(dbpath, dbname);
    // veritabanına ilk erişim
    _database = await openDatabase(path, version: 1, onCreate: _creteDB);
    return _database!;
  }

  // tablo oluşturuluyor.
  Future<void> _creteDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        creationDate TEXT,
        isChecked INTEGER
        )
    ''');
  }

  // Veri ekleme fonksiyonu
  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    print(todo.creationDate);
    await db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Veri silme fonksiyonu
  Future<void> deleteTodo(Todo todo) async {
    final db = await database;
    await db.delete(
      'todo',
      where: 'id == ?',
      whereArgs: [todo.id],
    );
  }

  // listeleme fonksiyonu
  Future<List<Todo>> getTodo() async {
    final db = await database;
    List<Map<String, dynamic>> items = await db.query(
      'todo',
      orderBy: 'id DESC',
    );
    return List.generate(
      items.length,
      (i) => Todo(
        id: items[i]['id'],
        title: items[i]['title'],
        creationDate: DateTime.parse(items[i]['creationDate']),
        isChecked: items[i]['isChecked'] == 1
            ? true
            : false,
      ),
    );
  }
}
