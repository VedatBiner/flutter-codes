/// <----- word_service.dart ----->
library;

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import '../models/fs_words.dart';
import '../utils/generate_json.dart';

class WordService {
  late CollectionReference<FsWords> collection;

  WordService() {
    final collectionRef = FirebaseFirestore.instance.collection('kelimeler');

    collection = collectionRef.withConverter<FsWords>(
      fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
      toFirestore: (word, _) => word.toJson(),
    );
  }

  Future<void> jsonInit() async {
    await generateAndWriteJson();
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
}
