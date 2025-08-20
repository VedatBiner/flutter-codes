// <📜 ----- lib/utils/json_saver_web.dart ----->
/*
  🌐 JsonSaver (Web) — Tarayıcıda dosya indirme yardımcıları
  ----------------------------------------------------------
  BU DOSYA NE İŞE YARAR?
  - Metin (JSON/CSV) veya ikili (XLSX vb.) içerikleri **Flutter Web** üzerinde
    kullanıcıya indirtmek için basit bir API sunar.
  - `dart:html` yerine **package:web** + **dart:js_interop** kullanır:
      • `web.Blob(...)` ile tarayıcı tarafında Blob oluşturur,
      • `web.URL.createObjectURL(...)` ile geçici URL üretir,
      • `web.HTMLAnchorElement().click()` ile `<a download>` tetikleyip indirmeyi başlatır.

  KULLANIM ÖZETİ
  - `save(text, filename)`                → JSON benzeri içerik için varsayılan indirme
  - `saveToDownloads(text, filename)`     → Web’de “Downloads” kavramı yok; dosyayı doğrudan indirir
  - `saveTextToDownloads(text, filename, contentType: ...)`
                                          → Metin içerikleri (CSV/JSON) için doğru MIME ile indir
  - `saveBytesToDownloads(bytes, filename, mime: ...)`
                                          → İkili içerikler (XLSX/PDF) için indir

  DAVRANIŞ / SINIRLAR
  - Tarayıcı güvenlik modelinde **gerçek klasör yolu** seçilemez; dosya **kullanıcının
    indirmeler klasörüne** gider ve adı `filename` olur.
  - `subfolder` parametresi Web’de **yoksayılır** (klasör kavramı yok).
  - Büyük veriler için Blob oluşturma bellek tüketebilir; mümkünse dosyayı parça parça
    üretip tek seferde yazmak yerine metin/bytes’i tek seferde vermek daha stabildir.

  BAĞIMLILIKLAR
  - `web` (DOM API’leri için)  — `import 'package:web/web.dart' as web;`
  - `dart:js_interop` (JS köprüleri) — `toJS` ile `Uint8List` → `JSUint8Array` dönüşümü

  DÖNÜŞ DEĞERİ
  - Fonksiyonlar `"download://<filename>"` benzeri sembolik bir değer döndürür; gerçek yol değil,
    “indirmenin başlatıldığını” ifade eder. UI’da bilgi amaçlı gösterilebilir.
*/

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:js_interop'; // <-- toJS için
import 'dart:typed_data';

/// 📌 Flutter hazır paketleri
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
    /// 1️⃣ Metni UTF-8'e çevir → Uint8List
    final data = Uint8List.fromList(utf8.encode(text));

    /// 2️⃣ Uint8List → JSUint8Array (toJS) ve dış listeyi de JSArray 'e çevir
    final blob = web.Blob(
      [data.toJS].toJS,
      web.BlobPropertyBag(type: contentType),
    );

    /// 3️⃣ URL oluşturup <a download> ile tıklat
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
