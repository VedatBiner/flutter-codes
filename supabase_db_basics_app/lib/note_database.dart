/// <----- note_database.dart ----->
///

library;

import 'package:supabase_flutter/supabase_flutter.dart';

import 'note.dart';

class NoteDatabase {
  /// Database -> otes
  final database = Supabase.instance.client.from("notes");

  /// Create
  Future createNote(Note newNote) async {
    await database.insert(newNote.toMap()).select();
  }

  /// Read
  final stream = Supabase.instance.client
      .from("notes")
      .stream(primaryKey: ["id"])
      .order("id", ascending: false)
      .map((data) => data.map((noteMap) => Note.fromMap(noteMap)).toList());

  /// Update
  Future updateNote(Note oldNote, String newContent) async {
    await database.update({"content": newContent}).eq("id", oldNote.id!);
  }

  /// Delete
  Future deleteNote(Note note) async {
    await database.delete().eq("id", note.id!);
  }
}
