// 📃 <----- csv_backup.dart ----->
// custom_drawer.dart içinden çağırılıyor.
// CSV formatında yedek alıyor.

// 📌 Flutter hazır paketleri
import 'dart:developer';

/// 📌 Yardımcı yüklemeler burada
import '../db/word_database.dart';

Future<String> createCsvBackup() async {
  final path = await WordDatabase.instance.exportWordsToCsv();
  log('📁 CSV dosya konumu: $path', name: 'CSV');

  return path;
}
