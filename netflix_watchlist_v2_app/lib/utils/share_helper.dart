// 📃 <----- lib/utils/share_helper.dart ----->
//
// ============================================================================
// 📤 ShareHelper – Yedek Dosyaları Paylaşma Yardımcısı
// ============================================================================
//
// Bu yardımcı dosya, uygulama tarafından oluşturulan yedek dosyaları
// (CSV, JSON, Excel, SQL vb.) kolayca paylaşmak için tasarlanmıştır.
//
// ---------------------------------------------------------------------------
// 🔹 İşlev: shareBackupFolder()
// ---------------------------------------------------------------------------
//   → Download/{appName} klasöründeki tüm dosyaları kontrol eder.
//   → Dosyalar varsa share_plus paketiyle sistem paylaşım ekranını açar.
//
// ---------------------------------------------------------------------------
// 🔹 Özellikler
// ---------------------------------------------------------------------------
// • assets değil, cihazın Download klasörünü hedef alır.
// • Dosya listesi otomatik oluşturulur.
// • Dosya yoksa veya dizin yoksa konsola bilgilendirici log düşer.
// • external_path paketi kullanılmaz.
// • Android Download klasörü doğrudan:
//     /storage/emulated/0/Download
//   üzerinden hedeflenir.
//
// ---------------------------------------------------------------------------
// 🔹 Kullanım Örneği
// ---------------------------------------------------------------------------
//   import '../utils/share_helper.dart';
//   await shareBackupFolder();
//
// ---------------------------------------------------------------------------
// 🔹 Gereken izinler
// ---------------------------------------------------------------------------
// • Android 11+ : storage_permission_helper.dart ile yönetilir.
// • Android 10- : STORAGE izni gerekir.
// ---------------------------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/file_info.dart';

/// ============================================================================
/// 📤 shareBackupFolder()
/// ============================================================================
///
/// Download/{appName} klasöründeki yedek dosyaları paylaşır.
///
/// Fonksiyon akışı:
/// 1️⃣ Download/{appName} klasör yolunu oluşturur.
/// 2️⃣ Klasör mevcut mu kontrol eder.
/// 3️⃣ Klasördeki yalnızca File türündeki öğeleri listeler.
/// 4️⃣ Dosya yoksa log yazar ve çıkar.
/// 5️⃣ Dosya varsa XFile listesine dönüştürür.
/// 6️⃣ share_plus ile sistem paylaşım penceresini açar.
///
/// Log çıktıları konsolda `[share_helper]` etiketiyle görünür.
///
/// ⚠️ Not:
/// Dosya paylaşımı için depolama izni (`ensureStoragePermission()`)
/// normalde export veya klasör hazırlama aşamasında verilmiş olmalıdır.
///
/// ============================================================================
Future<void> shareBackupFolder() async {
  const tag = 'share_helper';

  try {
    // ------------------------------------------------------------------------
    // 📁 1️⃣ Download/{appName} klasör yolunu oluştur
    // ------------------------------------------------------------------------
    //
    // external_path paketi kaldırıldığı için Android Download dizinini
    // doğrudan kullanıyoruz.
    //
    // Örnek:
    // /storage/emulated/0/Download/netflix_watchlist_v2_app
    //
    final folderPath = join(
      '/storage/emulated/0/Download',
      appName,
    );

    final dir = Directory(folderPath);

    // ------------------------------------------------------------------------
    // 📂 2️⃣ Dizin mevcut mu?
    // ------------------------------------------------------------------------
    if (!await dir.exists()) {
      log('⚠️ Dizin bulunamadı: $folderPath', name: tag);
      log(logLine, name: tag);
      return;
    }

    // ------------------------------------------------------------------------
    // 📜 3️⃣ Dizin içindeki tüm dosyaları al
    // ------------------------------------------------------------------------
    //
    // whereType<File>() sayesinde klasörler veya farklı entity tipleri
    // otomatik elenir.
    //
    final files = dir.listSync().whereType<File>().toList();

    if (files.isEmpty) {
      log('⚠️ Paylaşılacak dosya bulunamadı.', name: tag);
      log(logLine, name: tag);
      return;
    }

    // ------------------------------------------------------------------------
    // 📦 4️⃣ File → XFile dönüşümü
    // ------------------------------------------------------------------------
    //
    // share_plus, dosya paylaşımı için XFile listesi bekler.
    //
    final xFiles = files.map((f) => XFile(f.path)).toList();

    // ------------------------------------------------------------------------
    // 📤 5️⃣ Sistem paylaşım penceresini aç
    // ------------------------------------------------------------------------
    //
    // Önemli:
    // Çoklu dosya paylaşımında bazı Android sürümleri / emulator görüntüleri
    // android.intent.extra.TEXT için aşağıdaki uyarıyı loglayabiliyor:
    //
    //   expected ArrayList<java.lang.CharSequence> but value was String
    //
    // Paylaşım işlevini genellikle bozmaz; ancak log kirliliği oluşturur.
    // Bu yüzden çoklu dosya paylaşımında `text:` parametresi kullanılmıyor.
    //
    await Share.shareXFiles(
      xFiles,
    );

    log('✅ Paylaşım ekranı başarıyla açıldı.', name: tag);
    log(logLine, name: tag);
  } catch (e, st) {
    log(
      '🚨 Paylaşım hatası: $e',
      name: tag,
      error: e,
      stackTrace: st,
    );
    log(logLine, name: tag);
  }
}