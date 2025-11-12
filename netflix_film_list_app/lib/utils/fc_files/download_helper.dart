// 📃 <----- lib/utils/fc_files/download_helper.dart ----->
//
// 🎬 Netflix Film List App
// -----------------------------------------------------------
// Download/{appName} dizinine CSV, JSON, Excel ve SQL dosyalarını kopyalar.
// Ardından app_flutter içindeki eski kopyaları güvenli şekilde siler.
//
// Özellikler:
//  • Android 11+ için manageExternalStorage izni kontrolü
//  • Download klasörünü otomatik oluşturur
//  • /data/user/0 ve /data/data yollarını ayrı ayrı kontrol eder
//  • Silme işlemini güvenli ve tekrarlı şekilde yapar
//  • Başarılı, uyarı ve hata log 'larını detaylı gösterir
//
// -----------------------------------------------------------

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';
import '../storage_permission_helper.dart';

/// 📦 Yedek dosyaları cihazın Download/{appName} klasörüne taşır.
///
/// - Önce depolama iznini kontrol eder.
/// - Download/{appName} klasörünü oluşturur (yoksa).
/// - `app_flutter` dizininden CSV, JSON, Excel ve SQL dosyalarını kopyalar.
/// - Kopyalama tamamlandıktan sonra eski dosyaları siler.
///
/// Bu işlem sırasında hem `/data/user/0/...` hem de `/data/data/...` yolları kontrol edilir.
Future<void> copyBackupFilesToDownload() async {
  const tag = 'download_helper';

  try {
    // 🔹 1️⃣ Depolama izni kontrolü
    if (!await ensureStoragePermission()) {
      log('❌ Depolama izni verilmedi. Kopyalama iptal edildi.', name: tag);
      return;
    }

    // 🔹 2️⃣ Download/{appName} dizinini oluştur
    final downloadDir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );
    final targetDir = Directory(join(downloadDir, appName));

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
      log('📁 Download klasörü oluşturuldu: ${targetDir.path}', name: tag);
    }

    // 🔹 3️⃣ Dahili uygulama dizinlerini kontrol et
    final internalDir = await getApplicationDocumentsDirectory();
    final internalPath1 =
        internalDir.path; // örn: /data/user/0/com.example.app/app_flutter
    final internalPath2 = internalPath1.replaceFirst(
      "/user/0",
      "/data",
    ); // alternatif

    final List<String> fileNames = [
      fileNameCsv,
      fileNameJson,
      fileNameXlsx,
      fileNameSql,
      fileNameZip,
    ];

    log('📦 Kopyalanacak dosyalar: ${fileNames.join(", ")}', name: tag);

    // 🔹 4️⃣ Kopyalama işlemini başlat
    int copiedCount = 0;
    for (final name in fileNames) {
      final src = File(join(internalPath1, name));
      final dest = File(join(targetDir.path, name));

      if (await src.exists()) {
        await src.copy(dest.path);
        copiedCount++;
        log('✅ Kopyalandı: $name → ${targetDir.path}', name: tag);
      } else {
        log('⚠️ Kaynak dosya bulunamadı: ${src.path}', name: tag);
      }
    }

    log(
      '🎉 $copiedCount / ${fileNames.length} dosya başarıyla kopyalandı.',
      name: tag,
    );
    log('🧹 Şimdi eski dosyalar silinecek...', name: tag);

    // 🔹 5️⃣ Eski dosyaları güvenle sil (her iki path üzerinde)
    await _deleteOldFiles(fileNames, internalPath1, internalPath2, tag);

    log('✅ Tüm eski dosyalar temizlendi.', name: tag);
    log('📂 Yeni yedekler: ${targetDir.path}', name: tag);
  } catch (e, st) {
    log('🚨 Kopyalama/Silme hatası: $e', name: tag, error: e, stackTrace: st);
  }
}

/// 🗑️ Eski dosyaları güvenle silen yardımcı fonksiyon.
///
/// Her dosya için iki olası internal path kontrol edilir.
/// Silme işlemi 3 kez denenir, her deneme arasında 100 ms bekleme vardır.
Future<void> _deleteOldFiles(
  List<String> fileNames,
  String internalPath1,
  String internalPath2,
  String tag,
) async {
  for (final name in fileNames) {
    final file1 = File(join(internalPath1, name));
    final file2 = File(join(internalPath2, name));

    await _safeDelete(file1, tag);
    await _safeDelete(file2, tag);
  }
}

/// 🧩 Tek bir dosyayı güvenli şekilde siler.
/// Silme başarısız olursa, 3 denemeye kadar tekrarlar.
Future<void> _safeDelete(File file, String tag) async {
  if (await file.exists()) {
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        await file.delete();
        log('🗑️ Silindi: ${file.path}', name: tag);
        return;
      } catch (e) {
        log('⚠️ ${file.path} silinemedi (deneme $attempt).', name: tag);
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
    log('⚠️ Silinemedi (3 deneme başarısız): ${file.path}', name: tag);
  }
}
