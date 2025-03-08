/// <----- note_page.dart ----->
///

library;

import 'package:flutter/material.dart';

import 'note.dart';
import 'note_database.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  /// notes db
  final notesDatabase = NoteDatabase();

  /// text controller
  final noteController = TextEditingController();

  /// add new note
  void addNewNote() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Add new note"),
            content: TextField(
              controller: noteController,
              decoration: const InputDecoration(hintText: "Enter Note"),
            ),

            /// buttons
            actions: [
              /// Cancel
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  noteController.clear();
                },
                child: const Text("Cancel"), //
              ),

              /// Save
              TextButton(
                onPressed: () {
                  /// create a new note
                  final newNote = Note(content: noteController.text);

                  /// save note
                  notesDatabase.createNote(newNote);

                  noteController.clear();
                  Navigator.pop(context);
                },
                child: const Text("Save"), //
              ),
            ],
          ),
    );
  }

  /// update note
  void updateNote(Note note) {
    noteController.text = note.content;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Update note"),
            content: TextField(
              controller: noteController,
              decoration: const InputDecoration(hintText: "Update Note"),
            ),

            /// buttons
            actions: [
              /// Cancel
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  noteController.clear();
                },
                child: const Text("Cancel"), //
              ),

              /// Save in DB
              TextButton(
                onPressed: () {
                  /// create a new note
                  final newNote = Note(content: noteController.text);

                  /// update note
                  notesDatabase.updateNote(note, noteController.text);

                  /// UI'ı güncelle
                  setState(() {});

                  noteController.clear();
                  Navigator.pop(context);
                },
                child: const Text("Save"), //
              ),
            ],
          ),
    );
  }

  /// delete note
  void deleteNote(Note note) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("delete note?"),

            /// buttons
            actions: [
              /// Cancel
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                  noteController.clear();
                },
                child: const Text("Cancel"), //
              ),

              /// Delete note
              TextButton(
                onPressed: () async {
                  /// delete note
                  await notesDatabase.deleteNote(note);

                  /// UI'ı güncelle
                  noteController.clear();
                  Navigator.pop(context, true);
                },
                child: const Text("Delete"), //
              ),
            ],
          ),
    );
    if (confirmDelete == true) {
      await notesDatabase.deleteNote(note);
      setState(() {});
    }
  }

  /// Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),

      /// button
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: const Icon(Icons.add),
      ),

      /// stream Builder
      body: StreamBuilder(
        /// listen to stream
        stream: notesDatabase.stream,

        /// to build UI
        builder: (context, snapshot) {
          /// loading
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          /// loaded
          final notes = snapshot.data!;

          /// list of notes
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              /// get each note
              final note = notes[index];

              /// list tile UI
              return ListTile(
                title: Text(note.content),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      /// update button
                      IconButton(
                        onPressed: () => updateNote(note),
                        icon: const Icon(Icons.edit),
                      ),

                      /// delete button
                      IconButton(
                        onPressed: () => deleteNote(note),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }, //
      ),
    );
  }
}
