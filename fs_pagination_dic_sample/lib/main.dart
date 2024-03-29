// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'model/word_model.dart';
import 'widgets/word_tile.dart';

late Query<Word> collection;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final collectionRef =
      FirebaseFirestore.instance.collection('kelimeler').orderBy("sirpca");

  collection = collectionRef.withConverter<Word>(
    fromFirestore: (snapshot, _) => Word.fromJson(snapshot.data()!),
    toFirestore: (word, _) => word.toJson(),
  );

  runApp(const FirebaseUIFirestoreExample());
}

class FirebaseUIFirestoreExample extends StatelessWidget {
  const FirebaseUIFirestoreExample({super.key});

  @override
  Widget build(BuildContext context) {
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
