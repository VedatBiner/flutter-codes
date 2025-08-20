// <📜 ----- lib/utils/json_saver_io.dart ----->
import 'dart:developer' show log;
import 'dart:io';
import 'dart:typed_data';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class JsonSaver {
  static Future<String> save(String text, String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$filename';
    await File(path).writeAsString(text);
    log('💾 Belgeler: $path', name: 'export');
    await Share.shareXFiles([XFile(path)], text: 'Dışa aktarıldı');
    return path;
  }

  static Future<String> saveToDownloads(
    String text,
    String filename, {
    String? subfolder,
  }) async {
    try {
      final path = await _ensureDownloadsPath(filename, subfolder: subfolder);
      await File(path).writeAsString(text);
      log('✅ Downloads: $path', name: 'export');
      return path;
    } catch (e) {
      log('❌ Downloads yazılamadı: $e — Belgeler’e düşülüyor', name: 'export');
      return await save(text, filename);
    }
  }

  static Future<String> saveTextToDownloads(
    String text,
    String filename, {
    String contentType = 'text/plain; charset=utf-8',
    String? subfolder,
  }) {
    return saveToDownloads(text, filename, subfolder: subfolder);
  }

  static Future<String> saveBytesToDownloads(
    Uint8List bytes,
    String filename, {
    String mime = 'application/octet-stream',
    String? subfolder,
  }) async {
    try {
      final path = await _ensureDownloadsPath(filename, subfolder: subfolder);
      await File(path).writeAsBytes(bytes);
      log('✅ Downloads (bytes): $path', name: 'export');
      return path;
    } catch (e) {
      log(
        '❌ Downloads (bytes) yazılamadı: $e — Belgeler’e düşülüyor',
        name: 'export',
      );
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$filename';
      await File(path).writeAsBytes(bytes);
      await Share.shareXFiles([XFile(path)], text: 'Dışa aktarıldı');
      return path;
    }
  }

  // -- yardımcı: uygun Downloads yolu
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

    // iOS: doğrudan Downloads yok → Belgeler
    final docs = await getApplicationDocumentsDirectory();
    final path = '${docs.path}/$filename';
    return path;
  }
}
