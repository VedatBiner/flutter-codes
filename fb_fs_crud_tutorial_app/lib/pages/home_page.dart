/// <----- homepage.dart ----->

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_fs_crud_tutorial_app/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();

  /// Open dialog box to ad a note
  void openNoteBox({String? docId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          /// button to save
          ElevatedButton(
            onPressed: () {
              /// add a new note
              if (docId == null) {
                firestoreService.addNote(textController.text);
              } else {
                /// update an existing note
                firestoreService.updateNote(docId, textController.text);
              }

              /// clear text controller
              textController.clear();

              /// close the box
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          /// if we have data, get all the docs
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            /// display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                /// get each individual doc
                DocumentSnapshot document = notesList[index];
                String docId = document.id;

                /// get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data["note"];

                /// display as a list tile
                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// update
                      IconButton(
                        onPressed: () => openNoteBox(docId: docId),
                        icon: const Icon(Icons.edit),
                      ),

                      /// delete
                      IconButton(
                        onPressed: () => firestoreService.deleteNote(docId),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text("No notes ...");
          }
        },
      ),
    );
  }
}
