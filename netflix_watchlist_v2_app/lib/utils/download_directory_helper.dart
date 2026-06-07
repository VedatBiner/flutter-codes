// <----- lib/utils/download_directory_helper.dart ----->
//
// ============================================================================
// 📂 Download Directory Helper
// ============================================================================
//
// Bu yardımcı dosya uygulamanın kullanacağı:
//
//   Download/{appName}
//
// klasörünü hazırlamak için kullanılır.
//
// ---------------------------------------------------------------------------
// 🎯 Amaç
// ---------------------------------------------------------------------------
// • Depolama iznini kontrol etmek
// • Download klasörüne erişmek
// • Download/{appName} dizinini oluşturmak
// • Oluşturulan Directory nesnesini döndürmek
//
// ---------------------------------------------------------------------------
// 🧠 Mimari Not
// ---------------------------------------------------------------------------
// Bu dosya yalnızca klasör hazırlama işinden sorumludur.
//
// Yapmaz:
// ❌ Dosya üretmez
// ❌ CSV oluşturmaz
// ❌ JSON oluşturmaz
// ❌ XLSX oluşturmaz
//
// Bu işlemler ExportRepository / ExportFileService tarafında yapılır.
//
// ============================================================================

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';

import '../constants/file_info.dart';
import 'storage_permission_helper.dart';

/// ==========================================================================
/// 📂 prepareDownloadDirectory()
/// ==========================================================================
///
/// Download/{appName} klasörünü hazırlar.
///
/// İş Akışı:
///
/// 1️⃣ Depolama iznini kontrol eder
/// 2️⃣ Download dizinine erişir
/// 3️⃣ Download/{appName} yolunu oluşturur
/// 4️⃣ Klasör yoksa oluşturur
/// 5️⃣ Directory nesnesini döndürür
///
/// Başarısız olursa:
/// • null döner
///
/// Kullanıldığı Yerler:
/// • HomePage açılışında
/// • Export işlemlerinden önce
/// • Paylaşım işlemlerinde
///
/// ==========================================================================
Future<Directory?> prepareDownloadDirectory({
  String tag = "download_helper",
}) async {
  try {
    // ----------------------------------------------------------------------
    // 1️⃣ Depolama izni kontrolü
    // ----------------------------------------------------------------------
    if (!await ensureStoragePermission()) {
      log("❌ Depolama izni verilmedi.", name: tag);
      return null;
    }

    // ----------------------------------------------------------------------
    // 2️⃣ Download klasörü
    // ----------------------------------------------------------------------
    //
    // external_path paketi kaldırıldığı için artık doğrudan
    // Android Download dizinini kullanıyoruz.
    //
    // Android:
    //   /storage/emulated/0/Download
    //
    final downloadDir = Directory(
      '/storage/emulated/0/Download',
    );

    // ----------------------------------------------------------------------
    // 3️⃣ Download/{appName}
    // ----------------------------------------------------------------------
    final targetDir = Directory(
      join(downloadDir.path, appName),
    );

    // ----------------------------------------------------------------------
    // 4️⃣ Klasör yoksa oluştur
    // ----------------------------------------------------------------------
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);

      log(
        "📁 Download klasörü oluşturuldu: ${targetDir.path}",
        name: tag,
      );
    } else {
      log(
        "📁 Download klasörü hazır: ${targetDir.path}",
        name: tag,
      );
    }

    // ----------------------------------------------------------------------
    // 5️⃣ Sonuç
    // ----------------------------------------------------------------------
    return targetDir;
  } catch (e) {
    log(
      "❌ Download klasörü hazırlanamadı: $e",
      name: tag,
    );

    return null;
  }
}