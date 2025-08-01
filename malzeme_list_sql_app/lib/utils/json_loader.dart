// 📃 <----- json_loader.dart ----->
//
// Verilerin tekrar yüklenmesi, hem konsoldan hem de ekrandaki
// SQLLoadingCard bileşeninden takip ediliyor.
//
//  • Veri tabanı boş ise: cihaza/asset ’e gömülü JSON dosyası okunur,
//    malzemeler tek tek eklenir, ilerleme ve süre kullanıcıya gösterilir.
//  • Veri tabanı dolu ise: yalnızca malzemeler okunup geri döndürülür.
//  • Her adımda onLoadingStatusChange → (loading, progress, word, elapsed)
//    sırasıyla çağrılır.

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../models/malzeme_model.dart';
import '../providers/malzeme_count_provider.dart';

/// 📌 Verileri JSON 'dan yükleyip SQLite veritabanına yazar.
/// Bu işlem sırasında kullanıcıya ilerleme durumu gösterilir.
///
/// [onLoaded] – Tüm veriler yüklendikten sonra listeyi döndürür.
/// [onLoadingStatusChange] – Her adımda kartın görünürlüğünü, ilerleme yüzdesini, güncel kelimeyi ve geçen süreyi bildirir.
Future<void> loadDataFromDatabase({
  required BuildContext context,
  required Function(List<Malzeme>) onLoaded,
  required Function(bool, double, String?, Duration) onLoadingStatusChange,
}) async {
  log("🔄 Veritabanından veri okunuyor...");

  final count = await DbHelper.instance.countWords();
  log("🧮 Veritabanındaki malzeme sayısı: $count");

  /// 🔸 Veritabanı boşsa JSON 'dan yükleme yapılır.
  if (count == 0) {
    log("📭 Veritabanı boş. JSON yedeğinden veri yükleniyor...");

    try {
      // JSON dosyasını cihazdan veya asset ’ten oku
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameJson';
      final file = File(filePath);

      String jsonStr;
      if (await file.exists()) {
        log("📁 Cihazdaki JSON yedeği bulundu: $filePath");
        jsonStr = await file.readAsString();
      } else {
        log("📦 Cihazda JSON bulunamadı, asset ’ten yükleniyor...");
        jsonStr = await rootBundle.loadString('assets/database/$fileNameJson');
      }

      /// JSON verisini çözümlüyoruz → Liste<Malzeme>
      final List<dynamic> jsonList = json.decode(jsonStr);
      final loadedItems = jsonList.map<Malzeme>((e) {
        final map = e as Map<String, dynamic>;
        return Malzeme(malzeme: map['malzeme'], miktar: map['miktar']);
      }).toList();

      /// ⏱ süre ölçmek için kronometre başlat
      final stopwatch = Stopwatch()..start();

      // Kartı göster: başlat
      onLoadingStatusChange(true, 0.0, null, Duration.zero);

      for (int i = 0; i < loadedItems.length; i++) {
        final item = loadedItems[i];
        await DbHelper.instance.insertWord(item);

        // Provider ile sayaç güncelle
        if (context.mounted) {
          Provider.of<MalzemeCountProvider>(
            context,
            listen: false,
          ).setCount(i + 1);
        }

        // Kullanıcıya yükleme ilerlemesi bildir
        final progress = (i + 1) / loadedItems.length;
        onLoadingStatusChange(true, progress, item.malzeme, stopwatch.elapsed);

        log("📥 ${item.malzeme} (${i + 1}/${loadedItems.length})");
        await Future.delayed(const Duration(milliseconds: 30));
      }

      stopwatch.stop();

      // Kartı gizle: bitti
      onLoadingStatusChange(false, 1.0, null, stopwatch.elapsed);

      // Yüklenen son verileri çek
      final finalList = await DbHelper.instance.getWords();
      onLoaded(finalList);

      log(
        "✅ ${loadedItems.length} malzeme yüklendi "
        "(${stopwatch.elapsed.inMilliseconds} ms).",
      );
    } catch (e) {
      log("❌ JSON yükleme hatası: $e");

      // ❗ Hata durumunda kullanıcıya kartı kapatmayı unutma
      onLoadingStatusChange(false, 0.0, null, const Duration());
    }
  } else {
    /// 🔹 Veritabanında veri varsa yükleme yapılmaz, mevcut veriler döndürülür
    log("📦 Veritabanında veri var, JSON 'dan yükleme atlandı.");
    final existingItems = await DbHelper.instance.getWords();
    onLoaded(existingItems);

    if (context.mounted) {
      Provider.of<MalzemeCountProvider>(
        context,
        listen: false,
      ).setCount(existingItems.length);
    }

    // ✅ Kart görünmemişse bile bir dummy animasyonla aç/kapat yap
    onLoadingStatusChange(true, 0.0, null, Duration.zero);
    await Future.delayed(const Duration(milliseconds: 500));
    onLoadingStatusChange(false, 1.0, null, const Duration(milliseconds: 500));
  }
}
