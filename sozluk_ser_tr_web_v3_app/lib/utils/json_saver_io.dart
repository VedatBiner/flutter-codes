// <📜 ----- lib/utils/json_saver_io.dart ----->
import 'dart:developer' show log;
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class JsonSaver {
  /// Belgeler'e yaz + paylaş (her zaman çalışır). Yol geri döner.
  static Future<String> save(String json, String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$filename';
    final file = File(path);
    await file.writeAsString(json);
    log('💾 JSON (Belgeler): $path', name: 'export');
    await Share.shareXFiles([XFile(path)], text: 'JSON dışa aktarım');
    return path;
  }

  /// Mümkünse Downloads'a yaz. Kaydedilen yol geri döner.
  static Future<String> saveToDownloads(
    String json,
    String filename, {
    String? subfolder,
  }) async {
    try {
      if (Platform.isAndroid) {
        var granted = await Permission.manageExternalStorage
            .request()
            .isGranted;
        if (!granted) {
          granted = await Permission.storage.request().isGranted;
        }
        if (!granted) {
          log('⚠️ İzin yok, Belgeler\'e yazılıyor.', name: 'export');
          return await save(json, filename);
        }

        final downloads = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOAD,
        );
        final dirPath = subfolder != null ? '$downloads/$subfolder' : downloads;
        final dir = Directory(dirPath);
        if (!await dir.exists()) await dir.create(recursive: true);

        final path = '$dirPath/$filename';
        await File(path).writeAsString(json);
        log('✅ JSON (Android Downloads): $path', name: 'export');
        return path;
      }

      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        final d = await getDownloadsDirectory();
        final base = d ?? await getApplicationDocumentsDirectory();
        final dirPath = subfolder != null
            ? '${base.path}/$subfolder'
            : base.path;
        final dir = Directory(dirPath);
        if (!await dir.exists()) await dir.create(recursive: true);
        final path = '$dirPath/$filename';
        await File(path).writeAsString(json);
        log('✅ JSON (Desktop Downloads): $path', name: 'export');
        return path;
      }

      // iOS: doğrudan Downloads yok → Belgeler + Paylaş
      final docs = await getApplicationDocumentsDirectory();
      final path = '${docs.path}/$filename';
      await File(path).writeAsString(json);
      log(
        'ℹ️ iOS: Belgeler yazıldı (Files ile Downloads\'a taşıyabilirsiniz): $path',
        name: 'export',
      );
      await Share.shareXFiles([XFile(path)], text: 'JSON dışa aktarım');
      return path;
    } catch (e) {
      log('❌ Downloads yazılamadı, Belgeler\'e düşülüyor: $e', name: 'export');
      return await save(json, filename);
    }
  }
}
