// 📃 <----- csv_backup.dart ----->
// custom_drawer.dart içinden çağırılıyor.
// CSV formatında yedek alıyor.

import 'dart:developer';

/// 📌 Yardımcı yüklemeler burada
import '../db/word_database.dart';

Future<String> createCsvBackup() async {
  log('🔄 csv_backup_helper çalıştı', name: 'CSV');
  final path = await WordDatabase.instance.exportWordsToCsv();
  return path;
}
