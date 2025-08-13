// 📃 <----- local_cache_service_web.dart ----->
//
// Web için yerel JSON cache:
// - window.localStorage üzerine tek key altında yazar/okur.
// - Boyut ~5MB civarı; 10k+ kelime tipik olarak sığar.

import 'dart:convert';
import 'dart:html' as html; // <-- DOĞRU: web'de dart:html

import '../models/word_model.dart';

class LocalCacheService {
  static const _key = 'sozluk_cache_json';

  /// Cihazdaki (browser) JSON cache'i oku. Yoksa [] döner.
  static Future<List<Word>> readAll() async {
    try {
      final str = html.window.localStorage[_key];
      if (str == null || str.isEmpty) return [];
      final List list = jsonDecode(str) as List;
      return list
          .map((e) => Word.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Tüm listeyi localStorage içine JSON string olarak yaz.
  static Future<void> writeAll(List<Word> words) async {
    final str = jsonEncode(words.map((w) => w.toMap()).toList());
    html.window.localStorage[_key] = str;
  }

  /// Cache var mı?
  static Future<bool> exists() async {
    final str = html.window.localStorage[_key];
    return str != null && str.isNotEmpty;
  }

  /// Cache ’i temizle.
  static Future<void> clear() async {
    html.window.localStorage.remove(_key);
  }
}
