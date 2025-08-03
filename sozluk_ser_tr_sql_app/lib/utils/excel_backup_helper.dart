// 📃 lib/utils/excel_backup_helper.dart
//
// Tüm kelimeleri okuyup bir .xlsx dosyası olarak saklar.
// Dönen değer: oluşturulan dosyanın tam yolu.

// 📌 Dart hazır paketleri
import 'dart:developer';
import 'dart:io';

/// 📌 Flutter hazır paketleri
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';

/// 📌 Yardımcı yüklemeler burada
import '../db/db_helper.dart';
import '../models/word_model.dart';

/// 📌 Veritabanındaki malzemeleri Excel ’e (xlsx) yazar.
Future<String> createExcelBackup() async {
  log('🔄 excel_backup_helper çalıştı', name: 'XLSX');
  // 1️⃣ Yeni bir Excel nesnesi oluştur
  final excel = Excel.createExcel();

  // 2️⃣ "Kelimeler" adlı sayfayı al (eğer yoksa oluşturulur)
  final Sheet sheet = excel['Malzemeler'];

  // 3️⃣ Başlık satırını ekle
  sheet.appendRow(['Malzeme', 'Miktar', 'Açıklama']);

  // 4️⃣ Veritabanından tüm kelimeleri al
  final List<Word> words = await DbHelper.instance.getRecords();

  // 5️⃣ Her kelimeyi satır satır ekle
  for (final w in words) {
    sheet.appendRow([w.sirpca, w.turkce ?? 0, w.userEmail ?? '']);
  }

  // 6️⃣ Dosyayı uygulama belgeler dizinine yaz
  final dir = await getApplicationDocumentsDirectory();
  final filePath = '${dir.path}/$fileNameExcel';
  final bytes = excel.encode();
  if (bytes == null) {
    throw Exception('Excel dosyası oluşturulamadı.');
  }
  final file =
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes);

  return filePath;
}
