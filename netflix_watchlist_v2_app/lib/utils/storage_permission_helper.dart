// 📃 <----- lib/utils/storage_permission_helper.dart ----->

import 'dart:developer';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// 📌 Depolama iznini kontrol eder veya ister.
/// ✅ True → izin zaten var ya da yeni verildi.
/// ❌ False → reddedildi.
///
/// Not:
/// - Android 10 ve altı: Permission.storage
/// - Android 11+: Permission.manageExternalStorage (gerekliyse)
Future<bool> ensureStoragePermission({bool requestIfDenied = true}) async {
  const tag = 'storage_permission_helper';

  // Android dışı platformlarda izin gerekmiyor varsayımı
  if (!Platform.isAndroid) return true;

  // ------------------------------------------------------------
  // 1) Android 10 ve altı için klasik storage izni
  // ------------------------------------------------------------
  final storageStatus = await Permission.storage.status;
  if (storageStatus.isGranted) {
    log('✅ storage izni zaten verilmiş', name: tag);
    return true;
  }

  // ------------------------------------------------------------
  // 2) Android 11+ için geniş izin (Manage all files)
  // ------------------------------------------------------------
  final manageStatus = await Permission.manageExternalStorage.status;
  if (manageStatus.isGranted) {
    log('✅ manageExternalStorage izni zaten verilmiş', name: tag);
    return true;
  }

  if (!requestIfDenied) return false;

  // Önce Android 10- için storage iste (bazı cihazlarda yeterli olabiliyor)
  final requestedStorage = await Permission.storage.request();
  if (requestedStorage.isGranted) {
    log('✔️ storage izni şimdi verildi', name: tag);
    return true;
  }

  // Sonra Android 11+ için manageExternalStorage iste
  final requestedManage = await Permission.manageExternalStorage.request();
  if (requestedManage.isGranted) {
    log('✔️ manageExternalStorage izni şimdi verildi', name: tag);
    return true;
  }

  log('❌ Depolama izni reddedildi (storage & manageExternalStorage)', name: tag);

  // İstersen burada ayarlara yönlendirme eklenebilir:
  // await openAppSettings();

  return false;
}
