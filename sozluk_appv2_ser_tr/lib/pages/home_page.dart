/// <----- home_page.dart ----->
library;

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/fs_word_model.dart';
import '../word_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CollectionReference<FsWords> collection;

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    final collectionRef = FirebaseFirestore.instance.collection('kelimeler');

    collection = collectionRef.withConverter<FsWords>(
      fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
      toFirestore: (word, _) => word.toJson(),
    );
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

  /// firestore 'dan verileri çekiyoruz
  Future<List<FsWords>> fetchWords() async {
    final querySnapshot = await collection.orderBy("sirpca").get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

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

    /// dosyayı lokal diske alalım
    const String destinationPath = 'assets/database/ser_tr_dict.json';

    try {
      /// Sanal cihaz dizinden assets klasörüne kopyalama
      await file.copy(destinationPath);
      print('JSON verisi başarıyla assets/database dizinine kopyalandı.');
    } catch (e) {
      print('Dosya kopyalama hatası: $e');
    }

    print('JSON verisi başarıyla dosyaya yazıldı: ${file.path}');
  }

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
                List<FsWords> words = await fetchWords();
                String jsonData = convertToJson(words);

                /// JSON verisini dosyaya yaz
                await writeJsonToFile(jsonData);
              },
              icon: const Icon(Icons.refresh_sharp),
            ),
          ],
        ),
        body: FirestoreListView<FsWords>(
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
