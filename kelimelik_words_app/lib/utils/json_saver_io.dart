// <📜 ----- lib/utils/json_saver_io.dart ----->
/*
  💾 JsonSaver (IO) — Mobil/Desktop’ta dosya kaydetme & paylaşma implementasyonu

  BU DOSYA NE İŞE YARAR?
  - Web dışı platformlarda (Android/iOS/Windows/Linux/macOS) JSON, CSV veya XLSX gibi verileri
    cihazın uygun dizinine kaydeder ve gerekirse sistemin paylaşım menüsünü açar.
  - Mümkünse **Downloads** klasörüne yazar; başarısız olursa **Belgeler** klasörüne kaydeder.

  GÜNCELLEMELER (share_plus)
  - `Share.shareXFiles` kullanılıyor.

  KULLANILAN BAĞIMLILIKLAR:
  - path_provider
  - external_path
  - permission_handler
  - share_plus
  - dart:developer/log
*/

import 'dart:developer' show log;
import 'dart:io';
import 'dart:typed_data';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class JsonSaver {
  /// 📄 Belgeler dizinine yazar ve paylaşım ekranı açar.
  static Future<String> save(String text, String filename) async {
    const tag = 'json_saver';
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$filename';

    await File(path).writeAsString(text);

    log('💾 Belgeler: $path', name: tag);

    // ✅ Yeni share_plus API
    await Share.shareXFiles([XFile(path)], text: 'Dışa aktarıldı');

    return path;
  }

  /// 📁 Öncelikle Downloads dizinine kaydetmeyi dener.
  /// Başarısız olursa Belgeler dizinine yazar ve paylaşır.
  static Future<String> saveToDownloads(
    String text,
    String filename, {
    String? subfolder,
  }) async {
    const tag = 'json_saver';
    try {
      final path = await _ensureDownloadsPath(filename, subfolder: subfolder);
      await File(path).writeAsString(text);
      log('✅ Download → $path', name: tag);
      return path;
    } catch (e) {
      log('❌ Download yazılamadı: $e — Belgeler\'e düşülüyor', name: tag);
      return await save(text, filename);
    }
  }

  /// Metin verisi için kısayol (contentType sadece deklaratif, IO ’da kullanılmaz)
  static Future<String> saveTextToDownloads(
    String text,
    String filename, {
    String contentType = 'text/plain; charset=utf-8',
    String? subfolder,
  }) {
    return saveToDownloads(text, filename, subfolder: subfolder);
  }

  /// 📦 Bytes veriyi (örneğin XLSX) kaydeder ve gerekirse paylaşır.
  static Future<String> saveBytesToDownloads(
    Uint8List bytes,
    String filename, {
    String mime = 'application/octet-stream',
    String? subfolder,
  }) async {
    const tag = 'json_saver';
    try {
      final path = await _ensureDownloadsPath(filename, subfolder: subfolder);
      await File(path).writeAsBytes(bytes);
      log('✅ Download → $path', name: tag);
      return path;
    } catch (e) {
      log('❌ Download yazılamadı: $e — Belgeler\'e düşülüyor', name: tag);
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$filename';
      await File(path).writeAsBytes(bytes);

      // ✅ Yeni share_plus API
      await Share.shareXFiles([XFile(path)], text: 'Dışa aktarıldı');

      return path;
    }
  }

  /// 🔧 Platforma göre uygun Downloads dizinini sağlar veya oluşturur.
  static Future<String> _ensureDownloadsPath(
    String filename, {
    String? subfolder,
  }) async {
    if (Platform.isAndroid) {
      var granted = await Permission.manageExternalStorage.request().isGranted;
      if (!granted) granted = await Permission.storage.request().isGranted;
      if (!granted) throw Exception('External storage izni verilmedi');

      final downloads = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD,
      );

      final dirPath = subfolder != null ? '$downloads/$subfolder' : downloads;
      final dir = Directory(dirPath);
      if (!await dir.exists()) await dir.create(recursive: true);
      return '$dirPath/$filename';
    }

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final d = await getDownloadsDirectory();
      final base = d ?? await getApplicationDocumentsDirectory();
      final dirPath = subfolder != null ? '${base.path}/$subfolder' : base.path;
      final dir = Directory(dirPath);
      if (!await dir.exists()) await dir.create(recursive: true);
      return '$dirPath/$filename';
    }

    // iOS fallback: Belgeler dizini
    final docs = await getApplicationDocumentsDirectory();
    return '${docs.path}/$filename';
  }
}
