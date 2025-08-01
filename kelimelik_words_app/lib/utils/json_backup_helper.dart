// 📃 <----- json_backup.dart ----->
// custom_drawer.dart içinden çağırılıyor.
// JSON formatında yedek alıyor.

import 'dart:developer';

/// 📌 Yardımcı yüklemeler burada
import '../db/db_helper.dart';

Future<String> createJsonBackup() async {
  log('🔄 json_backup_helper çalıştı', name: 'JSON');
  final path = await WordDatabase.instance.exportWordsToJson();
  return path;
}
