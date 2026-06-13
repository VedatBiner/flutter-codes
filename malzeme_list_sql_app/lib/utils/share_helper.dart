// 📃 <----- lib/utils/share_helper.dart ----->
//
// Bu yardımcı dosya, uygulama tarafından oluşturulan yedek dosyaları
// (CSV, JSON, Excel, SQL) kolayca paylaşmak için tasarlanmıştır.
//
// 🔹 İşlev:  shareBackupFolder()
//   → Download/{appName} klasöründeki tüm dosyaları kontrol eder.
//   → Dosyalar varsa share_plus paketiyle sistem paylaşım ekranını açar.
//
// 🔹 Özellikler:
//   • assets değil, cihazın Download klasörünü hedef alır.
//   • Dosya listesi otomatik oluşturulur.
//   • Dosya yoksa veya dizin yoksa konsola bilgilendirici log düşer.
//
// 🔹 Kullanım Örneği:
//     import '../utils/share_helper.dart';
//     await shareBackupFolder();
//
// ---------------------------------------------------------------------------

// 📌 Dart hazır paketleri
import 'dart:developer';
import 'dart:io';

/// 📌 Flutter hazır paketleri
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';

/// 📤 Download/{appName} klasöründeki yedek dosyaları paylaşır.
///
/// Fonksiyon, uygulamanın kullandığı yedek klasörünü kontrol eder:
///  - Dizin yoksa uyarı verir.
///  - Dizin varsa içindeki dosyaları (CSV, JSON, XLSX, SQL vb.) listeler.
///  - Dosya varsa sistemin paylaşım menüsünü açar.
///
/// Log çıktıları konsolda `[share_helper]` etiketiyle görünür.
Future<void> shareBackupFolder() async {
  const tag = 'share_helper';

  try {
    // 📁 Android Download dizini
    const downloadDir = '/storage/emulated/0/Download';

    // 📁 Yedek klasörü
    final folderPath = join(downloadDir, appName);

    final dir = Directory(folderPath);

    // 📂 Dizin mevcut mu?
    if (!await dir.exists()) {
      log('⚠️ Dizin bulunamadı: $folderPath', name: tag);
      return;
    }

    // 📜 Dizin içindeki tüm dosyaları al
    final files = dir.listSync().whereType<File>().toList();

    if (files.isEmpty) {
      log('⚠️ Paylaşılacak dosya bulunamadı.', name: tag);
      return;
    }

    log('📂 ${files.length} dosya bulundu.', name: tag);

    // 📤 Sistem paylaşım ekranı
    await Share.shareXFiles(
      files.map((f) => XFile(f.path)).toList(),
      text: '📂 $appName yedek dosyaları',
    );

    log('✅ Paylaşım ekranı başarıyla açıldı.', name: tag);
  } catch (e, st) {
    log(
      '🚨 Paylaşım hatası: $e',
      name: tag,
      error: e,
      stackTrace: st,
    );
  }
}