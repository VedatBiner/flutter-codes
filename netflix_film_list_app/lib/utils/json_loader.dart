// 📃 <----- json_loader.dart ----->
//
// Verilerin tekrar yüklenmesi, hem konsoldan hem de ekrandaki
// SQLLoadingCard bileşeninden takip ediliyor.
//
//  • Veri tabanı boş ise: cihaza/asset ’e gömülü JSON dosyası okunur,
//    kelimeler tek tek eklenir, ilerleme ve süre kullanıcıya gösterilir.
//  • Veri tabanı dolu ise: yalnızca kelimeler okunup geri-döndürülür.
//  • Her adımda onLoadingStatusChange → (loading, progress, word, elapsed)
//    sırasıyla çağrılır.

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

/// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../models/item_model.dart';
// import '../providers/item_count_provider.dart';

/// 📌 Verileri (gerekirse) JSON ’dan okuyup veritabanına yazar.
/// [onLoaded]     – Yükleme bittikten sonra tüm kelimeleri döner.
/// [onLoadingStatusChange]
///   loading      – Kart görünür/gizlenir (true/false)
///   progress     – 0‒1 arası yüzde
///   currentWord  – O an eklenen kelime (null → gösterme)
///   elapsed      – İşlem süresi
///
Future<void> loadDataFromDatabase({
  required BuildContext context,
  required Function(List<NetflixItem>) onLoaded,
  required Function(bool, double, String?, Duration) onLoadingStatusChange,
}) async {
  log('🔄 json_loader çalıştı', name: 'JSON Loader');

  log("🔄 Veritabanından veri okunuyor...", name: 'JSON Loader');

  final count = await DbHelper.instance.countRecords();
  log("🧮 Veritabanındaki kelime sayısı: $count", name: 'JSON Loader');

  /// 🔸 Veritabanı boşsa JSON ’dan doldur
  if (count == 0) {
    log(
      "📭 Veritabanı boş. Cihaz/asset JSON yedeğinden veri yükleniyor...",
      name: 'JSON Loader',
    );

    try {
      /// JSON dosyasını bul (önce cihaz, yoksa asset)
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/fileNameJson';
      final file = File(filePath);

      String jsonStr;
      if (await file.exists()) {
        log("📁 Cihazdaki JSON yedeği bulundu: $filePath", name: 'JSON Loader');
        jsonStr = await file.readAsString();
      } else {
        log(
          "📦 Cihazda JSON bulunamadı, asset ’ten yükleniyor...",
          name: 'JSON Loader',
        );
        jsonStr = await rootBundle.loadString('assets/database/$fileNameJson');
      }

      /// JSON → Liste<NetflixItem>
      final List<dynamic> jsonList = json.decode(jsonStr);
      final loadedItems = jsonList.map<NetflixItem>((e) {
        final map = e as Map<String, dynamic>;
        return NetflixItem(
          netflixItemName: map['netflixItemName'],
          watchDate: map['watchDate'],
        );
      }).toList();

      /// ⏱ süre ölçümü için kronometre
      final stopwatch = Stopwatch()..start();

      /// Yükleme başlıyor
      onLoadingStatusChange(true, 0.0, null, Duration.zero);

      for (int i = 0; i < loadedItems.length; i++) {
        final item = loadedItems[i];
        await DbHelper.instance.insertRecord(item);

        /// Provider ile sayaç güncelle
        // if (context.mounted) {
        //   Provider.of<WordCountProvider>(
        //     context,
        //     listen: false,
        //   ).setCount(i + 1);
        // }

        /// Kullanıcıya ilerlemeyi bildir
        final progress = (i + 1) / loadedItems.length;
        onLoadingStatusChange(
          true,
          progress,
          item.netflixItemName,
          stopwatch.elapsed,
        );

        log(
          "📥 ${item.netflixItemName} (${i + 1}/${loadedItems.length})",
          name: 'Kelime',
        );
        await Future.delayed(const Duration(milliseconds: 30));
      }

      stopwatch.stop();

      /// Yükleme bitti, kartı kapat
      onLoadingStatusChange(false, 1.0, null, stopwatch.elapsed);

      // /Son kelime listesi
      final finalWords = await DbHelper.instance.getRecords();
      onLoaded(finalWords);

      log(
        "✅ ${loadedItems.length} kelime yüklendi "
        "(${stopwatch.elapsed.inMilliseconds} ms).",
        name: 'JSON Loader',
      );
    } catch (e) {
      log("❌ JSON yükleme hatası: $e", name: 'JSON Loader');
    }
  } else {
    /// 🔹 Veritabanı dolu ise sadece listeyi döndür
    log("📦 Veritabanında veri var, yükleme yapılmadı.", name: 'JSON Loader');
    final existingItems = await DbHelper.instance.getRecords();
    onLoaded(existingItems);

    // if (context.mounted) {
    //   Provider.of<WordCountProvider>(
    //     context,
    //     listen: false,
    //   ).setCount(existingWords.length);
    // }
  }
}
