// 📃 <----- lib/utils/fc_files/zip_helper.dart ----->

import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';

/// 📚 Belirtilen dosyaları bir zip arşivi olarak oluşturur.
///
/// Bu fonksiyon, uygulamanın documents dizinindeki JSON, CSV, Excel ve SQL
/// dosyalarını bularak bunları tek bir .zip dosyası içinde sıkıştırır.
Future<void> createZipArchive() async {
  const tag = 'zip_helper';
  log('📦 Zipleme işlemi başlatılıyor...', name: tag);

  try {
    // 📂 Dizin ve dosya yollarını al
    final directory = await getApplicationDocumentsDirectory();
    final zipFilePath = join(directory.path, fileNameZip);

    // 🗜️ Zip Encoder oluştur
    final encoder = ZipFileEncoder();
    encoder.create(zipFilePath);

    // 🗂️ Arşivlenecek dosyaların listesi
    final filesToZip = [
      File(join(directory.path, fileNameJson)),
      File(join(directory.path, fileNameCsv)),
      File(join(directory.path, fileNameXlsx)),
      File(join(directory.path, fileNameSql)),
    ];

    //  dosyaları arşive ekle
    for (final file in filesToZip) {
      if (await file.exists()) {
        await encoder.addFile(file);
        log('➕ Arşive eklendi: ${basename(file.path)}', name: tag);
      } else {
        log('⚠️ Dosya bulunamadı, arşive eklenemedi: ${file.path}', name: tag);
      }
    }

    // 🤐 Zip dosyasını kapat
    encoder.close();

    log('✅ Zip arşivi başarıyla oluşturuldu: $zipFilePath', name: tag);
  } catch (e) {
    log('❌ Zipleme sırasında hata oluştu: $e', name: tag);
    // Hata durumunda yeniden fırlatılabilir veya uygun şekilde yönetilebilir.
    rethrow;
  }
}
