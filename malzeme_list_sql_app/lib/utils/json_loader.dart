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

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

/// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
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
  log('🔄 json_loader çalıştı', name: 'JSON Loader');
  log("🔄 Veritabanından veri okunuyor...", name: 'JSON Loader');

  final count = await DbHelper.instance.countRecords();
  log("🧮 Veritabanındaki malzeme sayısı: $count", name: 'JSON Loader');

  /// 🔸 Veritabanı boşsa JSON ’dan doldur
  if (count == 0) {
    log(
      "📭 Veritabanı boş. JSON yedeğinden veri yükleniyor...",
      name: 'JSON Loader',
    );

    try {
      /// JSON dosyasını bul (önce cihaz, yoksa asset)
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameJson';
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

      /// JSON → Liste<Malzeme>
      final List<dynamic> jsonList = json.decode(jsonStr);
      final loadedItems = jsonList.map<Malzeme>((e) {
        final map = e as Map<String, dynamic>;
        return Malzeme(malzeme: map['malzeme'], miktar: map['miktar']);
      }).toList();

      /// ⏱ süre ölçümü için kronometre
      final stopwatch = Stopwatch()..start();

      /// Yükleme başlıyor
      onLoadingStatusChange(true, 0.0, null, Duration.zero);

      for (int i = 0; i < loadedItems.length; i++) {
        final item = loadedItems[i];
        await DbHelper.instance.insertRecord(item);

        /// Provider ile sayaç güncelle
        if (context.mounted) {
          Provider.of<MalzemeCountProvider>(
            context,
            listen: false,
          ).setCount(i + 1);
        }

        /// Kullanıcıya ilerlemeyi bildir
        final progress = (i + 1) / loadedItems.length;
        onLoadingStatusChange(true, progress, item.malzeme, stopwatch.elapsed);

        log(
          "📥 ${item.malzeme} (${i + 1}/${loadedItems.length})",
          name: 'Malzeme',
        );
        await Future.delayed(const Duration(milliseconds: 30));
      }

      stopwatch.stop();

      /// Yükleme bitti, kartı kapat
      onLoadingStatusChange(false, 1.0, null, stopwatch.elapsed);

      /// Son malzeme listesi
      final finalList = await DbHelper.instance.getRecords();
      onLoaded(finalList);

      log(
        "✅ ${loadedItems.length} malzeme yüklendi "
        "(${stopwatch.elapsed.inMilliseconds} ms).",
        name: 'JSON Loader',
      );
    } catch (e) {
      log("❌ JSON yükleme hatası: $e", name: 'JSON Loader');

      /// ❗ Hata durumunda kullanıcıya kartı kapatmayı unutma
      onLoadingStatusChange(false, 0.0, null, const Duration());
    }
  } else {
    /// 🔹 Veritabanında veri varsa yükleme yapılmaz, mevcut veriler döndürülür
    log(
      "📦 Veritabanında veri var, JSON 'dan yükleme atlandı.",
      name: 'JSON Loader',
    );
    final existingItems = await DbHelper.instance.getRecords();
    onLoaded(existingItems);

    if (context.mounted) {
      Provider.of<MalzemeCountProvider>(
        context,
        listen: false,
      ).setCount(existingItems.length);
    }

    /// ✅ Kart görünmemişse bile bir dummy animasyonla aç/kapat yap
    onLoadingStatusChange(true, 0.0, null, Duration.zero);
    await Future.delayed(const Duration(milliseconds: 500));
    onLoadingStatusChange(false, 1.0, null, const Duration(milliseconds: 500));
  }
}
