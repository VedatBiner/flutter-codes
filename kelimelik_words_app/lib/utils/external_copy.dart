// 📃 <----- lib/utils/external_copy.dart ----->
//
// Tüm yedek dosyalarını (CSV, JSON, XLSX, SQL, ZIP)
// cihazın DOWNLOAD/{appName} klasörüne kopyalar.
//
// Android 10- için storage izni gerekir.
// Android 11+ için MANAGE_EXTERNAL_STORAGE gerekir.
//

import 'dart:developer';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path/path.dart';

Future<String> copyBackupToDownload({
  required List<String> files,
  required String folderName,
}) async {
  const tag = "external_copy";

  // 📁 Download kök yolu
  final downloadRoot = await ExternalPath.getExternalStoragePublicDirectory(
    ExternalPath.DIRECTORY_DOWNLOAD,
  );

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
