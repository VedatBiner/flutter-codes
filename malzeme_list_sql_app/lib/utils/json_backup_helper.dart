// 📃 <----- json_backup.dart ----->
// custom_drawer.dart içinden çağırılıyor.
// JSON formatında yedek alıyor.

import 'dart:developer';

/// 📌 Yardımcı yüklemeler burada
import '../db/db_helper.dart';

Future<String> createJsonBackup() async {
  final path = await MalzemeDatabase.instance.exportWordsToJson();
  log('📁 JSON dosya konumu: $path', name: 'JSON');
  return path;
}
