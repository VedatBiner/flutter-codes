// <📜 ----- lib/utils/json_saver.dart ----->

/*
  💾 Platforma göre kaydetme/indirme köprüsü (Web + Mobil/Desktop)

  BU DOSYA NE İŞE YARAR?
  - Tek bir API üzerinden metin (JSON/CSV) veya ikili (XLSX vb.) içerikleri
    *platforma uygun şekilde* kullanıcıya kaydeder/indirir.
  - Uygun implementasyonu **koşullu import** ile seçer:
      • Web  → `json_saver_web.dart`  (package:web + <a download> ile tarayıcı indirmesi)
      • IO   → `json_saver_io.dart`   (Android/iOS/Desktop’ta Downloads/Belgeler vb. konuma yazma/paylaşma)

  KULLANIM ÖZETİ
  - `JsonSaver.save(text, filename)`           → Varsayılan kaydetme (JSON gibi)
  - `JsonSaver.saveToDownloads(text, name)`    → Mümkünse Downloads altına yaz (CSV/JSON için de olur)
  - `JsonSaver.saveTextToDownloads(text, name, contentType: ...)`
                                               → Metin içeriği (CSV, plain text) doğru MIME ile
  - `JsonSaver.saveBytesToDownloads(bytes, name, mime: ...)`
                                               → İkili içerik (XLSX, PDF, …)

  DÖNÜŞ DEĞERLERİ
  - Web’de genellikle `"download://<filename>"` döner (tarayıcıya delegasyon).
  - IO platformlarda mümkünse *gerçek dosya yolu* döner (örn. `/storage/emulated/0/Download/...`).
    iOS’ta paylaşım sayfası üzerinden kullanıcı konum seçebilir.

  NOTLAR
  - Android’de dosya yazımı için sürüme göre depolama izinleri gerekebilir (permission_handler).
  - Web’de “alt klasör” kavramı tarayıcı indirmesinde yoktur; dosya adı yeterlidir.
  - Bu dosya sadece bir facade’dır; asıl iş `json_saver_web.dart` ve `json_saver_io.dart` içinde yapılır.
*/

// 📌 Dart hazır paketleri
import 'dart:typed_data';

/// 📌 Yardımcı yüklemeler burada
import 'json_saver_io.dart'
    if (dart.library.html) 'json_saver_web.dart'
    as impl;

class JsonSaver {
  /// 📌 Varsayılan: Web → indirme, IO → Belgeler + Paylaş
  static Future<String> save(String text, String filename) {
    return impl.JsonSaver.save(text, filename);
  }

  /// 📌 Downloads 'a kaydet (mümkün olan platformlarda)
  static Future<String> saveToDownloads(
    String text,
    String filename, {
    String? subfolder,
  }) {
    return impl.JsonSaver.saveToDownloads(text, filename, subfolder: subfolder);
  }

  /// 📌 DÜZ METİN (CSV gibi) — Web 'de doğru MIME ile Blob
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

  /// 📌 BINARY (XLSX gibi) — platforma göre bytes yaz/indir
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
