// 📃 <----- external_copy.dart ----->
//

import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sozluk_ser_tr_sql_app/constants/file_info.dart';

Future<void> exportAppDataToExternal() async {
  try {
    /// 📌 İzin kontrolü (Android 10+)
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      log("❌ İzin verilmedi: Storage");
      return;
    }

    /// 📂 Dış dizini oluştur
    if (!await extDir.exists()) {
      await extDir.create(recursive: true);
    }

    /// 📁 Dahili dizin
    final internalDir = await getApplicationDocumentsDirectory();

    final jsonFile = File('${internalDir.path}/$fileNameJson');
    final csvFile = File('${internalDir.path}/$fileNameCsv');

    /// ✅ JSON yedeği kopyala
    if (await jsonFile.exists()) {
      await jsonFile.copy('${extDir.path}/$fileNameJson');
      log('✅ JSON dosyası kopyalandı.');
    }

    /// ✅ CSV yedeği kopyala
    if (await csvFile.exists()) {
      await csvFile.copy('${extDir.path}/$fileNameCsv');
      log('✅ CSV dosyası kopyalandı.');
    }

    log("🎉 Tüm dosyalar dış dizine kopyalandı (SQL hariç).");
  } catch (e) {
    log("❌ Kopyalama hatası: $e");
  }
}
