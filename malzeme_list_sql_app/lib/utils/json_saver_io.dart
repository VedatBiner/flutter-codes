// <📜 ----- lib/utils/json_saver_io.dart ----->
/*
  💾 JsonSaver (IO) — Mobil/Desktop ’ta dosya kaydetme & paylaşma implementasyonu

  BU DOSYA NE İŞE YARAR?
  - `lib/utils/json_saver.dart` içindeki **koşullu import** ile, web dışındaki (Android/iOS/Windows/Linux/macOS)
    platformlarda metin (JSON/CSV) ve ikili (XLSX vb.) içerikleri uygun konuma kaydeder.
  - Mümkünse **Downloads** klasörüne yazar; değilse **Uygulama Belgeleri** klasörüne kaydedip paylaşım ekranını açar.

  KULLANILAN BAĞIMLILIKLAR
  - path_provider        → Belgeler/Downloads gibi dizinleri bulmak için
  - permission_handler   → Android ’te depolama izinlerini istemek için
  - share_plus           → Belgeler ’e kaydedilen dosyayı paylaşmak için
  - dart:developer/log   → Konsola özet bilgi/log yazmak için

  ANA METOTLAR
  - save(text, filename)
      • Uygulama **Belgeler** dizinine yazar (tüm platformlar).
      • Ardından paylaşım sayfası açar (SharePlus.instance.share).
      • Geriye tam dosya yolunu döndürür.
  - saveToDownloads(text, filename, {subfolder})
      • Önce **Downloads** dizinine yazmayı dener (Android/Desktop).
      • Başarısız olursa `save(...)` ile Belgeler ’e yazıp paylaşır.
      • Geriye tam dosya yolunu döndürür.
  - saveTextToDownloads(...) → metin için `saveToDownloads` kısayolu (contentType IO ’da sadece deklaratif).
  - saveBytesToDownloads(bytes, filename, {subfolder})
      • Bytes olarak yazma (XLSX gibi ikili içerik).
      • Önce Downloads, olmazsa Belgeler + paylaşım.

  PLATFORM DAVRANIŞI
  - ANDROID
      • Önce `MANAGE_EXTERNAL_STORAGE` ardından `READ/WRITE_EXTERNAL_STORAGE` iznini dener.
      • İzin verilirse `/storage/emulated/0/Download[/<subfolder>]` içine yazar (gerekirse klasör oluşturur).
      • İzin verilmezse Belgeler ’e kaydedip paylaşır.
  - iOS
      • “Genel Downloads” yoktur. Belgeler dizinine kaydedilir; paylaşım ile kullanıcı istediği yere aktarabilir.
  - WINDOWS / LINUX / MACOS
      • `getDownloadsDirectory()` varsa onu, yoksa Belgeler ’i kullanır.
      • `subfolder` verilmişse alt klasör oluşturulur.

  DÖNÜŞ DEĞERİ
  - Başarılı her çağrıda **tam dosya yolu** döner. (Android/Desktop: gerçek yol; iOS: Belgeler yolu)

  LOG KULLANIMI
  - İşlemler `log(..., name: 'export')` ile raporlanır:
      • '✅ Download: <path>'
      • '💾 Belgeler: <path>'
      • '❌ ...' hata durumları ve fallback bilgisi

  NOTLAR
  - Android Manifest ’te gerekli izinleri tanımladığınızdan emin olun (permission_handler belgelerine bakınız).
  - Emulator/cihazlarda farklı depolama politikaları görülebilir; hata durumunda fallback akışı devrededir.
*/

// 📌 Dart hazır paketleri
import 'dart:developer' show log;
import 'dart:io';
import 'dart:typed_data';

/// 📌 Flutter hazır paketleri
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class JsonSaver {
  static const String _androidDownloadPath = '/storage/emulated/0/Download';

  static Future<String> save(String text, String filename) async {
    const tag = 'json_saver_io';

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$filename';

    final file = File(path);
    final parent = file.parent;
    if (!await parent.exists()) {
      await parent.create(recursive: true);
    }

    await file.writeAsString(text);
    log('💾 Belgeler: $path', name: tag);

    await Share.shareXFiles([XFile(path)], text: 'Dışa aktarıldı');

    return path;
  }

  static Future<String> saveToDownloads(
      String text,
      String filename, {
        String? subfolder,
      }) async {
    const tag = 'json_saver_io';

    try {
      final path = await _ensureDownloadsPath(filename, subfolder: subfolder);

      final file = File(path);
      final parent = file.parent;
      if (!await parent.exists()) {
        await parent.create(recursive: true);
      }

      await file.writeAsString(text);
      log('✅ Download → $path', name: tag);
      return path;
    } catch (e) {
      log('❌ Download yazılamadı: $e — Belgeler\'e düşülüyor', name: tag);
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
    const tag = 'json_saver_io';

    try {
      final path = await _ensureDownloadsPath(filename, subfolder: subfolder);

      final file = File(path);
      final parent = file.parent;
      if (!await parent.exists()) {
        await parent.create(recursive: true);
      }

      await file.writeAsBytes(bytes);
      log('✅ Download → $path', name: tag);
      return path;
    } catch (e) {
      log('❌ Download yazılamadı: $e — Belgeler\'e düşülüyor', name: tag);

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$filename';

      final file = File(path);
      final parent = file.parent;
      if (!await parent.exists()) {
        await parent.create(recursive: true);
      }

      await file.writeAsBytes(bytes);

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
      if (!granted) {
        granted = await Permission.storage.request().isGranted;
      }

      if (!granted) {
        throw Exception('External storage izni verilmedi');
      }

      final dirPath = subfolder != null
          ? '$_androidDownloadPath/$subfolder'
          : _androidDownloadPath;

      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      return '$dirPath/$filename';
    }

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final d = await getDownloadsDirectory();
      final base = d ?? await getApplicationDocumentsDirectory();

      final dirPath = subfolder != null ? '${base.path}/$subfolder' : base.path;

      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      return '$dirPath/$filename';
    }

    // iOS: doğrudan Downloads yok → Belgeler
    final docs = await getApplicationDocumentsDirectory();
    return '${docs.path}/$filename';
  }
}