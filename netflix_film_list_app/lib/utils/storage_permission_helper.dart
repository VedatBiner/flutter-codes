// 📃 <----- lib/utils/storage_permission_helper.dart ----->
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// 📌 Depolama izinlerini Android sürümüne göre doğru bir şekilde yönetir.
///
/// Geri dönüş:
/// - `true`  → İzin mevcut veya şimdi verildi.
/// - `false` → İzin reddedildi veya kalıcı olarak engellendi.
Future<bool> ensureStoragePermission() async {
  const tag = 'storage_permission';

  // ✅ Android dışı platformlarda izin gerekmez.
  if (!Platform.isAndroid) {
    log('ℹ️ Android dışı platform, izin gereksiz.', name: tag);
    return true;
  }

  // Cihazın Android sürümünü (SDK int) güvenilir bir şekilde alalım.
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final sdkInt = androidInfo.version.sdkInt;
  log('ℹ️ Android SDK versiyonu: $sdkInt', name: tag);

  Permission permission;
  // Android 11 (SDK 30) ve üzeri için farklı bir izin gerekiyor.
  if (sdkInt >= 30) {
    permission = Permission.manageExternalStorage;
    log(
      'ℹ️ Android 11+ → "manageExternalStorage" izni kontrol edilecek.',
      name: tag,
    );
  } else {
    permission = Permission.storage;
    log('ℹ️ Android 10 ve altı → "storage" izni kontrol edilecek.', name: tag);
  }

  // 1. Adım: İzin zaten verilmiş mi diye kontrol et.
  if (await permission.isGranted) {
    log('✅ "$permission" izni zaten verilmiş.', name: tag);
    return true;
  }

  // 2. Adım: İzin verilmemişse, kullanıcıdan iste.
  log('⚠️ "$permission" izni isteniyor...', name: tag);
  final status = await permission.request();

  // Sonucu logla ve döndür.
  if (status.isGranted) {
    log('✅ "$permission" izni başarıyla alındı.', name: tag);
  } else {
    log('❌ "$permission" izni reddedildi. Durum: $status', name: tag);
  }

  return status.isGranted;
}
