// 📃 <----- local_cache_service_io.dart ----->
//
// Mobil / Desktop için yerel JSON cache:
// - path_provider + dart:io ile Documents klasörüne yazar/okur.
// - Tam listeyi tek string JSON olarak saklar.

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart'; // fileNameJson
import '../models/word_model.dart';

class LocalCacheService {
  static Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileNameJson');
  }

  /// Cihazdaki JSON cache'i oku. Yoksa [] döner.
  static Future<List<Word>> readAll() async {
    try {
      final f = await _file();
      if (!(await f.exists())) return [];
      final str = await f.readAsString();
      final List list = jsonDecode(str) as List;
      return list
          .map((e) => Word.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Tüm listeyi cihaz JSON cache’ine yaz.
  static Future<void> writeAll(List<Word> words) async {
    final f = await _file();
    final str = jsonEncode(words.map((w) => w.toMap()).toList());
    await f.writeAsString(str, flush: true);
  }

  /// Cache var mı?
  static Future<bool> exists() async {
    final f = await _file();
    return f.exists();
  }

  /// Cache’i sil (isteğe bağlı).
  static Future<void> clear() async {
    final f = await _file();
    if (await f.exists()) await f.delete();
  }
}
