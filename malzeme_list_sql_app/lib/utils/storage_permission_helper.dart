// 📃 lib/utils/storage_permission_helper.dart
//
// Haricî depolamaya (Downloads vb.) yazabilmek için gerekli izinleri
// tek bir noktada yöneten yardımcı.
//
//  • Android 11+  →  Permission.manageExternalStorage
//  • Android 10-  →  Permission.storage
//  • Diğer platformlarda true döner.
//
// Kullanım:
//   if (await ensureStoragePermission()) {
//     // güvenle dosya yazabilirsiniz
//   } else {
//     // izin alınamadı — kullanıcıyı bilgilendirin
//   }

import 'dart:developer';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// 📌 Depolama izinlerini kontrol eder / ister.
///   • `true`  → izin zaten var -ya da- kullanıcı şimdi verdi
///   • `false` → reddedildi / kalıcı olarak engellendi
Future<bool> ensureStoragePermission() async {
  // Android dışı platformlarda izin gerekmez
  if (!Platform.isAndroid) return true;

  // Android 11 (API 30) ve sonrası — geniş izin
  if (await Permission.manageExternalStorage.isGranted) return true;

  final status = await Permission.manageExternalStorage.request();
  if (status.isGranted) {
    log('✔️  manageExternalStorage izni verildi');
    return true;
  }

  // Android 10 ve öncesi — klasik STORAGE izni
  if (await Permission.storage.isGranted) return true;

  final legacyStatus = await Permission.storage.request();
  if (legacyStatus.isGranted) {
    log('✔️  storage izni verildi (legacy)');
    return true;
  }

  log('❌  Depolama izni reddedildi');
  return false;
}
