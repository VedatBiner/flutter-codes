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
// 🔹 Gereken izinler:
//   • Android 11+  : MANAGE_EXTERNAL_STORAGE (storage_permission_helper.dart kullanın)
//   • Android 10-  : STORAGE izni
// ---------------------------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/file_info.dart';

/// 📤 Download/{appName} klasöründeki yedek dosyaları paylaşır.
///
/// Fonksiyon, `Download/appName` klasörünü kontrol eder:
///  - Dizin yoksa uyarı verir.
///  - Dizin varsa içindeki dosyaları (CSV, JSON, XLSX, SQL vb.) listeler.
///  - Dosya varsa sistemin paylaşım menüsünü açar.
///
/// Log çıktıları konsolda `[share_helper]` etiketiyle görünür.
///
/// ⚠️ Not: Dosya paylaşımı için depolama izni (`ensureStoragePermission()`)
///        önceden verilmiş olmalıdır.
///
Future<void> shareBackupFolder() async {
  const tag = 'share_helper';

  try {
    // 📁 Download dizinini bul
    // ExternalPath artık kullanılmıyor.
    // Android Download klasörü doğrudan hedeflenir.
    const downloadDir = '/storage/emulated/0/Download';

    // Hedef klasör (örnek: /storage/emulated/0/Download/kelimelik_words_app)
    final folderPath = join(downloadDir, appName);
    final dir = Directory(folderPath);

    // 📂 Dizin mevcut mu?
    if (!await dir.exists()) {
      log('⚠️ Dizin bulunamadı: $folderPath', name: tag);
      return;
    }

    // 📜 Dizin içindeki tüm dosyaları al (yalnızca File türündekiler)
    final files = dir.listSync().whereType<File>().toList();

    if (files.isEmpty) {
      log('⚠️ Paylaşılacak dosya bulunamadı.', name: tag);
      return;
    }

    // XFile listesine dönüştür
    final xFiles = files.map((f) => XFile(f.path)).toList();

    // 📤 share_plus kullanarak sistem paylaşım penceresini aç
    await Share.shareXFiles(
      xFiles,
      text: '📂 $appName yedek dosyaları',
    );

    log('✅ Paylaşım ekranı başarıyla açıldı.', name: tag);
    log(logLine, name: tag);
  } catch (e) {
    log('🚨 Paylaşım hatası: $e', name: tag);
    log(logLine, name: tag);
  }
}