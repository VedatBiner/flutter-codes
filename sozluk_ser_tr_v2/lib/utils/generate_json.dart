
import 'dart:developer';

import '../models/fs_words.dart';
import '../services/word_service.dart';

Future<void> generateAndWriteJson(WordService wordService) async {
  /// Firestore verisinden JSON veri oluştur
  List<FsWords> words = await wordService.fetchWords();
  String jsonData = wordService.convertToJson(words);

  log("===> 07-generate_json.dart dosyası çalıştı. >>>>>");
  log("------------------------------------------------------------");
  /// JSON verisini dosyaya yaz
  await wordService.writeJsonToFile(jsonData);
}
