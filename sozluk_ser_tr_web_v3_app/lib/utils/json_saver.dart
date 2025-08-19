// <📜 ----- lib/utils/json_saver.dart ----->
// Platforma göre indirme/kaydetme (web ↔︎ IO). Artık düz metin için içerik tipi de verebiliyoruz.
import 'json_saver_io.dart'
    if (dart.library.html) 'json_saver_web.dart'
    as impl;

class JsonSaver {
  /// Varsayılan: Web → indirme, IO → Belgeler + Paylaş
  static Future<String> save(String text, String filename) {
    return impl.JsonSaver.save(text, filename);
  }

  /// Downloads'a kaydet (mümkün olan platformlarda)
  static Future<String> saveToDownloads(
    String text,
    String filename, {
    String? subfolder,
  }) {
    return impl.JsonSaver.saveToDownloads(text, filename, subfolder: subfolder);
  }

  /// DÜZ METİN kaydet (CSV gibi). Web’de doğru MIME ile Blob oluşturur.
  static Future<String> saveTextToDownloads(
    String text,
    String filename, {
    String contentType = 'text/plain; charset=utf-8',
    String? subfolder,
  }) {
    return impl.JsonSaver.saveTextToDownloads(
      text,
      filename,
      contentType: contentType,
      subfolder: subfolder,
    );
  }
}
