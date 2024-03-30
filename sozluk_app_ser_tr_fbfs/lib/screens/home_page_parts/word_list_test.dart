import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/fs_words.dart';
import '../../utils/word_tile_test.dart';

class WordList extends StatelessWidget {
  late Query<FsWords> collection;

  final String aramaKelimesi;

  WordList({
    super.key,
    required this.aramaKelimesi,
  });

  @override
  Widget build(BuildContext context) {
    final collectionRef =
        FirebaseFirestore.instance.collection('kelimeler').orderBy("sirpca");

    final collection = collectionRef.withConverter<FsWords>(
      fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
      toFirestore: (word, _) => word.toJson(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(title: const Text('Serbian - Turkish Dictionary')),
        body: FirestoreListView<FsWords>(
          query: collection,
          pageSize: 50,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, snapshot) {
            final word = snapshot.data();
            return Column(
              children: [
                WordTile(
                  word: word,
                  aramaKelimesi: aramaKelimesi,
                ),
                // const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
