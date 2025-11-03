// 📃 <----- lib/utils/fc_files/download_helper.dart ----->
//
// 🎬 Netflix Film List App
// -----------------------------------------------------------
// Download/{appName} dizinine dosyaları kopyalar,
// ardından app_flutter içindeki eski dosyaları temizler.
// Silme işlemi her iki muhtemel internal path (user/0 ve data/data) üzerinde kontrol edilir.
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

Future<void> copyBackupFilesToDownload() async {
  const tag = 'DownloadHelper';

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

    // 🔹 3️⃣ Uygulama içi dizin yollarını kontrol et
    final internalDir = await getApplicationDocumentsDirectory();
    final internalPath1 = internalDir.path; // genelde /data/user/0
    final internalPath2 = internalPath1.replaceFirst(
      "/user/0",
      "/data",
    ); // alternatif yol

    final List<String> fileNames = [
      fileNameCsv,
      fileNameJson,
      fileNameXlsx,
      fileNameSql,
    ];

    // 🔹 4️⃣ Dosyaları kopyala
    for (final name in fileNames) {
      final src = File(join(internalPath1, name));
      final dest = File(join(targetDir.path, name));

      if (await src.exists()) {
        await src.copy(dest.path);
        log('✅ Kopyalandı: $name → ${targetDir.path}', name: tag);
      } else {
        log('⚠️ Kaynak dosya bulunamadı: ${src.path}', name: tag);
      }
    }

    log('🎉 Kopyalama tamamlandı. Şimdi eski dosyalar silinecek...', name: tag);

    // 🔹 5️⃣ Eski dosyaları sil (her iki yoldan kontrol ederek)
    for (final name in fileNames) {
      final path1 = File(join(internalPath1, name));
      final path2 = File(join(internalPath2, name));

      await _safeDelete(path1, tag);
      await _safeDelete(path2, tag);
    }

    log('✅ Tüm eski dosyalar silindi.', name: tag);
    log('📂 Yeni yedekler: ${targetDir.path}', name: tag);
  } catch (e, st) {
    log('🚨 Kopyalama/Silme hatası: $e', name: tag, error: e, stackTrace: st);
  }
}

/// 🗑️ Güvenli silme fonksiyonu
Future<void> _safeDelete(File file, String tag) async {
  if (await file.exists()) {
    try {
      for (int i = 0; i < 3; i++) {
        try {
          await file.delete();
          log('🗑️ Silindi: ${file.path}', name: tag);
          return;
        } catch (e) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
      log('⚠️ Silinemedi (denemeler tükendi): ${file.path}', name: tag);
    } catch (e) {
      log('⚠️ Silme hatası (${file.path}): $e', name: tag);
    }
  }
}
