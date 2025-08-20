// <📜 ----- lib/utils/json_saver_web.dart ----->
// Flutter Web indirme yardımcıları — dart:html yerine package:web + dart:js_interop

import 'dart:convert';
import 'dart:js_interop'; // <-- toJS için
import 'dart:typed_data';

import 'package:web/web.dart' as web; // <-- DOM API

class JsonSaver {
  static Future<String> save(String text, String filename) async {
    // JSON kaydı (text → bytes → Blob)
    await saveTextToDownloads(text, filename, contentType: 'application/json');
    return 'download://$filename';
  }

  static Future<String> saveToDownloads(
    String text,
    String filename, {
    String? subfolder, // Web ’de klasör konsepti yok; parametre yoksayılır
  }) async {
    await saveTextToDownloads(text, filename, contentType: 'application/json');
    return 'download://$filename';
  }

  static Future<String> saveTextToDownloads(
    String text,
    String filename, {
    String contentType = 'text/plain; charset=utf-8',
    String? subfolder,
  }) async {
    // 1) Metni UTF-8'e çevir → Uint8List
    final data = Uint8List.fromList(utf8.encode(text));
    // 2) Uint8List → JSUint8Array (toJS) ve dış listeyi de JSArray 'e çevir
    final blob = web.Blob(
      [data.toJS].toJS,
      web.BlobPropertyBag(type: contentType),
    );
    // 3) URL oluşturup <a download> ile tıklat
    final url = web.URL.createObjectURL(blob);
    final a = web.HTMLAnchorElement()
      ..href = url
      ..download = filename;
    a.click();
    web.URL.revokeObjectURL(url);
    return 'download://$filename';
  }

  static Future<String> saveBytesToDownloads(
    Uint8List bytes,
    String filename, {
    String mime = 'application/octet-stream',
    String? subfolder,
  }) async {
    // bytes → JSUint8Array → Blob
    final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: mime));
    final url = web.URL.createObjectURL(blob);
    final a = web.HTMLAnchorElement()
      ..href = url
      ..download = filename;
    a.click();
    web.URL.revokeObjectURL(url);
    return 'download://$filename';
  }
}
