// 📃 <----- json_loader.dart ----->
//
// Verilerin tekrar yuklenmesi konsolda ve AppBar 'da buradan izleniyor
//
// Bu sürüm, SQLite bağımlılıklarını kaldırır ve Firestore odaklı çalışır.
// - Firestore doluysa: doğrudan Firestore 'dan okur ve listeyi verir.
// - Firestore boşsa:
//    1) Cihazdaki JSON yedeği varsa -> JSON 'u Firestore 'a yazar (DbHelper.importRecordsFromJson)
//    2) Yoksa asset içindeki JSON 'u batch ile Firestore 'a yükler (importAssetJsonToFirestore)
// Yükleme sırasında onLoadingStatusChange ile progress UI güncellenir.
//

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

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../constants/serbian_alphabet.dart';
import '../models/word_model.dart';
import '../providers/word_count_provider.dart';
import '../services/db_helper.dart';

/// ---------------------------------------------------------------------------
/// 📌 Ana yükleme akışı
/// ---------------------------------------------------------------------------
Future<void> loadDataFromDatabase({
  required BuildContext context,
  required Function(List<Word>) onLoaded,
  required Function(bool, double, String?, Duration) onLoadingStatusChange,
}) async {
  /// 🔍 Ön kontrol: Firestore, JSON karşılaştırması
  final firestoreCount = await getFirestoreWordCount();
  final assetJsonCount = await getWordCountFromAssetJson();

  // DbHelper.countRecords = Firestore toplam sayımına döner
  final dbCount = await DbHelper.instance.countRecords();

  log('🔄 json_loader çalıştı', name: 'JSON Loader');
  log("📦 Firestore 'daki kayıt sayısı: $firestoreCount", name: 'JSON Loader');
  log("📁 Asset JSON 'daki kayıt sayısı: $assetJsonCount", name: 'JSON Loader');
  log(
    "🧮 Firestore (DbHelper.countRecords) sayım: $dbCount",
    name: 'JSON Loader',
  );

  // 🔸 Firestore ’da veri varsa direkt oku ve bitir
  if (dbCount! > 0) {
    log("📦 Firestore dolu, veriler okunuyor...", name: 'JSON Loader');
    final finalWords = await DbHelper.instance.fetchAllWords();
    onLoaded(finalWords);

    if (context.mounted) {
      Provider.of<WordCountProvider>(
        context,
        listen: false,
      ).setCount(finalWords.length);
    }
    return;
  }

  // 🔸 Firestore boşsa önce cihaz JSON 'u var mı diye bak (Documents klasörü)
  try {
    final directory = await getApplicationDocumentsDirectory();
    final deviceFilePath = '${directory.path}/$fileNameJson';
    final deviceFile = File(deviceFilePath);

    if (await deviceFile.exists()) {
      log(
        "📁 Cihazdaki JSON yedeği bulundu: $deviceFilePath",
        name: 'JSON Loader',
      );

      // Progress başlat
      final stopwatch = Stopwatch()..start();
      onLoadingStatusChange(true, 0.0, null, Duration.zero);

      // Cihaz JSON -> Firestore
      await DbHelper.instance.importRecordsFromJson(
        context,
        userEmail: '', // gerekiyorsa kullanıcı e-mail 'i geç
        clearCollectionBefore: true,
      );

      stopwatch.stop();
      onLoadingStatusChange(false, 1.0, null, stopwatch.elapsed);

      // Firestore'dan oku ve dön
      final finalWords = await DbHelper.instance.fetchAllWords();
      onLoaded(finalWords);

      if (context.mounted) {
        Provider.of<WordCountProvider>(
          context,
          listen: false,
        ).setCount(finalWords.length);
      }
      return;
    }
  } catch (e) {
    log("⚠️ Cihaz JSON kontrolünde hata: $e", name: 'JSON Loader');
  }

  // 🔁 Asset JSON 'dan yükleme (Fallback → Asset JSON -> Firestore)
  log(
    "📦 Cihazda JSON yedeği yok. Asset içinden Firestore 'a yükleniyor...",
    name: 'JSON Loader',
  );
  await importAssetJsonToFirestore(onLoadingStatusChange);

  // Yükleme sonrası: Firestore 'dan oku ve dön
  final finalWords = await DbHelper.instance.fetchAllWords();
  onLoaded(finalWords);

  if (context.mounted) {
    Provider.of<WordCountProvider>(
      context,
      listen: false,
    ).setCount(finalWords.length);
  }
}

