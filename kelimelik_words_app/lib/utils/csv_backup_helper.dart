// 📃 <----- csv_backup.dart ----->
// custom_drawer.dart içinden çağırılıyor.
// CSV formatında yedek alıyor.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/db/word_database.dart';

Future<String> createCsvBackup(BuildContext context) async {
  final path = await WordDatabase.instance.exportWordsToCsv();
  log('📁 CSV dosya konumu: $path', name: 'CSV');

  return path;
}
