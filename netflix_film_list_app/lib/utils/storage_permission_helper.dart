// 📃 lib/utils/storage_permission_helper.dart
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

  // ✅ Android dışı platformlarda izin gerekmez (örn. iOS, macOS, Web, Windows)
  if (!Platform.isAndroid) {
    log('ℹ️  Android dışı platform — depolama izni gereksiz.', name: tag);
    return true;
  }

  try {
    // 📱 Android 11 (API 30) ve sonrası → manageExternalStorage
    if (await Permission.manageExternalStorage.isGranted) {
      log('✔️  MANAGE_EXTERNAL_STORAGE izni zaten var.', name: tag);
      return true;
    }

    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      log('✔️  MANAGE_EXTERNAL_STORAGE izni yeni verildi.', name: tag);
      return true;
    }

    // 📦 Android 10 ve öncesi → klasik storage izni
    if (await Permission.storage.isGranted) {
      log('✔️  STORAGE izni zaten var (legacy).', name: tag);
      return true;
    }

    final legacyStatus = await Permission.storage.request();
    if (legacyStatus.isGranted) {
      log('✔️  STORAGE izni yeni verildi (legacy).', name: tag);
      return true;
    }

    // ❌ Hiçbir izin alınamadı
    log(
      '❌  Depolama izni reddedildi veya kalıcı olarak engellendi.',
      name: tag,
    );
    return false;
  } catch (e) {
    log('🚨 İzin kontrol hatası: $e', name: tag);
    return false;
  }
}
