// 📃 utils/json_loader.dart
//
// İlk kurulumda/veritabanı boşsa JSON'dan veriyi yükler.
// JSON parse işlemi izoleye taşınmıştır (CPU-yoğun işlem).
// Veritabanı yazma (sqflite) ana izolede yapılır.
// Yükleme sürecinde progress, geçen süre ve (varsa) anlık kelime bilgisi UI'ya iletilir.
//
// Notlar:
// - Asset JSON yolu: assets/data/words.json  (kendi yolunla değiştir)
// - Word.fromMap(...) / Word.toMap() projendeki modele uymalı
// - DB tablo adı: 'words' (projende farklıysa değiştir)

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

import '../db/db_helper.dart';
import '../models/word_model.dart';
import 'isolate_runner.dart';
import 'json_parse_isolate.dart';

/// Dışarıya açık yükleyici:
/// - DB'de kayıt varsa onları okur ve döner
/// - DB boşsa: JSON'u asset'ten okur, İZOLEDE parse eder, sonra batch insert
/// - Her durumda sonunda onLoaded ile words listesi döner, provider sayacı güncellenebilir
Future<void> loadDataFromDatabase({
  required BuildContext context,
  required void Function(List<Word>) onLoaded,
  required void Function(
    bool loading,
    double progress,
    String? currentWord,
    Duration elapsedTime,
  )
  onLoadingStatusChange,
}) async {
  final sw = Stopwatch()..start();

  // 1) DB’de var mı?
  final db = await DbHelper.instance.database;
  final count = await _countRecords(db);
  if (count > 0) {
    final existing = await DbHelper.instance.getRecords();
    onLoaded(existing);
    onLoadingStatusChange(false, 1.0, null, sw.elapsed);
    return;
  }

  // 2) Asset JSON'u oku (kendi yolun neyse onu kullan):
  onLoadingStatusChange(true, 0.01, 'JSON okunuyor...', sw.elapsed);
  final jsonString = await rootBundle.loadString('assets/data/words.json');

  // 3) JSON parse'ı izolede yap
  onLoadingStatusChange(true, 0.02, 'JSON parse başlatılıyor...', sw.elapsed);
  final runner = await runWithProgress<List<Map<String, dynamic>>>(
    entryPoint: jsonParseEntryPoint,
    initialMessage: {'jsonString': jsonString},
  );

  final sub = runner.progress.listen((p) {
    onLoadingStatusChange(true, p * 0.80 + 0.05, null, sw.elapsed);
    // parse %0-80 → toplam barın %5-85 aralığına yay
  });

  late final List<Map<String, dynamic>> maps;
  try {
    maps = await runner.result;
  } catch (e) {
    await sub.cancel();
    onLoadingStatusChange(false, 0.0, null, sw.elapsed);
    rethrow;
  }

  await sub.cancel();

  // 4) Ana izolede DB'ye batch insert
  onLoadingStatusChange(true, 0.88, 'Veritabanına yazılıyor...', sw.elapsed);
  await db.transaction((txn) async {
    final batch = txn.batch();
    for (final m in maps) {
      final w = Word.fromMap(m); // Projendeki fromMap'le eşleşmeli
      batch.insert(
        'words',
        w.toMap(), // Projendeki toMap'le eşleşmeli
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  });

  // 5) DB’den tekrar oku ve bildir
  onLoadingStatusChange(true, 0.98, 'Son kontroller...', sw.elapsed);
  final loaded = await DbHelper.instance.getRecords();

  onLoaded(loaded);
  onLoadingStatusChange(false, 1.0, null, sw.elapsed);
}

Future<int> _countRecords(Database db) async {
  final res = await db.rawQuery('SELECT COUNT(*) as c FROM words');
  final c = Sqflite.firstIntValue(res) ?? 0;
  return c;
}
