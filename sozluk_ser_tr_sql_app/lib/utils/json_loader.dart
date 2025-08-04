// 📃 <----- json_loader.dart ----->
// Verilerin tekrar yuklenmesi konsolda ve AppBar'da buradan izleniyor

// 📌 Dart paketleri
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// 📌 Flutter paketleri
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../constants/serbian_alphabet.dart';
import '../db/db_helper.dart';
import '../models/word_model.dart';
import '../providers/word_count_provider.dart';

Future<void> loadDataFromDatabase({
  required BuildContext context,
  required Function(List<Word>) onLoaded,
  required Function(bool, double, String?, Duration) onLoadingStatusChange,
}) async {
  // 🔍 Ön kontrol: Firestore, JSON ve SQLite karşılaştırması
  final firestoreCount = await getFirestoreWordCount();
  final assetJsonCount = await getWordCountFromAssetJson();
  final dbCount = await DbHelper.instance.countRecords();
  final assetSqlCount = await DbHelper.instance.countWordsAssetSql();

  log('🔄 json_loader çalıştı', name: 'JSON Loader');
  log("📦 Firestore 'daki kayıt sayısı: $firestoreCount", name: 'JSON Loader');
  log("📁 Asset JSON 'daki kayıt sayısı: $assetJsonCount", name: 'JSON Loader');
  log("🧮 SQLite veritabanındaki kayıt sayısı: $dbCount", name: 'JSON Loader');
  log(
    '🧮 Asset SQL veritabanındaki kayıt sayısı: $assetSqlCount',
    name: 'JSON Loader',
  );

  if (assetJsonCount > dbCount) {
    log(
      "📢 Asset verisi daha güncel. Veritabanı sıfırlanacak ve tekrar yüklenecek.",
      name: 'JSON Loader',
    );
    final db = await DbHelper.instance.database;
    await db.delete('words');
  }

  log("🔄 Veritabanından veri okunuyor...", name: 'JSON Loader');
  final count = await DbHelper.instance.countRecords();
  log("🧮 Veritabanındaki kelime sayısı: $count", name: 'JSON Loader');

  // 🔸 Veritabanı boşsa Firestore 'dan doldur
  if (count == 0) {
    await importFromFirestoreToSqlite(context, onLoadingStatusChange);

    final newCount = await DbHelper.instance.countRecords();
    if (newCount > 0) {
      log(
        "✅ Firestore 'dan veriler yüklendi. JSON 'dan yükleme atlandı.",
        name: 'JSON Loader',
      );

      final finalWords = await DbHelper.instance.getRecords();
      onLoaded(finalWords);

      if (context.mounted) {
        Provider.of<WordCountProvider>(
          context,
          listen: false,
        ).setCount(finalWords.length);
      }
      return;
    }
    log("📭 Firestore boş. JSON 'dan veri yükleniyor...", name: 'JSON Loader');
  } else {
    log("📦 Veritabanında veri var, yükleme yapılmadı.", name: 'JSON Loader');

    final finalWords = await DbHelper.instance.getRecords();
    onLoaded(finalWords);

    if (context.mounted) {
      Provider.of<WordCountProvider>(
        context,
        listen: false,
      ).setCount(finalWords.length);
    }
    return;
  }

  // 🔁 JSON dan yükleme (Fallback)
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameJson';
    final file = File(filePath);

    String jsonStr;
    if (await file.exists()) {
      log("📁 Cihazdaki JSON yedeği bulundu: $filePath", name: 'JSON Loader');
      jsonStr = await file.readAsString();
    } else {
      log(
        "📦 Cihazda JSON yedeği bulunamadı. Asset içinden yükleniyor...",
        name: 'JSON Loader',
      );
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

    /// 🆕 alfabetik sırala
    loadedWords.sort((a, b) => _compareSerbian(a.sirpca, b.sirpca));

    final stopwatch = Stopwatch()..start();
    onLoadingStatusChange(true, 0.0, null, Duration.zero);

    for (int i = 0; i < loadedWords.length; i++) {
      final word = loadedWords[i];
      await DbHelper.instance.insertRecord(word);

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

    final finalWords = await DbHelper.instance.getRecords();
    onLoaded(finalWords);
    log(
      "✅ ${loadedWords.length} kelime yüklendi (${stopwatch.elapsed.inMilliseconds} ms).",
      name: 'JSON Loader',
    );
  } catch (e) {
    log("❌ JSON yükleme hatası: $e", name: 'JSON Loader');
  }
}

/// 📌 Sırpça harf sıralaması (serbian_alphabet.dart listesini kullanır)
int _compareSerbian(String a, String b) {
  int i = 0;
  while (i < a.length && i < b.length) {
    final ai = serbianAlphabet.indexOf(a[i].toUpperCase());
    final bi = serbianAlphabet.indexOf(b[i].toUpperCase());
    if (ai != bi) return ai.compareTo(bi);
    i++;
  }
  return a.length.compareTo(b.length);
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

    /// 🆕 sirpca alanına göre sırala */
    documents.sort(
      (a, b) => _compareSerbian(
        (a.data()['sirpca'] ?? '') as String,
        (b.data()['sirpca'] ?? '') as String,
      ),
    );

    log(
      "📥 Firestore 'dan çekilen toplam kayıt: ${documents.length}",
      name: 'JSON Loader',
    );

    final stopwatch = Stopwatch()..start();
    onLoadingStatusChange(true, 0.0, null, Duration.zero);

    for (int i = 0; i < documents.length; i++) {
      final data = documents[i].data();
      final word = Word(
        sirpca: data['sirpca'] ?? '',
        turkce: data['turkce'] ?? '',
        userEmail: data['userEmail'] ?? '',
      );

      await DbHelper.instance.insertRecord(word);

      if (context.mounted) {
        Provider.of<WordCountProvider>(context, listen: false).setCount(i + 1);
      }

      onLoadingStatusChange(
        true,
        (i + 1) / documents.length,
        word.sirpca,
        stopwatch.elapsed,
      );

      log(
        "📥 (${i + 1}/${documents.length}) ${word.sirpca} --->>> eklendi.",
        name: 'Sırpça kelime : ',
      );
      await Future.delayed(const Duration(milliseconds: 25));
    }

    stopwatch.stop();
    onLoadingStatusChange(false, 0.0, null, stopwatch.elapsed);

    log(
      "🎉 Firestore 'dan alınan tüm veriler SQLite 'a yazıldı.",
      name: 'JSON Loader',
    );
  } catch (e) {
    log("❌ Firestore 'dan veri çekerken hata oluştu: $e", name: 'JSON Loader');
  }
}

/// 📌 Firestore 'daki kelime sayısını hesapla
Future<int> getFirestoreWordCount() async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('kelimeler').get();
    return snapshot.docs.length;
  } catch (e) {
    log("❌ Firestore sayımı başarısız: $e", name: 'JSON Loader');
    return 0;
  }
}

/// 📌 Asset JSON içindeki kelime sayısını hesapla
Future<int> getWordCountFromAssetJson() async {
  try {
    final jsonStr = await rootBundle.loadString(
      'assets/database/$fileNameJson',
    );
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    // log("📌 Asset içindeki kelime sayısı (json) : ${jsonList.length}");
    return jsonList.length;
  } catch (e) {
    log("❌ Asset JSON okunamadı: $e", name: 'JSON Loader');
    return 0;
  }
}
