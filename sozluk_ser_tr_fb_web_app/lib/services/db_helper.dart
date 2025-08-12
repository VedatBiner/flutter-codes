// 📃 <----- db_helper.dart ----->
// Tüm veri işlemleri (Firestore odaklı)
// - Firestore CRUD yardımcıları (listeleme/sayım/varlık kontrolü)
// - JSON / CSV / Excel dışa aktarma - içe aktarma (MOBİL için dosya sistemi)
// - Türkçe ve Sırpça sıralama yardımcıları
//
// ⚠️ Not: Web 'de dosya yazmak için dart:html (AnchorElement) vb. gerekir.
// Aşağıdaki dosya işlemleri (dart:io + path_provider) mobil (Android/iOS) içindir.

// 📌 Dart paketleri
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

/// 📌 Flutter paketleri
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../models/word_model.dart';
import 'notification_service.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  DbHelper._init();

  // Firestore koleksiyonu
  static const _collection = 'kelimeler';
  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection(_collection);

  // ---------------------------------------------------------------------------
  // FIRESTORE -> LİSTELEME / SAYIM / VARLIK KONTROLÜ
  // ---------------------------------------------------------------------------

  /// Tüm kayıtları Firestore ’dan çeker (opsiyonel userEmail filtresi).
  /// Dönen liste, Sırpça alfabesine göre sıralanır.
  Future<List<Word>> fetchAllWords({String? userEmail, int? limit}) async {
    Query<Map<String, dynamic>> q = _col;
    if (userEmail != null && userEmail.isNotEmpty) {
      q = q.where('userEmail', isEqualTo: userEmail);
    }
    if (limit != null && limit > 0) {
      q = q.limit(limit);
    }

    final snap = await q.get();
    final words = snap.docs
        .map((d) => Word.fromMap(d.data(), id: d.id))
        .toList();

    return _sortSerbian(words);
  }

  /// Toplam kayıt sayısı (aggregate count destekliyse onu kullanır).
  Future<int> countRecords({String? userEmail}) async {
    try {
      Query<Map<String, dynamic>> q = _col;
      if (userEmail != null && userEmail.isNotEmpty) {
        q = q.where('userEmail', isEqualTo: userEmail);
      }

      try {
        final agg = await q.count().get();
        return agg.count;
      } catch (_) {
        final snap = await q.get();
        return snap.size;
      }
    } catch (e, st) {
      log('⚠️ Firestore sayım hatası: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Aynı (sirpca, userEmail) kombinasyonunda kayıt var mı?
  Future<bool> wordExists({
    required String sirpca,
    required String userEmail,
  }) async {
    final q = await _col
        .where('userEmail', isEqualTo: userEmail)
        .where('sirpca', isEqualTo: sirpca)
        .limit(1)
        .get();
    return q.docs.isNotEmpty;
  }

  // ---------------------------------------------------------------------------
  // JSON EXPORT (FIRESTORE -> DOSYA)
  // ---------------------------------------------------------------------------

  /// Firestore’daki tüm veriyi JSON olarak kaydeder (MOBİL).
  /// Dönüş: oluşturulan dosya yolu.
  Future<String> exportRecordsToJson({String? userEmail}) async {
    final words = await fetchAllWords(userEmail: userEmail);
    final maps = words.map((w) => w.toMap()).toList();
    final jsonStr = jsonEncode(maps);

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileNameJson';
    final file = File(filePath);
    await file.writeAsString(jsonStr);

    log('✅ JSON export tamam: ${words.length} kayıt -> $filePath');
    return filePath;
  }

  // ---------------------------------------------------------------------------
  // JSON IMPORT (DOSYA -> FIRESTORE)
  // ---------------------------------------------------------------------------

  /// JSON yedeğini okuyup Firestore’a yazar (MOBİL).
  /// userEmail parametresi verilirse boş gelen kayıtlara bu email atanır.
  Future<void> importRecordsFromJson(
    BuildContext context, {
    String? userEmail,
    bool clearCollectionBefore = false,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$fileNameJson';
      final file = File(path);

      if (!(await file.exists())) {
        log('❌ JSON dosyası yok: $path', name: 'Import');
        if (context.mounted) {
          NotificationService.showCustomNotification(
            context: context,
            title: 'Dosya Bulunamadı',
            message: const Text('JSON yedek dosyası bulunamadı.'),
            icon: Icons.error_outline,
            iconColor: Colors.red,
            progressIndicatorColor: Colors.red,
            progressIndicatorBackground: Colors.redAccent.shade100,
          );
        }
        return;
      }

      final jsonStr = await file.readAsString();
      final List<dynamic> list = jsonDecode(jsonStr);

      // İsteğe bağlı: koleksiyonu baştan temizle
      if (clearCollectionBefore) {
        await _deleteAllInCollection();
      }

      // Batch ile yaz (400-450'lik parçalara böl)
      int written = 0;
      WriteBatch? batch;
      int batchCount = 0;

      Future<void> _commitBatch() async {
        if (batchCount == 0 || batch == null) return;
        await batch!.commit();
        batch = null;
        batchCount = 0;
      }

      for (final item in list) {
        final map = Map<String, dynamic>.from(item as Map);
        // userEmail boş ise parametre ile doldur
        map['userEmail'] = (map['userEmail'] ?? userEmail ?? '');

        batch ??= FirebaseFirestore.instance.batch();
        final doc = _col.doc(); // yeni doc id
        batch!.set(doc, {
          'sirpca': map['sirpca'] ?? '',
          'turkce': map['turkce'] ?? '',
          'userEmail': map['userEmail'] ?? '',
        });

        batchCount++;
        written++;

        if (batchCount >= 400) {
          await _commitBatch();
        }
      }
      await _commitBatch();

      log(
        '✅ JSON import tamam: $written kayıt Firestore ’a yazıldı.',
        name: 'Import',
      );

      if (context.mounted) {
        NotificationService.showCustomNotification(
          context: context,
          title: 'JSON Yüklendi',
          message: Text('$written kelime yüklendi.'),
          icon: Icons.upload_file,
          iconColor: Colors.green,
          progressIndicatorColor: Colors.green,
          progressIndicatorBackground: Colors.green.shade100,
        );
      }
    } catch (e, st) {
      log('🚨 JSON import hatası: $e', name: 'Import', stackTrace: st);
    }
  }

  // ---------------------------------------------------------------------------
  // CSV EXPORT (FIRESTORE -> DOSYA)
  // ---------------------------------------------------------------------------

  /// Firestore verisini CSV dosyasına yazar (MOBİL).
  /// Dönüş: oluşturulan dosya yolu.
  Future<String> exportRecordsToCsv({String? userEmail}) async {
    final words = await fetchAllWords(userEmail: userEmail);
    final buffer = StringBuffer()..writeln('Sirpca,Turkce,UserEmail');

    for (final w in words) {
      // virgül kaçışı (basit)
      final s = (w.sirpca).replaceAll(',', ' ');
      final t = (w.turkce).replaceAll(',', ' ');
      final u = (w.userEmail).replaceAll(',', ' ');
      buffer.writeln('$s,$t,$u');
    }

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileNameCsv';
    await File(filePath).writeAsString(buffer.toString());

    log('✅ CSV export tamam: ${words.length} kayıt -> $filePath');
    return filePath;
  }

  // ---------------------------------------------------------------------------
  // CSV IMPORT (DOSYA -> FIRESTORE)
  // ---------------------------------------------------------------------------

  /// CSV yedeğini okuyup Firestore ’a yazar (MOBİL).
  /// userEmail parametresi verilirse boş gelen kayıtlara bu email atanır.
  Future<void> importRecordsFromCsv({
    String? userEmail,
    bool clearCollectionBefore = false,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$fileNameCsv';
      final file = File(path);

      if (!(await file.exists())) {
        log('❌ CSV dosyası yok: $path', name: 'Import');
        return;
      }

      final lines = await file.readAsLines();
      if (lines.isEmpty) {
        log('❌ CSV boş.', name: 'Import');
        return;
      }

      if (clearCollectionBefore) {
        await _deleteAllInCollection();
      }

      int written = 0;
      WriteBatch? batch;
      int batchCount = 0;

      Future<void> _commitBatch() async {
        if (batchCount == 0 || batch == null) return;
        await batch!.commit();
        batch = null;
        batchCount = 0;
      }

      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        // CSV: Sirpca,Turkce,UserEmail
        final parts = line.split(',');
        if (parts.length < 2) continue;

        final kelime = parts[0].trim();
        final anlam = parts[1].trim();
        final mail =
            (parts.length >= 3 ? parts[2].trim() : '') // varsa CSV’den
                .ifEmpty(userEmail ?? '');

        batch ??= FirebaseFirestore.instance.batch();
        final doc = _col.doc();
        batch!.set(doc, {'sirpca': kelime, 'turkce': anlam, 'userEmail': mail});

        batchCount++;
        written++;

        if (batchCount >= 400) {
          await _commitBatch();
        }
      }
      await _commitBatch();

      log(
        '✅ CSV import tamam: $written kayıt Firestore ’a yazıldı.',
        name: 'Import',
      );
    } catch (e, st) {
      log('🚨 CSV import hatası: $e', name: 'Import', stackTrace: st);
    }
  }

  // ---------------------------------------------------------------------------
  // EXCEL EXPORT (FIRESTORE -> .xlsx)
  // ---------------------------------------------------------------------------

  /// Firestore ’daki veriyi Excel (.xlsx) olarak dışa aktarır (MOBİL).
  /// Dönüş: oluşturulan dosya yolu.
  Future<String> exportRecordsToExcel({String? userEmail}) async {
    final words = await fetchAllWords(userEmail: userEmail);

    final excel = Excel.createExcel();
    final sheet = excel['Kelimeler'];
    sheet.appendRow(['Sırpça', 'Türkçe', 'UserEmail']);
    for (final w in words) {
      sheet.appendRow([w.sirpca, w.turkce, w.userEmail]);
    }

    final bytes = excel.encode()!;
    final dir = await getApplicationDocumentsDirectory();
    final filePath =
        '${dir.path}/$fileNameXlsx'; // file_info.dart içinde tanımlı olsun
    final file = File(filePath)..createSync(recursive: true);
    await file.writeAsBytes(bytes, flush: true);

    log('✅ Excel export tamam: ${words.length} kayıt -> $filePath');
    return filePath;
  }

  // ---------------------------------------------------------------------------
  // YARDIMCILAR
  // ---------------------------------------------------------------------------

  /// Koleksiyondaki tüm belgeleri siler (dikkat!).
  Future<void> _deleteAllInCollection() async {
    const page = 400;
    while (true) {
      final snap = await _col.limit(page).get();
      if (snap.docs.isEmpty) break;
      final batch = FirebaseFirestore.instance.batch();
      for (final d in snap.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
      await Future.delayed(const Duration(milliseconds: 100)); // nefes arası
    }
    log('🧹 Koleksiyon temizlendi: $_collection');
  }

  // Türkçe sıralama
  List<Word> _sortTurkish(List<Word> words) {
    const turkishAlphabet =
        'AaBbCcÇçDdEeFfGgĞğHhIıİiJjKkLlMmNnOoÖöPpRrSsŞşTtUuÜüVvYyZz';

    int turkishCompare(String a, String b) {
      for (int i = 0; i < a.length && i < b.length; i++) {
        final ai = turkishAlphabet.indexOf(a[i]);
        final bi = turkishAlphabet.indexOf(b[i]);
        if (ai != bi) return ai.compareTo(bi);
      }
      return a.length.compareTo(b.length);
    }

    words.sort((a, b) => turkishCompare(a.sirpca, b.sirpca));
    return words;
  }

  // Sırpça sıralama
  List<Word> _sortSerbian(List<Word> words) {
    const serbianAlphabet = [
      'A',
      'a',
      'B',
      'b',
      'C',
      'c',
      'Č',
      'č',
      'Ć',
      'ć',
      'D',
      'd',
      'Dž',
      'dž',
      'Đ',
      'đ',
      'E',
      'e',
      'F',
      'f',
      'G',
      'g',
      'H',
      'h',
      'I',
      'i',
      'J',
      'j',
      'K',
      'k',
      'L',
      'l',
      'Lj',
      'lj',
      'M',
      'm',
      'N',
      'n',
      'Nj',
      'nj',
      'O',
      'o',
      'P',
      'p',
      'R',
      'r',
      'S',
      's',
      'Š',
      'š',
      'T',
      't',
      'U',
      'u',
      'V',
      'v',
      'Z',
      'z',
      'Ž',
      'ž',
    ];

    int serbianCompare(String a, String b) {
      int i = 0;
      while (i < a.length && i < b.length) {
        String aChar = a[i];
        String bChar = b[i];

        if (i + 1 < a.length) {
          final doubleChar = a.substring(i, i + 2);
          if (serbianAlphabet.contains(doubleChar)) aChar = doubleChar;
        }
        if (i + 1 < b.length) {
          final doubleChar = b.substring(i, i + 2);
          if (serbianAlphabet.contains(doubleChar)) bChar = doubleChar;
        }

        final ai = serbianAlphabet.indexOf(aChar);
        final bi = serbianAlphabet.indexOf(bChar);
        if (ai != bi) return ai.compareTo(bi);

        i += aChar.length; // tek ya da çift harf olabilir
      }
      return a.length.compareTo(b.length);
    }

    words.sort((a, b) => serbianCompare(a.sirpca, b.sirpca));
    return words;
  }
}

// Küçük yardımcı (nullable string boşsa başka değerle doldur)
extension _EmptyString on String {
  String ifEmpty(String alt) => isEmpty ? alt : this;
}
