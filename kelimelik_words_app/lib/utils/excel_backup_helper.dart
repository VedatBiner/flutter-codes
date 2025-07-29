// 📃 lib/utils/excel_backup_helper.dart
//
// Tüm kelimeleri okuyup bir .xlsx dosyası olarak saklar.
// Dönen değer: oluşturulan dosyanın tam yolu.

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import '../db/word_database.dart';
import '../models/word_model.dart';

/// 📌 Veritabanındaki kelimeleri Excel ’e (xlsx) yazar.
Future<String> createExcelBackup() async {
  // 1️⃣ Yeni bir Excel nesnesi oluştur
  final excel = Excel.createExcel();

  // 2️⃣ "Kelimeler" adlı sayfayı al (eğer yoksa oluşturulur)
  final Sheet sheet = excel['Kelimeler'];

  // 3️⃣ Başlık satırını ekle
  sheet.appendRow(['Kelime', 'Anlam']);

  // 4️⃣ Veritabanından tüm kelimeleri al
  final List<Word> words = await WordDatabase.instance.getWords();

  // 5️⃣ Her kelimeyi satır satır ekle
  for (final w in words) {
    sheet.appendRow([w.word, w.meaning]);
  }

  // 6️⃣ Dosyayı uygulama belgeler dizinine yaz
  final dir = await getApplicationDocumentsDirectory();
  final filePath = '${dir.path}/kelimelik_backup.xlsx';
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
