// <📜 ----- export_words.dart ----->
/*
  📦 Firestore → JSON dışa aktarma (Word modeli ile, web + mobil/desktop uyumlu)

  NE YAPAR?
  1) Firestore’da `collectionName` (file_info.dart) koleksiyonunu
     `withConverter<Word>` kullanarak **tipli** şekilde okur.
  2) `FieldPath.documentId` ile **sayfalı** (pageSize) olarak TÜM belgeleri çeker.
     - Bu sayfalama doküman ID’sine göre ilerler; ek indeks gerekmez.
  3) Her belgeyi `Word.toJson(includeId: true)` ile JSON’a çevirir ve pretty-print eder.
  4) Dosya adını `fileNameJson` (file_info.dart) olarak kullanır.
     - Web: tarayıcı indirmesi başlatır (aynı isim varsa tarayıcı numaralandırır).
     - Android/Desktop: **Downloads** klasörüne (opsiyonel `subfolder` altında) yazar.
     - iOS: sistemde “Downloads” yok → **Belgeler + Paylaş** (Files ile Downloads’a taşınabilir).

  GERİ DÖNÜŞ:
  - Kaydedilen konum (tam dosya yolu veya `download://<filename>` benzeri bilgi)
    döner; UI’da status/snackbar ile göstermek için idealdir.

  NOTLAR:
  - Büyük koleksiyonlarda bellek ve ağ yükünü azaltmak için `pageSize`’i küçültebilirsiniz.
  - `JsonSaver` koşullu import ile platformu otomatik seçer (web vs IO).
*/

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:developer' show log;

/// 📌 Flutter hazır paketleri
import 'package:cloud_firestore/cloud_firestore.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../models/word_model.dart';
import '../utils/json_saver.dart';

Future<String> exportWordsToJson({
  int pageSize = 1000,
  String? subfolder = 'kelimelik_words_app',
}) async {
  final sw = Stopwatch()..start();
  final List<Word> all = [];

  try {
    // Tipli referans
    final col = FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<Word>(
          fromFirestore: Word.fromFirestore,
          toFirestore: (w, _) => w.toFirestore(),
        );

    // docId ile stabil sayfalama
    Query<Word> base = col.orderBy(FieldPath.documentId);
    String? lastId;

    while (true) {
      var q = base.limit(pageSize);
      if (lastId != null) q = q.startAfter([lastId]);

      final snap = await q.get();
      if (snap.docs.isEmpty) break;

      for (final d in snap.docs) {
        all.add(d.data());
      }

      lastId = snap.docs.last.id;
      if (snap.docs.length < pageSize) break;
    }

    // JSON oluştur
    final jsonStr = const JsonEncoder.withIndent(
      '  ',
    ).convert(all.map((w) => w.toJson(includeId: true)).toList());

    // Dosya adı sabit (file_info.dart)
    final filename = fileNameJson;

    // Platforma göre kaydet/indir
    final savedAt = await JsonSaver.saveToDownloads(
      jsonStr,
      filename,
      subfolder: subfolder,
    );

    sw.stop();
    log(
      '📦 JSON hazırlandı: ${all.length} kayıt, ${sw.elapsedMilliseconds} ms',
      name: collectionName,
    );

    return savedAt;
  } catch (e, st) {
    sw.stop();
    log(
      '❌ Hata (exportWordsToJson): $e',
      name: collectionName,
      error: e,
      stackTrace: st,
      level: 1000,
    );
    rethrow;
  }
}
