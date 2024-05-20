/// <----- database_helper.dart ----->
///
library;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "notes.db";

  /// veri tabanı yoksa oluşturalım
  /// varsa açalım
  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => await db.execute(
        '''
          CREATE TABLE note(
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL 
        );''',
      ),
      version: _version,
    );
  }

  /// Create
  static Future<int> addNote(Note note) async {
    final db = await _getDB();
    return await db.insert(
      "note",
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update
  static Future<int> updateNote(Note note) async {
    final db = await _getDB();
    return await db.update(
      "note",
      note.toJson(),
      where: "id = ?",
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Delete
  static Future<int> deleteNote(Note note) async {
    final db = await _getDB();
    return await db.delete(
      "note",
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  /// Bütün kayıtları oku
  static Future<List<Note>?> getAllNotes() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query("note");

    /// veri yoksa
    if (maps.isEmpty) {
      return null;
    }

    /// veri varsa
    return List.generate(
      maps.length,
      (index) => Note.fromJson(maps[index]),
    );
  }
}
