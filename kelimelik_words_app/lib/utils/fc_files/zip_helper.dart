// 📃 <----- lib/utils/fc_files/zip_helper.dart ----->

import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart';

import '../../constants/file_info.dart';

const _tag = "zip_helper";

/// Verilen dosya listesiyle ZIP oluşturur.
/// files içinde verilen TAM YOLLAR zip 'e eklenir.
/// ZIP daima device Documents içine değil → çağıran dosyanın belirttiği
/// path 'e yazılır.
Future<String> createZipArchive({
  required List<String> files,
  required String outputDir, // 🔥 ZIP ’in nereye yazılacağı
}) async {
  final zipPath = join(outputDir, fileNameZip);

  final encoder = ZipFileEncoder();
  encoder.create(zipPath);

  for (final filePath in files) {
    final file = File(filePath);

    if (await file.exists()) {
      encoder.addFile(file);
      log("📦 ZIP’e eklendi: $filePath", name: _tag);
    } else {
      log("⚠️ ZIP’e eklenemedi (dosya yok): $filePath", name: _tag);
    }
  }

  encoder.close();
  log("🎁 ZIP oluşturuldu: $zipPath", name: _tag);

  return zipPath;
}
