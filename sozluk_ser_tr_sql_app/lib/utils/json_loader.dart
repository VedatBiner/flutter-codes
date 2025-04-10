// 📃 <----- json_loader.dart ----->
// Verilerin tekrar yüklenmesi konsolda buradan izleniyor

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../db/db_helper.dart';
import '../models/word_model.dart';

Future<void> loadDataFromDatabase({
  required BuildContext context,
  required Function(List<Word>) onLoaded,
  required Function(bool, double, String?) onLoadingStatusChange,
}) async {
  log("🔄 Veritabanından veri okunuyor...");

  final count = await WordDatabase.instance.countWords();
  log("🧮 Veritabanındaki kelime sayısı: $count");

  if (count == 0) {
    log("📭 Veritabanı boş. Cihazdaki JSON yedeğinden veri yükleniyor...");

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/ser_tr_dict.json';
      final file = File(filePath);

      if (await file.exists()) {
        final jsonStr = await file.readAsString();
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
          onLoadingStatusChange(
            true,
            (i + 1) / loadedWords.length,
            word.sirpca,
          );
          log("📥 ${word.sirpca} (${i + 1}/${loadedWords.length})");
          await WordDatabase.instance.insertWord(word);
          await Future.delayed(const Duration(milliseconds: 30));
        }

        onLoadingStatusChange(false, 0.0, null);
        onLoaded(await WordDatabase.instance.getWords());

        log("✅ ${loadedWords.length} kelime JSON dosyasından yüklendi.");
      } else {
        log("⚠️ kelimelik_backup.json dosyası bulunamadı: $filePath");
      }
    } catch (e) {
      log("❌ JSON dosyasından veri yüklenirken hata oluştu: $e");
    }
  } else {
    log("📦 Veritabanında zaten veri var. JSON yüklemesi yapılmadı.");
    onLoaded(await WordDatabase.instance.getWords());
  }
}
