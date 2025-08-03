// 📃 <----- csv_backup.dart ----->
// custom_drawer.dart içinden çağırılıyor.
// CSV formatında yedek alıyor.

import 'dart:developer';

import '../db/db_helper.dart';

Future<String> createCsvBackup() async {
  final path = await DbHelper.instance.exportRecordsToCsv();
  log('📁 CSV dosya konumu: $path', name: 'CSV');

  return path;
}