/// ---------------------------------------------------------------------------
/// 📌 Sırpça harf sıralaması (serbian_alphabet.dart listesini kullanır)
/// ---------------------------------------------------------------------------
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

/// ---------------------------------------------------------------------------
/// 📌 Asset JSON → Firestore (batch) + progress
/// ---------------------------------------------------------------------------
/// Asset altındaki `assets/database/<fileNameJson>` dosyasını okuyup
/// Firestore `kelimeler` koleksiyonuna batch halinde yazar.
/// Progress için onLoadingStatusChange tetiklenir.
Future<void> importAssetJsonToFirestore(
  Function(bool, double, String?, Duration) onLoadingStatusChange,
) async {
  try {
    final jsonStr = await rootBundle.loadString(
      'assets/database/$fileNameJson',
    );
    final List<dynamic> jsonList = json.decode(jsonStr);

    /// 🆕 alfabetik sırala
    final loadedWords = jsonList.map((e) {
      final map = e as Map<String, dynamic>;
      return Word(
        sirpca: map['sirpca'] ?? '',
        turkce: map['turkce'] ?? '',
        userEmail: map['userEmail'] ?? '',
      );
    }).toList();

    loadedWords.sort((a, b) => _compareSerbian(a.sirpca, b.sirpca));

    final stopwatch = Stopwatch()..start();
    onLoadingStatusChange(true, 0.0, null, Duration.zero);

    // Batch yazım (400'lük paketler)
    int written = 0;
    WriteBatch? batch;
    int batchCount = 0;

    Future<void> commitBatch() async {
      if (batchCount == 0 || batch == null) return;
      await batch!.commit();
      batch = null;
      batchCount = 0;
    }

    final col = FirebaseFirestore.instance.collection('kelimeler');

    for (int i = 0; i < loadedWords.length; i++) {
      final word = loadedWords[i];

      batch ??= FirebaseFirestore.instance.batch();
      final doc = col.doc(); // yeni doc id
      batch!.set(doc, {
        'sirpca': word.sirpca,
        'turkce': word.turkce,
        'userEmail': word.userEmail,
      });

      batchCount++;
      written++;

      // UI progress
      onLoadingStatusChange(
        true,
        (i + 1) / loadedWords.length,
        word.sirpca,
        stopwatch.elapsed,
      );

      // çok hızlı olmaması için minik nefes
      await Future.delayed(const Duration(milliseconds: 20));

      if (batchCount >= 400) {
        await commitBatch();
      }
    }
    await commitBatch();

    stopwatch.stop();
    onLoadingStatusChange(false, 1.0, null, stopwatch.elapsed);

    log(
      "✅ Asset JSON import tamam: $written kayıt Firestore 'a yazıldı.",
      name: 'JSON Loader',
    );
  } catch (e, st) {
    log("❌ Asset JSON import hatası: $e", name: 'JSON Loader', stackTrace: st);
    onLoadingStatusChange(false, 0.0, null, Duration.zero);
  }
}

/// ---------------------------------------------------------------------------
/// 📌 Firestore 'daki kelime sayısını hesapla
/// ---------------------------------------------------------------------------
Future<int> getFirestoreWordCount() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('kelimeler')
        .get();
    return snapshot.docs.length;
  } catch (e) {
    log("❌ Firestore sayımı başarısız: $e", name: 'JSON Loader');
    return 0;
  }
}

/// ---------------------------------------------------------------------------
/// 📌 Asset JSON içindeki kelime sayısını hesapla
/// ---------------------------------------------------------------------------
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
