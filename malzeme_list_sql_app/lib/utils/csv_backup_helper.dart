// 📃 <----- csv_backup.dart ----->
// custom_drawer.dart içinden çağırılıyor.
// CSV formatında yedek alıyor.

// 📌 Flutter hazır paketleri
import 'dart:developer';

/// 📌 Yardımcı yüklemeler burada
import '../db/db_helper.dart';

Future<String> createCsvBackup() async {
  final path = await MalzemeDatabase.instance.exportWordsToCsv();
  log('📁 CSV dosya konumu: $path', name: 'CSV');

  return path;
}
