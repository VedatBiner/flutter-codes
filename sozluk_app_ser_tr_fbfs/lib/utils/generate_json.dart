import '../models/____fs_words.dart_iptal';
import '../services/word_service.dart';

Future<void> generateAndWriteJson(WordService wordService) async {
  /// Firestore verisinden JSON veri oluştur
  List<FsWords> words = await wordService.fetchWords();
  String jsonData = wordService.convertToJson(words);

  /// JSON verisini dosyaya yaz
  await wordService.writeJsonToFile(jsonData);
}
