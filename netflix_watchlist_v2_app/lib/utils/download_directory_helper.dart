// <----- lib/utils/fc_files/download_directory_helper.dart ----->

import 'dart:developer';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path/path.dart';

import '../../constants/file_info.dart';
import '../utils/storage_permission_helper.dart';

/// Download/{appName} klasörünü hazırlar:
///  • Depolama izni ister
///  • Download/{appName} dizinini oluşturur
///  • Oluşturulan Directory nesnesini döndürür
///
/// HATA DURUMUNDA: null döner.
Future<Directory?> prepareDownloadDirectory({
  String tag = "download_helper",
}) async {
  // 1️⃣ Depolama izni kontrolü
  if (!await ensureStoragePermission()) {
    log("❌ Depolama izni verilmedi.", name: tag);
    return null;
  }

  // 2️⃣ Download/<appName> klasörü yolunu al
  final downloadDir = await ExternalPath.getExternalStoragePublicDirectory(
    ExternalPath.DIRECTORY_DOWNLOAD,
  );

  final targetDir = Directory(join(downloadDir, appName));

  // 3️⃣ Yoksa oluştur
  if (!await targetDir.exists()) {
    await targetDir.create(recursive: true);
    log("📁 Download klasörü oluşturuldu: ${targetDir.path}", name: tag);
  }

  return targetDir;
}
