import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/word_tile.dart';
import '../model/word_model.dart';

class FirebaseUIFirestoreExample extends StatelessWidget {
  late Query<Word> collection;

  @override
  Widget build(BuildContext context) {
    final collectionRef =
    FirebaseFirestore.instance.collection('kelimeler').orderBy("sirpca");

    final collection = collectionRef.withConverter<Word>(
      fromFirestore: (snapshot, _) => Word.fromJson(snapshot.data()!),
      toFirestore: (word, _) => word.toJson(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Serbian - Turkish Dictionary')),
        body: FirestoreListView<Word>(
          query: collection,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, snapshot) {
            final word = snapshot.data();
            return Column(
              children: [
                WordTile(word: word),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
