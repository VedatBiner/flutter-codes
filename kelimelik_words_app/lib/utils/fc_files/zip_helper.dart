// 📃 <----- lib/utils/fc_files/zip_helper.dart ----->
//
//  Verilen dosya listesi ile ZIP oluşturur.
//  Artık: createZipArchive(files: [...]) şeklinde çağrılır.
//
//  NOT:
//  • ZIP systemTemp içine oluşturulur (Android için güvenli).
//  • Hata yoksa tam ZIP yolu döner.
//

import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart';

import '../../constants/file_info.dart';

const _tag = "zip_helper";

/// 📦 Verilen dosya listesiyle ZIP oluşturur.
/// Örnek:
/// final zipPath = await createZipArchive(files: [jsonFull, csvFull, ...]);
Future<String> createZipArchive({required List<String> files}) async {
  final encoder = ZipFileEncoder();

  // Geçici bir klasör oluştur (Android ’de güvenli yol)
  final Directory baseDir = await Directory.systemTemp.createTemp();
  final zipPath = join(baseDir.path, fileNameZip);

  encoder.create(zipPath);

  for (final filePath in files) {
    final file = File(filePath);

    if (await file.exists()) {
      encoder.addFile(file);
      log("📦 ZIP ’e eklendi: $filePath", name: _tag);
    } else {
      log("⚠️ ZIP ’e eklenemedi (dosya yok): $filePath", name: _tag);
    }
  }

  encoder.close();
  log("🎁 ZIP oluşturuldu: $zipPath", name: _tag);

  return zipPath;
}
