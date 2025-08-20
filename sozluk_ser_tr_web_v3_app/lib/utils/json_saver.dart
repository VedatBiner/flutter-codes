// <📜 ----- lib/utils/json_saver.dart ----->
import 'dart:typed_data';

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

  /// DÜZ METİN (CSV gibi) — Web'de doğru MIME ile Blob
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

  /// BINARY (XLSX gibi) — platforma göre bytes yaz/indir
  static Future<String> saveBytesToDownloads(
    Uint8List bytes,
    String filename, {
    String mime = 'application/octet-stream',
    String? subfolder,
  }) {
    return impl.JsonSaver.saveBytesToDownloads(
      bytes,
      filename,
      mime: mime,
      subfolder: subfolder,
    );
  }
}
