// 📃 <----- csv_backup.dart ----->
// custom_drawer.dart içinden çağırılıyor.
// CSV formatında yedek alıyor.

// 📌 Flutter hazır paketleri
import 'dart:developer';

/// 📌 Yardımcı yüklemeler burada
import '../db/db_helper.dart';

Future<String> createCsvBackup() async {
  log('🔄 csv_backup_helper çalıştı', name: 'CSV');
  final path = await DbHelper.instance.exportWordsToCsv();
  return path;
}
