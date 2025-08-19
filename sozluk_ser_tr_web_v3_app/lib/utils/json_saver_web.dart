// <📜 ----- lib/utils/json_saver_web.dart ----->
/// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html' as html;

class JsonSaver {
  static Future<String> save(String json, String filename) async {
    _download(json, filename);
    return 'download://$filename'; // bilgi amaçlı
  }

  static Future<String> saveToDownloads(
    String json,
    String filename, {
    String? subfolder,
  }) async {
    _download(json, filename);
    return 'download://$filename'; // bilgi amaçlı
  }

  static void _download(String json, String filename) {
    final bytes = utf8.encode(json);
    final blob = html.Blob([bytes], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final a = html.AnchorElement(href: url)
      ..download = filename
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
