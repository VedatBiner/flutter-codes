// 📃 <----- json_loader.dart ----->
// Verilerin tekrar yüklenmesi konsolda buradan izleniyor
// Öncelik: cihaz yedeği → yoksa asset içindeki varsayılan JSON'dan yükleme yapılır

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sozluk_ser_tr_sql_app/constants/file_info.dart';

import '../db/db_helper.dart';
import '../models/word_model.dart';
import '../providers/word_count_provider.dart';

Future<void> loadDataFromDatabase({
  required BuildContext context,
  required Function(List<Word>) onLoaded,
  required Function(bool, double, String?) onLoadingStatusChange,
}) async {
  log("🔄 Veritabanından veri okunuyor...");

  final count = await WordDatabase.instance.countWords();
  log("🧮 Veritabanındaki kelime sayısı: $count");

  if (count == 0) {
    log("📭 Veritabanı boş. JSON'dan yükleme başlatılıyor...");

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameJson';
      final file = File(filePath);

      String jsonStr;

      // JSON yedek dosyası cihazda varsa onu oku, yoksa asset'ten oku
      if (await file.exists()) {
        log("📂 Cihazda JSON yedeği bulundu. Yükleniyor...");
        jsonStr = await file.readAsString();
      } else {
        log(
          "📂 Cihazda JSON yedeği bulunamadı. Varsayılan asset dosyasından yükleniyor...",
        );
        jsonStr = await rootBundle.loadString(
          'assets/database/ser_tr_dict.json',
        );
      }

      final List<dynamic> jsonList = json.decode(jsonStr);

      final loadedWords =
          jsonList.map((e) {
            final map = e as Map<String, dynamic>;
            return Word(
              sirpca: map['sirpca'],
              turkce: map['turkce'],
              userEmail: map['userEmail'],
            );
          }).toList();

      onLoadingStatusChange(true, 0.0, null);

      for (int i = 0; i < loadedWords.length; i++) {
        final word = loadedWords[i];
        onLoadingStatusChange(true, (i + 1) / loadedWords.length, word.sirpca);
        log("📥 ${word.sirpca} (${i + 1}/${loadedWords.length})");
        await WordDatabase.instance.insertWord(word);
        await Future.delayed(const Duration(milliseconds: 30));
      }

      onLoadingStatusChange(false, 0.0, null);

      final finalWords = await WordDatabase.instance.getWords();
      onLoaded(finalWords);

      if (context.mounted) {
        Provider.of<WordCountProvider>(
          context,
          listen: false,
        ).setCount(finalWords.length);
      }

      log("✅ ${loadedWords.length} kelime başarıyla yüklendi.");
    } catch (e) {
      log("❌ JSON dosyasından veri yüklenirken hata oluştu: $e");
    }
  } else {
    log("📦 Veritabanında zaten veri var. JSON yüklemesi yapılmadı.");

    final finalWords = await WordDatabase.instance.getWords();
    onLoaded(finalWords);

    if (context.mounted) {
      Provider.of<WordCountProvider>(
        context,
        listen: false,
      ).setCount(finalWords.length);
    }
  }
}
