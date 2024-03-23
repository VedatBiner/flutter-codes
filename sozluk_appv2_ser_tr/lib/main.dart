import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'model/word_model.dart';

late CollectionReference<Words> collection;

/// Scrollbar için controller
ScrollController listViewController = ScrollController();
final _itemExtent = 100.0;



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final collectionRef = FirebaseFirestore.instance.collection('kelimeler');

  collection = collectionRef.withConverter<Words>(
    fromFirestore: (snapshot, _) => Words.fromJson(snapshot.data()!),
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

class WordTile extends StatelessWidget {
  final Words word;

  const WordTile({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                word.userEmail,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

