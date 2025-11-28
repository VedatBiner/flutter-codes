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
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../providers/item_count_provider.dart';

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
  required Function(List<Word>) onLoaded,
  required Function(bool, double, String?, Duration) onLoadingStatusChange,
}) async {
  const tag = 'json_loader';
  log('🔄 json_loader çalıştı', name: tag);

  log("🔄 Veritabanından veri okunuyor...", name: tag);

  final count = await DbHelper.instance.countRecords();
  log("🧮 Veritabanındaki kelime sayısı: $count", name: tag);

  /// 🔸 Veritabanı boşsa JSON ’dan doldur
  if (count == 0) {
    log(
      "📭 Veritabanı boş. Cihaz/asset JSON yedeğinden veri yükleniyor...",
      name: tag,
    );

    try {
      /// JSON dosyasını bul (önce cihaz, yoksa asset)
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/fileNameJson';
      final file = File(filePath);

      String jsonStr;
      if (await file.exists()) {
        log("📁 Cihazdaki JSON yedeği bulundu: $filePath", name: tag);
        jsonStr = await file.readAsString();
      } else {
        log("📦 Cihazda JSON bulunamadı, asset ’ten yükleniyor...", name: tag);
        jsonStr = await rootBundle.loadString('assets/database/$fileNameJson');
      }

      /// JSON → Liste<Word>
      final List<dynamic> jsonList = json.decode(jsonStr);
      final loadedWords = jsonList.map<Word>((e) {
        final map = e as Map<String, dynamic>;
        return Word(word: map['word'], meaning: map['meaning']);
      }).toList();

      /// ⏱ süre ölçümü için kronometre
      final stopwatch = Stopwatch()..start();

      /// Yükleme başlıyor
      onLoadingStatusChange(true, 0.0, null, Duration.zero);

      for (int i = 0; i < loadedWords.length; i++) {
        final word = loadedWords[i];
        await DbHelper.instance.insertRecord(word);

        /// Provider ile sayaç güncelle
        if (context.mounted) {
          Provider.of<WordCountProvider>(
            context,
            listen: false,
          ).setCount(i + 1);
        }

        /// Kullanıcıya ilerlemeyi bildir
        final progress = (i + 1) / loadedWords.length;
        onLoadingStatusChange(true, progress, word.word, stopwatch.elapsed);

        log("📥 ${word.word} (${i + 1}/${loadedWords.length})", name: 'Kelime');
        await Future.delayed(const Duration(milliseconds: 30));
      }

      stopwatch.stop();

      /// Yükleme bitti, kartı kapat
      onLoadingStatusChange(false, 1.0, null, stopwatch.elapsed);

      // /Son kelime listesi
      final finalWords = await DbHelper.instance.getRecords();
      onLoaded(finalWords);

      log(
        "✅ ${loadedWords.length} kelime yüklendi "
        "(${stopwatch.elapsed.inMilliseconds} ms).",
        name: tag,
      );
    } catch (e) {
      log("❌ JSON yükleme hatası: $e", name: tag);
    }
  } else {
    /// 🔹 Veritabanı dolu ise sadece listeyi döndür
    log("📦 Veritabanında veri var, yükleme yapılmadı.", name: tag);
    final existingWords = await DbHelper.instance.getRecords();
    onLoaded(existingWords);

    if (context.mounted) {
      Provider.of<WordCountProvider>(
        context,
        listen: false,
      ).setCount(existingWords.length);
    }
  }
}
