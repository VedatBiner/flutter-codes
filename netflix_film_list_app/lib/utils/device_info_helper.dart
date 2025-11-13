// 📃 <----- lib/utils/device_info_helper.dart ----->
//
// 🎯 Amaç:
//    Cihazın marka, model, işletim sistemi sürümü gibi bilgilerini
//    tespit ederek log'a yazmak veya ileride raporlamak.
//
// 🧠 Kullanım:
//    import '../utils/device_info_helper.dart';
//    await logDeviceInfo();   // uygulama açılışında bir kez çağır
//
// 📦 Kütüphaneler:
//    - device_info_plus: cihaz detaylarını okumak için
//    - dart:developer: log() ile konsol çıktısı almak için
//    - dart:io: platform tespiti (Android, iOS, Windows, vs.)
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';

/// 🧠 Cihaz bilgilerini log olarak yazar.
/// Platform otomatik algılanır (Android, iOS, Windows, macOS, Linux, Web).
Future<void> logDeviceInfo() async {
  const tag = 'device_info_helper';
  final plugin = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      final info = await plugin.androidInfo;
      log('📱 Android Cihaz Bilgileri:', name: tag);
      log('• Model: ${info.model}', name: tag);
      log('• Üretici: ${info.manufacturer}', name: tag);
      log('• Android sürümü: ${info.version.release}', name: tag);
      log('• SDK: ${info.version.sdkInt}', name: tag);
      log('• Brand: ${info.brand}', name: tag);
      log('• ID: ${info.id}', name: tag);
    } else if (Platform.isIOS) {
      final info = await plugin.iosInfo;
      log('🍏 iOS Cihaz Bilgileri:', name: tag);
      log('• Model: ${info.utsname.machine}', name: tag);
      log('• Sistem: ${info.systemName} ${info.systemVersion}', name: tag);
      log('• Cihaz Adı: ${info.name}', name: tag);
      log('• UUID: ${info.identifierForVendor}', name: tag);
    } else if (Platform.isWindows) {
      final info = await plugin.windowsInfo;
      log('💻 Windows Cihaz Bilgileri:', name: tag);
      log('• Bilgisayar Adı: ${info.computerName}', name: tag);
      log('• İşlemci: ${info.numberOfCores} çekirdek', name: tag);
      log('• RAM: ${info.systemMemoryInMegabytes} MB', name: tag);
    } else if (Platform.isMacOS) {
      final info = await plugin.macOsInfo;
      log('🍎 macOS Cihaz Bilgileri:', name: tag);
      log('• Model: ${info.model}', name: tag);
      log('• Sürüm: ${info.osRelease}', name: tag);
    } else if (Platform.isLinux) {
      final info = await plugin.linuxInfo;
      log('🐧 Linux Cihaz Bilgileri:', name: tag);
      log('• Dağıtım: ${info.name}', name: tag);
      log('• Versiyon: ${info.version}', name: tag);
    } else {
      log('🌐 Web veya Bilinmeyen Platform', name: tag);
    }
  } catch (e, st) {
    log('🚨 Cihaz bilgisi alınamadı: $e', name: tag, error: e, stackTrace: st);
  }
}
