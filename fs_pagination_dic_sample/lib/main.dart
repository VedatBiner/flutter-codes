// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

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

class WordTile extends StatelessWidget {
  final Word word;
  const WordTile({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              word.sirpca,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              word.turkce,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

class Word {
  Word({
    required this.sirpca,
    required this.turkce,
    required this.userEmail,
  });
  Word.fromJson(Map<String, Object?> json)
      : this(
          sirpca: json['sirpca'].toString(),
          turkce: json['turkce'].toString(),
          userEmail: json['userEmail'].toString(),
        );

  final String sirpca;
  final String turkce;
  final String userEmail;

  Map<String, Object?> toJson() {
    return {
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }
}
