// 📃 <----- lib/utils/external_copy.dart ----->
//
// Tüm yedek dosyalarını (CSV, JSON, XLSX, SQL)
// cihazın DOWNLOAD/{appName} klasörüne kopyalar.
//
// Android 10- için storage izni gerekir.
// Android 11+ için MANAGE_EXTERNAL_STORAGE gerekir.
//

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';

Future<String> copyBackupToDownload({
  required List<String> files,
  required String folderName,
}) async {
  const tag = "external_copy";

  // 📁 Download kök yolu
  // ExternalPath artık kullanılmıyor.
  const downloadRoot = '/storage/emulated/0/Download';

  // 📁 Download/{appName}
  final targetDir = Directory(join(downloadRoot, folderName));
  await targetDir.create(recursive: true);

  log("📂 Kopyalama hedefi: ${targetDir.path}", name: tag);

  for (final srcPath in files) {
    final srcFile = File(srcPath);

    if (!await srcFile.exists()) {
      log("⚠️ Dosya bulunamadı, kopyalanmadı: $srcPath", name: tag);
      continue;
    }

    final destPath = join(targetDir.path, basename(srcPath));

    await srcFile.copy(destPath);

    log("✅ Kopyalandı → $destPath", name: tag);
  }

  return targetDir.path;
}

/// 📌 Download kopyalama sonrası geçici klasörü güvenli siler
Future<void> deleteTempBackupFolderIfSafe({
  required String tempDirPath,
  required List<String> expectedFileNames,
  required String downloadDirPath,
}) async {
  const tag = "external_copy_cleanup";

  final tempDir = Directory(tempDirPath);

  if (!await tempDir.exists()) {
    log("ℹ️ Geçici klasör zaten yok: $tempDirPath", name: tag);
    return;
  }

  // 🔎 Download dizininde dosyalar gerçekten var mı?
  bool allFilesExist = true;

  for (final fileName in expectedFileNames) {
    final downloadFile = File(join(downloadDirPath, fileName));

    if (!await downloadFile.exists()) {
      log("❌ Download' da eksik dosya: ${downloadFile.path}", name: tag);
      allFilesExist = false;
      break;
    }
  }

  if (!allFilesExist) {
    log("⚠️ Güvenlik nedeniyle klasör silinmedi.", name: tag);
    return;
  }

  // 🧹 GÜVENLİ SİLME
  await tempDir.delete(recursive: true);

  log("🧹 Geçici klasör silindi: $tempDirPath", name: tag);
}