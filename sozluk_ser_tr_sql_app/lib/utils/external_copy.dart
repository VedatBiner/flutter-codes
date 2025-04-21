import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sozluk_ser_tr_sql_app/constants/file_info.dart';
import 'package:sqflite/sqflite.dart';

Future<void> exportAppDataToExternal() async {
  try {
    /// 📌 Depolama izni iste (Android 10+ için)
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      log("❌ İzin verilmedi: Storage");
      return;
    }

    /// 📁 Kopyalama yapılacak dizin (Download/kelimelik_words_app)
    if (!await extDir.exists()) {
      await extDir.create(recursive: true);
      log("📁 Dizin oluşturuldu: ${extDir.path}");
    }

    // 📁 Uygulamanın dahili klasörü
    final internalDir = await getApplicationDocumentsDirectory();

    final jsonFile = File('${internalDir.path}/$fileNameJson');
    final csvFile = File('${internalDir.path}/$fileNameCsv');
    final dbFile = File('${internalDir.path}/$fileNameSql');

    // 📝 JSON
    if (await jsonFile.exists()) {
      await jsonFile.copy('${extDir.path}/$fileNameJson');
      log('✅ JSON dosyası kopyalandı.');
    }

    // 📝 CSV
    if (await csvFile.exists()) {
      await csvFile.copy('${extDir.path}/$fileNameCsv');
      log('✅ CSV dosyası kopyalandı.');
    }

    // 📝 SQLite DB
    final dbPath = await getDatabasesPath();
    // final dbFile = File('$dbPath/$fileNameSql');

    if (await dbFile.exists()) {
      await dbFile.copy('${extDir.path}/$fileNameSql');
      log('✅ SQL Veritabanı dosyası kopyalandı.');
    } else {
      log("⚠️ SQL veritabanı bulunamadı: $dbPath/$fileNameSql");
    }

    log("🎉 Tüm dosyalar '${extDir.path}' dizinine başarıyla kopyalandı.");
  } catch (e) {
    log("❌ Kopyalama hatası: $e");
  }
}
