// word_service.dart dosyası

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fs_word_model.dart';

class WordService {
  late CollectionReference<FsWords> collection;

  WordService() {
    final collectionRef = FirebaseFirestore.instance.collection('kelimeler');

    collection = collectionRef.withConverter<FsWords>(
      fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
      toFirestore: (word, _) => word.toJson(),
    );
  }

  /// firestore 'dan verileri çekiyoruz
  Future<List<FsWords>> fetchWords() async {
    final querySnapshot = await collection.orderBy("sirpca").get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
