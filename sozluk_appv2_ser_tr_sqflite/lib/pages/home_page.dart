/// <----- home_page.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/fs_word_model.dart';
import '../services/word_service.dart';
import '../word_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WordService _wordService;

  @override
  void initState() {
    super.initState();
    _wordService = WordService();
    requestStoragePermission();
  }

  /// Depolama izni talebi
  Future<void> requestStoragePermission() async {
    // İzinlerin durumunu kontrol et
    var status = await Permission.storage.status;

    /// İzin verilmediyse, talep et
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  /// SqfLite işlemleri
  // Future<void> writeToSQLite(String jsonData) async {
  //   /// SQFlite veritabanını oluşturuluyor ve açılıyor
  //   /// JSON dosya sanal cihazda burada :
  //   /// /data/user/0/com.example.sozluk_appv2_ser_tr_sqflite/app_flutter/ser_tr_dict.json
  //   final database = openDatabase(
  //     join(await getDatabasesPath(), 'ser_tr_dict.sqlite'),
  //     onCreate: (db, version) {
  //       /// Veritabanı tablosunu oluşturun
  //       return db.execute(
  //         'CREATE TABLE IF NOT EXISTS words(wordId TEXT PRIMARY KEY, sirpca TEXT, turkce TEXT, userEmail TEXT)',
  //       );
  //     },
  //     version: 1,
  //   );
  //
  //   /// SQFlite veri tabanına veriyi ekleniyor
  //   try {
  //     await database.then((db) async {
  //       final db = await database;
  //
  //       /// JSON verisini parse edin
  //       List<Map<String, dynamic>> wordList =
  //           jsonDecode(jsonData).cast<Map<String, dynamic>>();
  //
  //       /// Her bir veriyi SQFlite veri tabanına ekliyoruz
  //       /// SqlWords nesnesini toJson() metodu ile Map 'e dönüştürüyoruz
  //       for (var word in wordList) {
  //         await db.rawInsert(
  //           'REPLACE INTO words(wordId, sirpca, turkce, userEmail) VALUES (?, ?, ?, ?)',
  //           [
  //             word['wordId'].toString(),
  //             word['sirpca'].toString(),
  //             word['turkce'].toString(),
  //             word['userEmail'].toString(),
  //           ],
  //         );
  //       }
  //     });
  //   } catch (e, s) {
  //     print(s);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Sırpça - Türkçe Sözlük"),
          actions: [
            IconButton(
              onPressed: () async {
                List<FsWords> words = await _wordService.fetchWords();
                String jsonData = _wordService.convertToJson(words);

                /// JSON verisini dosyaya yaz
                await _wordService.writeJsonToFile(jsonData);

                // /// JSON verisini SQLite veri tabanına yaz
                // try {
                //   await writeToSQLite(jsonData);
                //   print('JSON verisi başarıyla veri tabanına eklendi');
                //
                //   /// Sqflite dosyanın sanal cihazdaki yeri  :
                //   /// /data/data/com.example.sozluk_appv2_ser_tr_sqflite/databases/ser_tr_dict.sqlite
                // } catch (e) {
                //   print(
                //       'Veri tabanına yazma işlemi sırasında bir hata oluştu: $e');
                // }
                /// SQL veri tabanı oluştur
                _wordService.initDatabase();
                print("İşlem tamam");
              },
              icon: const Icon(Icons.refresh_sharp),
            ),
          ],
        ),
        body: FirestoreListView<FsWords>(
          query: _wordService.collection.orderBy("sirpca"),
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
