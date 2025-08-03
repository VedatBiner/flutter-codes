// 📃 <----- json_backup.dart ----->
// custom_drawer.dart içinden çağırılıyor.
// JSON formatında yedek alıyor.

import 'dart:developer';

import '../db/db_helper.dart';

Future<String> createJsonBackup() async {
  final path = await DbHelper.instance.exportRecordsToJson();
  log('📁 JSON dosya konumu: $path', name: 'JSON');
  return path;
}
