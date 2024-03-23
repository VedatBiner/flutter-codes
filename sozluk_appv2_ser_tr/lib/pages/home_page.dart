/// <----- home_page.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

import '../model/word_model.dart';
import '../word_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CollectionReference<Words> collection;

  @override
  void initState() {
    super.initState();
    final collectionRef = FirebaseFirestore.instance.collection('kelimeler');

    collection = collectionRef.withConverter<Words>(
      fromFirestore: (snapshot, _) => Words.fromJson(snapshot.data()!),
      toFirestore: (word, _) => word.toJson(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Sırpça - Türkçe Sözlük"),
        ),
        body: FirestoreListView<Words>(
          query: collection.orderBy("sirpca"),
          padding: const EdgeInsets.all(8),
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
