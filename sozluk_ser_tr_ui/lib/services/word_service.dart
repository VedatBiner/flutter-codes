/// <----- word_service.dart ----->
library;

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import '../models/fs_words.dart';

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
    log('JSON verisi başarıyla dosyaya yazıldı: ${file.path}');
  }

  /// kelime sayısını bulan metod
  Stream<int> getDocumentCountStream() {
    /// Firestore koleksiyonunu referans al
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('kelimeler');

    /// Koleksiyondaki belgelerin yayınını al ve dinle
    return collectionReference.snapshots().map((querySnapshot) {
      /// Koleksiyondaki belge sayısını döndür
      return querySnapshot.size;
    });
  }

// /// Firestore 'dan verileri çekiyoruz ve SqlWords listesine dönüştürüyoruz
// Future<List<SqlWords>> fetchAndConvertWords() async {
//   final List<FsWords> fsWordsList = await fetchWords();
//   final List<SqlWords> sqlWordsList = fsWordsList
//       .map((fsWord) => SqlWords.fromJson(fsWord.toJson()))
//       .toList();
//   return sqlWordsList;
// }

  // /// SQLflite veri tabanı oluşturuluyor
  // Future<void> initDatabase() async {
  //   _database = await openDatabase(
  //     join(await getDatabasesPath(), 'ser_tr_dict.sqlite'),
  //     onCreate: (db, version) {
  //       return db.execute(
  //         'CREATE TABLE IF NOT EXISTS words(wordId TEXT PRIMARY KEY, sirpca TEXT, turkce TEXT, userEmail TEXT)',
  //       );
  //     },
  //     version: 1,
  //   );
  // }

  /// Firestore verisini SQLite veri tabanına yazma
  // Future<void> writeToSQLite(List<SqlWords> words) async {
  //   List<Map<String, dynamic>> wordList =
  //   words.map((word) => word.toJson()).toList();
  //   List<SqlWords> sqlWordsList =
  //   words.map((word) => SqlWords.fromJson(word.toJson())).toList();
  //
  //   /// print("SQL Word  List : $wordList");
  //   for (var sqlWord in sqlWordsList) {
  //     print(sqlWord);
  //   }
  //   try {
  //     await _database.transaction((txn) async {
  //       for (var word in sqlWordsList) {
  //         await txn.rawInsert(
  //           'INSERT OR REPLACE INTO words(wordId, sirpca, turkce, userEmail) VALUES (?, ?, ?, ?)',
  //           [
  //             word.wordId,
  //             word.sirpca,
  //             word.turkce,
  //             word.userEmail,
  //           ],
  //         );
  //       }
  //     });
  //     print('Firestore verisi SQLite veritabanına başarıyla aktarıldı.');
  //   } catch (e, s) {
  //     print('SQLite veritabanına yazma işlemi sırasında bir hata oluştu: $e');
  //     print(s);
  //   }
  // }
}
