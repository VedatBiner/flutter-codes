// 📃 <----- json_backup.dart ----->
// custom_drawer.dart içinden çağırılıyor.
// JSON formatında yedek alıyor.

import 'dart:developer';

/// 📌 Yardımcı yüklemeler burada
import '../db/word_database.dart';

Future<String> createJsonBackup() async {
  final path = await WordDatabase.instance.exportWordsToJson();
  log('📁 JSON dosya konumu: $path', name: 'JSON');
  return path;
}
