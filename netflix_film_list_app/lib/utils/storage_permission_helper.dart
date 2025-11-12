// 📃 <----- lib/utils/storage_permission_helper.dart ----->
//
// Haricî depolamaya (Downloads vb.) yazabilmek için gerekli izinleri
// tek bir noktada yöneten yardımcı.
//
// 🔹 Android 11+  →  Permission.manageExternalStorage
// 🔹 Android 10-  →  Permission.storage
// 🔹 iOS / Web / Desktop  →  otomatik izinli (true döner)
//
// Kullanım:
//   if (await ensureStoragePermission()) {
//     // ✅ Güvenle dosya yazabilirsiniz
//   } else {
//     // ⚠️ İzin alınamadı — kullanıcıyı bilgilendirin
//   }

import 'dart:developer';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// 📌 Depolama izinlerini kontrol eder veya kullanıcıdan ister.
///
/// Geri dönüş:
/// - `true`  → izin mevcut veya şimdi verildi.
/// - `false` → izin reddedildi veya kalıcı olarak engellendi.
Future<bool> ensureStoragePermission() async {
  const tag = 'storage_permission';

  // ✅ Android dışı platformlarda izin gerekmez
  if (!Platform.isAndroid) {
    log('ℹ️ Android dışı platform — depolama izni gereksiz.', name: tag);
    return true;
  }

  // İzinleri Android sürümüne göre doğru ve tekrar istemeyecek şekilde yönetelim.
  try {
    // Android 10 ve altı, "manageExternalStorage" iznini tanımaz ve
    // "permanentlyDenied" olarak döner. Bu davranışı, versiyon tespiti
    // için kullanabiliriz.
    final manageStatus = await Permission.manageExternalStorage.status;

    // "permanentlyDenied" DEĞİLSE, bu Android 11+ demektir.
    if (!manageStatus.isPermanentlyDenied) {
      // Android 11+ için sadece "manageExternalStorage" iznini yönet.
      if (await Permission.manageExternalStorage.isGranted) {
        log('✔️ MANAGE_EXTERNAL_STORAGE izni zaten var.', name: tag);
        return true;
      }
      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        log('✔️ MANAGE_EXTERNAL_STORAGE izni yeni verildi.', name: tag);
      } else {
        log('❌ MANAGE_EXTERNAL_STORAGE izni reddedildi.', name: tag);
      }
      return status.isGranted; // İzin sonucunu doğrudan döndür.
    } else {
      // "permanentlyDenied" ise, bu Android 10 veya altı demektir.
      // Klasik "storage" iznini kontrol edelim.
      if (await Permission.storage.isGranted) {
        log('✔️ STORAGE izni zaten var (legacy).', name: tag);
        return true;
      }
      final status = await Permission.storage.request();
      if (status.isGranted) {
        log('✔️ STORAGE izni yeni verildi (legacy).', name: tag);
      } else {
        log('❌ STORAGE izni reddedildi (legacy).', name: tag);
      }
      return status.isGranted; // İzin sonucunu doğrudan döndür.
    }
  } catch (e) {
    log('🚨 İzin kontrol hatası: $e', name: tag);
    return false;
  }
}
