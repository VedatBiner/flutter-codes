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

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../db/word_database.dart';
import '../models/word_model.dart';
import '../providers/word_count_provider.dart';

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
  log("🔄 Veritabanından veri okunuyor...");

  final count = await WordDatabase.instance.countWords();
  log("🧮 Veritabanındaki kelime sayısı: $count");

  /// 🔸 Veritabanı boşsa JSON ’dan doldur
  if (count == 0) {
    log("📭 Veritabanı boş. Cihaz/asset JSON yedeğinden veri yükleniyor...");

    try {
      /// JSON dosyasını bul (önce cihaz, yoksa asset)
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/kelimelik_backup.json';
      final file = File(filePath);

      String jsonStr;
      if (await file.exists()) {
        log("📁 Cihazdaki JSON yedeği bulundu: $filePath");
        jsonStr = await file.readAsString();
      } else {
        log("📦 Cihazda JSON bulunamadı, asset ’ten yükleniyor...");
        jsonStr = await rootBundle.loadString(
          'assets/database/kelimelik_backup.json',
        );
      }

      /// JSON → Liste<Word>
      final List<dynamic> jsonList = json.decode(jsonStr);
      final loadedWords =
          jsonList.map<Word>((e) {
            final map = e as Map<String, dynamic>;
            return Word(word: map['word'], meaning: map['meaning']);
          }).toList();

      /// ⏱ süre ölçümü için kronometre
      final stopwatch = Stopwatch()..start();

      /// Yükleme başlıyor
      onLoadingStatusChange(true, 0.0, null, Duration.zero);

      for (int i = 0; i < loadedWords.length; i++) {
        final word = loadedWords[i];
        await WordDatabase.instance.insertWord(word);

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

        log("📥 ${word.word} (${i + 1}/${loadedWords.length})");
        await Future.delayed(const Duration(milliseconds: 30));
      }

      stopwatch.stop();

      /// Yükleme bitti, kartı kapat
      onLoadingStatusChange(false, 1.0, null, stopwatch.elapsed);

      // /Son kelime listesi
      final finalWords = await WordDatabase.instance.getWords();
      onLoaded(finalWords);

      log(
        "✅ ${loadedWords.length} kelime yüklendi "
        "(${stopwatch.elapsed.inMilliseconds} ms).",
      );
    } catch (e) {
      log("❌ JSON yükleme hatası: $e");
    }
  } else {
    /// 🔹 Veritabanı dolu ise sadece listeyi döndür
    log("📦 Veritabanında veri var, yükleme yapılmadı.");
    final existingWords = await WordDatabase.instance.getWords();
    onLoaded(existingWords);

    if (context.mounted) {
      Provider.of<WordCountProvider>(
        context,
        listen: false,
      ).setCount(existingWords.length);
    }
  }
}
