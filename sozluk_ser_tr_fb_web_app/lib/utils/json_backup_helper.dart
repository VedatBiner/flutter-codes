// 📃 <----- json_backup.dart ----->
// custom_drawer.dart içinden çağırılıyor.
// JSON formatında yedek alıyor.

// 📌 Dart hazır paketleri
import 'dart:developer';

/// 📌 Yardımcı yüklemeler burada
import '../services/db_helper.dart';

Future<String> createJsonBackup() async {
  log('🔄 json_backup_helper çalıştı', name: 'JSON');
  final path = await DbHelper.instance.exportRecordsToJson();

  return path;
}
