// <📜 ----- lib/utils/json_saver_web.dart ----->
/// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html' as html;

class JsonSaver {
  static Future<String> save(String text, String filename) async {
    _download(text, filename, 'application/json');
    return 'download://$filename';
  }

  static Future<String> saveToDownloads(
    String text,
    String filename, {
    String? subfolder,
  }) async {
    _download(text, filename, 'application/json');
    return 'download://$filename';
  }

  static Future<String> saveTextToDownloads(
    String text,
    String filename, {
    String contentType = 'text/plain; charset=utf-8',
    String? subfolder,
  }) async {
    _download(text, filename, contentType);
    return 'download://$filename';
  }

  static void _download(String text, String filename, String mime) {
    final bytes = utf8.encode(text);
    final blob = html.Blob([bytes], mime);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final a = html.AnchorElement(href: url)
      ..download = filename
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
