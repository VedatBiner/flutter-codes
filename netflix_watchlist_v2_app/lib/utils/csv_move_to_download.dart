// <----- lib/utils/csv_move_to_download.dart ----->

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import 'download_directory_helper.dart';

/// CSV dosyasını app_flutter → Downloads/{appName} dizinine taşır
Future<File?> moveCsvToDownload() async {
  const tag = "csv_move";

  try {
    // 1️⃣ app_flutter dizininden dosyayı bul
    final dir = await getApplicationDocumentsDirectory();
    final sourceFile = File(join(dir.path, fileNameCsv));

    if (!await sourceFile.exists()) {
      log("❌ CSV bulunamadı: ${sourceFile.path}", name: tag);
      return null;
    }

    // 2️⃣ Downloads/{appName} klasörünü hazırla
    final targetDir = await prepareDownloadDirectory(tag: tag);

    if (targetDir == null) {
      log("⚠️ Download dizini hazırlanamadı.", name: tag);
      return null;
    }

    // 3️⃣ Hedef dosya yolu
    final targetFile = File(join(targetDir.path, fileNameCsv));

    // 4️⃣ Kopyala → eskiyi korumak istersen copy kullan
    await sourceFile.copy(targetFile.path);

    log("📁 CSV dışa aktarıldı: ${targetFile.path}", name: tag);

    return targetFile;
  } catch (e, st) {
    log("🚨 CSV taşıma hatası: $e", name: tag, stackTrace: st);
    return null;
  }
}
