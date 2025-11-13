// 📃 <----- lib/utils/storage_permission_helper.dart ----->
//
// 📦 Depolama izin yöneticisi (Permission Manager)
//
//  • Android 11+  →  Permission.manageExternalStorage
//  • Android 10-  →  Permission.storage
//  • Diğer platformlarda otomatik true döner
//
// Bu fonksiyon her çağrıldığında önce mevcut durumu kontrol eder,
// sadece gerekli olduğunda izin ister. Böylece tekrar tekrar sormaz.
//

import 'dart:developer';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// 📌 Depolama iznini kontrol eder veya ister.
/// ✅ True → izin zaten var ya da yeni verildi.
/// ❌ False → reddedildi.
Future<bool> ensureStoragePermission({bool requestIfDenied = true}) async {
  const tag = 'storage_permission_helper';

  // 💻 Android dışı platformlarda izin gerekmez
  if (!Platform.isAndroid) return true;

  // 🔍 1️⃣ Geniş izin (Android 11+)
  var status = await Permission.manageExternalStorage.status;
  if (status.isGranted) {
    log('✅ manageExternalStorage izni zaten verilmiş', name: tag);
    return true;
  }

  // 🔍 2️⃣ Eski izin (Android 10 ve öncesi)
  status = await Permission.storage.status;
  if (status.isGranted) {
    log('✅ storage izni zaten verilmiş', name: tag);
    return true;
  }

  // ⚠️ Eğer kullanıcıdan istemek gerekirse (isteğe bağlı)
  if (requestIfDenied) {
    final requested = await Permission.manageExternalStorage.request();
    if (requested.isGranted) {
      log('✔️ manageExternalStorage izni şimdi verildi', name: tag);
      return true;
    }

    final legacyRequested = await Permission.storage.request();
    if (legacyRequested.isGranted) {
      log('✔️ storage izni şimdi verildi (legacy)', name: tag);
      return true;
    }

    log('❌ Depolama izni reddedildi', name: tag);
  }

  return false;
}
