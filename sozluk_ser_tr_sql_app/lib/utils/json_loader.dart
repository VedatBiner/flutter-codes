// 📃 <----- json_loader.dart ----->
// Verilerin tekrar yüklenmesi konsolda ve AppBar'da buradan izleniyor

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../constants/file_info.dart';
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
    log("📭 Veritabanı boş. JSON 'dan veri yükleniyor...");

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameJson';
      final file = File(filePath);

      String jsonStr;

      if (await file.exists()) {
        log("📁 Cihazdaki JSON yedeği bulundu: $filePath");
        jsonStr = await file.readAsString();
      } else {
        log("📦 Cihazda JSON yedeği bulunamadı. Asset içinden yükleniyor...");
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
        await WordDatabase.instance.insertWord(word);

        if (context.mounted) {
          Provider.of<WordCountProvider>(
            context,
            listen: false,
          ).setCount(i + 1);
        }

        onLoadingStatusChange(true, (i + 1) / loadedWords.length, word.sirpca);
        log("📥 ${word.sirpca} (${i + 1}/${loadedWords.length})");
        await Future.delayed(const Duration(milliseconds: 30));
      }

      onLoadingStatusChange(false, 0.0, null);
      final finalWords = await WordDatabase.instance.getWords();
      onLoaded(finalWords);
      log("✅ ${loadedWords.length} kelime başarıyla yüklendi.");
    } catch (e) {
      log("❌ JSON yükleme hatası: $e");
    }
  } else {
    log("📦 Veritabanında veri var, yükleme yapılmadı.");
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
