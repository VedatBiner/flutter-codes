// 📃 <----- lib/utils/zip_helper.dart ----->
//
// ZIP oluşturma helper
// -----------------------------------------------------------
// • JSON, CSV, XLSX ve veritabanı dosyasını tek bir ZIP 'e toplar
// • Dosya yollarını ayrıntılı şekilde loglar
// • ZIP dosyası app_flutter klasöründe oluşturulur
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';

Future<String> createZipArchive() async {
  const tag = 'zip_helper';
  log('📦 ZIP oluşturma başlatılıyor...', name: tag);

  try {
    // 📂 Uygulama Documents klasörü (app_flutter burada)
    final directory = await getApplicationDocumentsDirectory();
    final appPath = directory.path;

    log('📁 ZIP dizini: $appPath', name: tag);

    // ZIP dosyasının yolu
    final zipPath = join(appPath, fileNameZip);
    log('📌 ZIP çıkış yolu: $zipPath', name: tag);

    final encoder = ZipFileEncoder();
    encoder.create(zipPath);

    // Arşivlenecek dosyalar
    final files = {
      'JSON': File(join(appPath, fileNameJson)),
      'CSV': File(join(appPath, fileNameCsv)),
      'Excel': File(join(appPath, fileNameXlsx)),
      'SQL': File(join(appPath, fileNameSql)),
    };

    for (final entry in files.entries) {
      final type = entry.key;
      final file = entry.value;

      log('🔍 Kontrol: ${file.path}', name: tag);

      if (await file.exists()) {
        encoder.addFile(file);
        log('➕ Eklendi → $type: ${basename(file.path)}', name: tag);
      } else {
        log('⚠️ Yok → $type dosyası bulunamadı: ${file.path}', name: tag);
      }
    }

    encoder.close();
    log('✅ ZIP başarıyla oluşturuldu: $zipPath', name: tag);
    log(logLine, name: tag);

    return zipPath;
  } catch (e, st) {
    log('❌ ZIP oluşturulamadı: $e', name: tag, error: e, stackTrace: st);
    rethrow;
  }
}
