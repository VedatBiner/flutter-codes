/// <----- generate_json.dart ----->
library;

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/fs_words.dart';
import '../services/firebase_services/firestore_services.dart';

Future<void> generateAndWriteJson() async {
  final FirestoreService firestoreService = FirestoreService();

  /// Firestore verisinden JSON veri oluştur
  List<FsWords> words = await firestoreService.fetchWords();

  String jsonData = convertToJson(words);

  /// JSON verisini dosyaya yaz
  await writeJsonToFile(jsonData);
}

/// JSON formatına dönüştürme fonksiyonu
String convertToJson(List<FsWords> words) {
  List<Map<String, dynamic>> wordList =
  words.map((word) => word.toJson()).toList();
  return jsonEncode(wordList);
}

/// JSON verisini dosyaya yazan fonksiyon
Future<void> writeJsonToFile(String jsonData) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/ser_tr_dict.json');

  await file.writeAsString(jsonData);
  log('JSON verisi başarıyla dosyaya yazıldı: ${file.path}');
}
