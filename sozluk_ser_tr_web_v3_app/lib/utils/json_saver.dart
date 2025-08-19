// <📜 ----- lib/utils/json_saver.dart ----->
import 'json_saver_io.dart'
    if (dart.library.html) 'json_saver_web.dart'
    as impl;

class JsonSaver {
  /// Varsayılan: Web → indirme, IO → Belgeler + Paylaş
  static Future<String> save(String json, String filename) {
    return impl.JsonSaver.save(json, filename);
  }

  /// Mümkünse Downloads'a kaydet ve "kaydedilen yol"u geri döndür.
  static Future<String> saveToDownloads(
    String json,
    String filename, {
    String? subfolder,
  }) {
    return impl.JsonSaver.saveToDownloads(json, filename, subfolder: subfolder);
  }
}
