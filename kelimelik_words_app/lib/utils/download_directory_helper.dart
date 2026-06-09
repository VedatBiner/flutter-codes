// 📃 <----- download_directory_helper.dart ----->

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';

import '../../constants/file_info.dart';
import 'storage_permission_helper.dart';

Future<Directory?> prepareDownloadDirectory({
  String tag = "download_directory_helper",
}) async {
  // 1️⃣ Depolama izni kontrolü
  if (!await ensureStoragePermission()) {
    log("❌ Depolama izni verilmedi.", name: tag);
    return null;
  }

  // 2️⃣ Download klasörü
  final targetDir = Directory(
    join('/storage/emulated/0/Download', appName),
  );

  // 3️⃣ Yoksa oluştur
  if (!await targetDir.exists()) {
    await targetDir.create(recursive: true);

    log(
      "📁 Download klasörü oluşturuldu: ${targetDir.path}",
      name: tag,
    );
  }

  return targetDir;
}