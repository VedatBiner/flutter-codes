/// <----- word_service.dart ----->
library;

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/fs_word_model.dart';

class WordService {
  late CollectionReference<FsWords> collection;
  late Database _database;

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

  /// json dosyası burada oluşturuluyor
  String convertToJson(List<FsWords> words) {
    /// İlk olarak, bir Map listesi oluşturulur.
    /// Her bir Words nesnesi bir Map 'e dönüştürülür.
    List<Map<String, dynamic>> wordList =
    words.map((word) => word.toJson()).toList();

    /// JSON formatına dönüştürmek için jsonEncode fonksiyonu kullanılır.
    /// wordList, jsonEncode fonksiyonuna verilir ve JSON formatında bir
    /// String elde edilir.
    return jsonEncode(wordList);
  }

  /// json verisini dosyaya yazdırıyoruz
  Future<void> writeJsonToFile(String jsonData) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/ser_tr_dict.json');

    await file.writeAsString(jsonData);
    print('JSON verisi başarıyla dosyaya yazıldı: ${file.path}');
  }

  /// SQLflite veri tabanı oluşturuluyor
  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'ser_tr_dict.sqlite'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS words(wordId TEXT PRIMARY KEY, sirpca TEXT, turkce TEXT, userEmail TEXT)',
        );
      },
      version: 1,
    );
  }

}
