// 📃 <----- lib/utils/zip_helper.dart ----->
//
// JSON / CSV / XLSX / SQL dosyalarını ZIP haline getirir.
// ZIP dosyası app_flutter dizinine oluşturulur ve tam path döndürülür.
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';

/// 📦 ZIP arşivi oluşturur ve ZIP dosyasının TAM PATH 'ini döndürür.
///
/// ZIP içine eklenen dosyalar:
///   • kelimelik_backup.json
///   • kelimelik_backup.csv
///   • kelimelik_backup.xlsx
///   • kelimelik.db
///
/// Dönüş:
///   → /data/user/0/aa.vb.kelimelik_word_app/app_flutter/kelimelik_backup.zip
Future<String> createZipArchive() async {
  const tag = 'zip_helper';
  log('📦 ZIP oluşturma başlatılıyor...', name: tag);

  // 📂 Uygulama dizini
  final directory = await getApplicationDocumentsDirectory();

  // 📁 ZIP tam yolu (FULL PATH)
  final zipFullPath = join(directory.path, fileNameZip);
  log('📁 ZIP dizini  : ${directory.path}', name: tag);
  log('📄 ZIP dosyası : $zipFullPath', name: tag);

  // 🗜️ ZIP Encoder
  final encoder = ZipFileEncoder();
  encoder.create(zipFullPath);

  // 🗂 Arşive eklenecek dosyalar
  final filesToZip = [
    File(join(directory.path, fileNameJson)),
    File(join(directory.path, fileNameCsv)),
    File(join(directory.path, fileNameXlsx)),
    File(join(directory.path, fileNameSql)),
  ];

  // 🔍 Dosyaları tek tek ekle
  for (final file in filesToZip) {
    final fileName = basename(file.path);

    // ✔ Dosya var mı kontrol et
    if (await file.exists()) {
      encoder.addFile(file);
      log('➕ Eklendi → $fileName', name: tag);
    } else {
      log('⚠️ Dosya bulunamadı, eklenemedi → ${file.path}', name: tag);
    }
  }

  // 🤐 ZIP kapat
  encoder.close();

  // ✔ Güvenlik kontrolü
  if (!await File(zipFullPath).exists()) {
    log('❌ ZIP oluşturulamadı! (Dosya bulunamadı)', name: tag);
  } else {
    // log('✅ ZIP başarıyla oluşturuldu: $zipFullPath', name: tag);
  }

  return zipFullPath; // FULL PATH DÖNÜYOR! 🔥
}
