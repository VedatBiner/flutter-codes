// 📃 <----- json_loader.dart ----->
// Verilerin tekrar yuklenmesi konsolda ve AppBar'da buradan izleniyor

// 📌 Dart paketleri
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

/// 📌 Flutter paketleri
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../models/word_model.dart';
import '../providers/word_count_provider.dart';

Future<void> loadDataFromDatabase({
  required BuildContext context,
  required Function(List<Word>) onLoaded,
  required Function(bool, double, String?, Duration) onLoadingStatusChange,
}) async {
  /// 🔍 Ön kontrol: Firestore, JSON ve SQLite karşılaştırması
  final firestoreCount = await getFirestoreWordCount();
  final assetCount = await getWordCountFromAssetJson();
  final dbCount = await WordDatabase.instance.countWords();

  log("📦 Firestore 'daki kayıt sayısı: $firestoreCount");
  log("📁 Asset JSON 'daki kayıt sayısı: $assetCount");
  log("🧮 SQLite veritabanındaki kayıt sayısı: $dbCount");

  if (assetCount > dbCount) {
    log(
      "📢 Asset verisi daha güncel. Veritabanı sıfırlanacak ve tekrar yüklenecek.",
    );
    final db = await WordDatabase.instance.database;
    await db.delete('words');
  }

  log("🔄 Veritabanından veri okunuyor...");
  final count = await WordDatabase.instance.countWords();
  log("🧮 Veritabanındaki kelime sayısı: $count");

  /// 🔸 Veritabanı boşsa Firestore 'dan doldur
  if (count == 0) {
    await importFromFirestoreToSqlite(context, onLoadingStatusChange);

    final newCount = await WordDatabase.instance.countWords();
    if (newCount > 0) {
      log("✅ Firestore 'dan veriler yüklendi. JSON' dan yükleme atlandı.");

      final finalWords = await WordDatabase.instance.getWords();
      onLoaded(finalWords);

      if (context.mounted) {
        Provider.of<WordCountProvider>(
          context,
          listen: false,
        ).setCount(finalWords.length);
      }
      return;
    }
    log("📭 Firestore boş. JSON 'dan veri yükleniyor...");
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
    return;
  }

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
      jsonStr = await rootBundle.loadString('assets/database/$fileNameJson');
    }

    final List<dynamic> jsonList = json.decode(jsonStr);
    final loadedWords =
        jsonList.map((e) {
          final map = e as Map<String, dynamic>;
          return Word(
            sirpca: map['sirpca'] ?? '',
            turkce: map['turkce'] ?? '',
            userEmail: map['userEmail'] ?? '',
          );
        }).toList();

    final stopwatch = Stopwatch()..start();
    onLoadingStatusChange(true, 0.0, null, Duration.zero);

    for (int i = 0; i < loadedWords.length; i++) {
      final word = loadedWords[i];
      await WordDatabase.instance.insertWord(word);

      if (context.mounted) {
        Provider.of<WordCountProvider>(context, listen: false).setCount(i + 1);
      }

      onLoadingStatusChange(
        true,
        (i + 1) / loadedWords.length,
        word.sirpca,
        stopwatch.elapsed,
      );
      log("📥 ${word.sirpca} (${i + 1}/${loadedWords.length})");
      await Future.delayed(const Duration(milliseconds: 30));
    }

    stopwatch.stop();
    onLoadingStatusChange(false, 0.0, null, stopwatch.elapsed);

    final finalWords = await WordDatabase.instance.getWords();
    onLoaded(finalWords);
    log(
      "✅ ${loadedWords.length} kelime yüklendi (${stopwatch.elapsed.inMilliseconds} ms).",
    );
  } catch (e) {
    log("❌ JSON yükleme hatası: $e");
  }
}

/// 📌 Asset JSON içindeki kelime sayısını hesapla
Future<int> getWordCountFromAssetJson() async {
  try {
    final jsonStr = await rootBundle.loadString(
      'assets/database/$fileNameJson',
    );
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    log("📌 Asset içindeki kelime sayısı : ${jsonList.length}");
    return jsonList.length;
  } catch (e) {
    log("❌ Asset JSON okunamadı: $e");
    return 0;
  }
}

/// 📌 Firestore 'dan verileri SQLite 'a yaz
Future<void> importFromFirestoreToSqlite(
  BuildContext context,
  Function(bool, double, String?, Duration) onLoadingStatusChange,
) async {
  log("📭 Veritabanı boş. Firestore 'dan veriler çekilecek...");

  try {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('kelimeler').get();
    final documents = querySnapshot.docs;
    log("📥 Firestore 'dan çekilen toplam kayıt: ${documents.length}");

    final stopwatch = Stopwatch()..start();

    onLoadingStatusChange(true, 0.0, null, Duration.zero);

    for (int i = 0; i < documents.length; i++) {
      final data = documents[i].data();
      final word = Word(
        sirpca: data['sirpca'] ?? '',
        turkce: data['turkce'] ?? '',
        userEmail: data['userEmail'] ?? '',
      );

      await WordDatabase.instance.insertWord(word);

      if (context.mounted) {
        Provider.of<WordCountProvider>(context, listen: false).setCount(i + 1);
      }

      onLoadingStatusChange(
        true,
        (i + 1) / documents.length,
        word.sirpca,
        stopwatch.elapsed,
      );
      log("✅ [${i + 1}/${documents.length}] ${word.sirpca} eklendi.");
      await Future.delayed(const Duration(milliseconds: 25));
    }

    stopwatch.stop();
    onLoadingStatusChange(false, 0.0, null, stopwatch.elapsed);

    log("🎉 Firestore 'dan alınan tüm veriler SQLite 'a yazıldı.");
  } catch (e) {
    log("❌ Firestore 'dan veri çekerken hata oluştu: $e");
  }
}

/// 📌 Firestore 'daki kelime sayısını hesapla
Future<int> getFirestoreWordCount() async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('kelimeler').get();
    return snapshot.docs.length;
  } catch (e) {
    log("❌ Firestore sayımı başarısız: $e");
    return 0;
  }
}
