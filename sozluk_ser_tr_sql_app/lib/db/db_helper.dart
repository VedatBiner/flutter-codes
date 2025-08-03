// 📃 <----- db_helper.dart ----->
// Tüm veri tabanı işlemleri
// Tüm CSV JSON işlemleri
// Türkçe harflere göre sıralama metodu burada tanımlanıyor
//

// 📌 Dart hazır paketleri
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

/// 📌 Flutter hazır paketleri
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/file_info.dart';
import '../models/word_model.dart';
import '../providers/word_count_provider.dart';
import '../utils/excel_backup_helper.dart';
import '../widgets/notification_service.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  /// 📌 SQLite veritabanı nesnesini alır.
  ///
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(fileNameSql);
    return _database!;
  }

  /// 📌 📌 Veritabanını başlatır veya oluşturur
  ///
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, fileName);

    log('📁 Veritabanı hedef konumu: $fullPath', name: 'DB Helper');

    final internalDbFile = File(fullPath);

    if (await internalDbFile.exists()) {
      log(
        '📦 Yerel veritabanı zaten var. Doğrudan açılıyor...',
        name: 'DB Helper',
      );
    } else {
      log(
        '🆕 Yerel veritabanı bulunamadı. Yeni veritabanı oluşturulacak.',
        name: 'DB Helper',
      );
    }

    return await openDatabase(fullPath, version: 1, onCreate: _createDB);
  }

  /// 📌 Yeni bir veritabanı oluşturur.
  ///
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sirpca TEXT NOT NULL,
        turkce TEXT NOT NULL,
        userEmail TEXT NOT NULL
      )
    ''');
  }

  /// 📌 Tüm kelimeleri alır.
  ///
  Future<List<Word>> getRecords() async {
    final db = await instance.database;
    final result = await db.query('words'); // OrderBy kaldırıldı
    final words = result.map((e) => Word.fromMap(e)).toList();

    return _sortSerbian(words); // 👈 Sırpça sıralamayı uygula
  }

  /// 📌 Kelimeyi aramak için kullanılır.
  ///
  Future<Word?> getWord(String word) async {
    final db = await instance.database;
    final result = await db.query(
      'words',
      where: 'sirpca = ?',
      whereArgs: [word],
    );
    return result.isNotEmpty ? Word.fromMap(result.first) : null;
  }

  /// 📌 Yeni kelimeyi ekler.
  ///
  Future<int> insertRecord(Word word) async {
    final db = await instance.database;
    final result = await db.insert('words', word.toMap());

    // ✅ Kelime sayısını güncelle
    WordCountProvider().updateCount(); // Bu çalışmaz çünkü context yok

    return result;
  }

  /// 📌 ID ye göre kelimeyi günceller.
  ///
  Future<int> updateRecord(Word word) async {
    final db = await instance.database;
    return await db.update(
      'words',
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  /// 📌 ID ye göre kelimeyi siler.
  ///
  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete('words', where: 'id = ?', whereArgs: [id]);
  }

  /// 📌 Toplam kelime sayısını döner.
  ///
  Future<int> countRecords() async {
    final db = await instance.database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM words'),
    );
    return result ?? 0;
  }

  /// 📌 JSON yedeği burada alınıyor.
  ///
  Future<String> exportRecordsToJson() async {
    final words = await getRecords();
    final wordMaps = words.map((w) => w.toMap()).toList();
    final jsonString = jsonEncode(wordMaps);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameJson';

    final file = File(filePath);
    await file.writeAsString(jsonString);

    return filePath;
  }

  /// 📌 JSON yedeği burada geri yükleniyor.
  ///
  Future<void> importRecordsFromJson(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameJson';
      final file = File(filePath);

      if (!(await file.exists())) {
        log('❌ Yedek dosyası bulunamadı: $filePath', name: 'Import');

        if (context.mounted) {
          NotificationService.showCustomNotification(
            context: context,
            title: 'Dosya Bulunamadı',
            message: const Text('JSON yedek dosyası bulunamadı.'),
            icon: Icons.error_outline,
            iconColor: Colors.red,
            progressIndicatorColor: Colors.red,
            progressIndicatorBackground: Colors.red.shade100,
          );
        }
        return;
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);

      final db = await database;
      await db.delete('words');

      for (var item in jsonList) {
        final map = item as Map<String, dynamic>;
        final word = Word(
          sirpca: map['sirpca'] ?? '',
          turkce: map['turkce'] ?? '',
          userEmail: map['userEmail'] ?? '',
        );

        await insertRecord(word);
      }

      log(
        '✅ JSON yedeği başarıyla yüklendi. (${jsonList.length} kayıt)',
        name: 'Import',
      );

      if (context.mounted) {
        NotificationService.showCustomNotification(
          context: context,
          title: 'JSON Yedeği Yüklendi',
          message: Text('${jsonList.length} kelime başarıyla yüklendi.'),
          icon: Icons.upload_file,
          iconColor: Colors.green,
          progressIndicatorColor: Colors.green,
          progressIndicatorBackground: Colors.green.shade100,
        );
      }
    } catch (e) {
      log('🚨 Geri yükleme hatası: $e', name: 'Import');
    }
  }

  /// 📌 CSV yedeği burada alınıyor.
  ///
  Future<String> exportRecordsToCsv() async {
    final words = await getRecords();
    final buffer = StringBuffer();

    buffer.writeln('Sirpca,Turkce');

    for (var word in words) {
      final kelime = word.sirpca.replaceAll(',', '');
      final anlam = word.turkce.replaceAll(',', '');
      buffer.writeln('$kelime,$anlam');
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameCsv';
    final file = File(filePath);

    await file.writeAsString(buffer.toString());

    return filePath;
  }

  /// 📌 CSV yedeği burada geri yükleniyor.
  ///
  Future<void> importRecordsFromCsv() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameCsv';
      final file = File(filePath);

      if (!(await file.exists())) {
        log('❌ CSV dosyası bulunamadı: $filePath', name: 'Import');
        return;
      }

      final lines = await file.readAsLines();

      if (lines.isEmpty) {
        log('❌ CSV dosyası boş.', name: 'Import');
        return;
      }

      final db = await database;
      await db.delete('words');

      int count = 0;
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split(',');
        if (parts.length < 2) continue;

        final kelime = parts[0].trim();
        final anlam = parts.sublist(1).join(',').trim();

        final word = Word(
          sirpca: kelime,
          turkce: anlam,
          userEmail: 'default@email.com',
        );

        await insertRecord(word);
        count++;
      }

      log('✅ CSV yedeği başarıyla yüklendi. ($count kayıt)', name: 'Import');
    } catch (e) {
      log('🚨 CSV yükleme hatası: $e', name: 'Import');
    }
  }

  /// 📌 Excel yedeği burada alınıyor.
  Future<String> exportRecordsToExcel() async {
    // 1️⃣ Excel dosyasını oluşturacak yardımcıyı çağırıyoruz
    final filePath = await createExcelBackup();

    // 2️⃣ Path 'i geri döndürüyoruz
    return filePath;
  }

  /// 📌 Türkçe sıralama yöntemi.
  ///
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

  /// 📌 Sırpça sıralama yöntemi.
  ///
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

        // Özel ikili harf kontrolleri (Dž, Lj, Nj)
        if (i + 1 < a.length) {
          final doubleChar = a.substring(i, i + 2);
          if (serbianAlphabet.contains(doubleChar)) {
            aChar = doubleChar;
          }
        }

        if (i + 1 < b.length) {
          final doubleChar = b.substring(i, i + 2);
          if (serbianAlphabet.contains(doubleChar)) {
            bChar = doubleChar;
          }
        }

        final ai = serbianAlphabet.indexOf(aChar);
        final bi = serbianAlphabet.indexOf(bChar);

        if (ai != bi) return ai.compareTo(bi);

        i += aChar.length; // Tek veya çift harf olabilir
      }

      return a.length.compareTo(b.length);
    }

    words.sort((a, b) => serbianCompare(a.sirpca, b.sirpca));
    return words;
  }

  /// 📌 Firestore 'dan verileri alıp JSON 'a kaydeder.
  ///
  Future<void> fetchWordsFromFirestoreAndSaveAsJson() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('kelimeler').get();

    final List<Map<String, dynamic>> wordList =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'sirpca': data['sirpca'],
            'turkce': data['turkce'],
            'userEmail': data['userEmail'] ?? '',
          };
        }).toList();

    final jsonStr = jsonEncode(wordList);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileNameJson');

    await file.writeAsString(jsonStr);

    log(
      '✅ Firestore verileri JSON olarak kaydedildi (${wordList.length} kayıt).',
    );
  }

  /// 📌 Firestore 'dan verileri alır.
  Future<void> syncFirestoreIfDatabaseEmpty(BuildContext context) async {
    final count = await countRecords();

    if (count > 0) {
      log(
        "📦 Veritabanı zaten dolu ($count kayıt). Firestore 'dan veri çekilmeyecek.",
      );
      return;
    }

    log("📭 Veritabanı boş. Firestore 'dan veriler çekilecek...");

    await fetchWordsFromFirestoreAndSaveAsJson();

    if (context.mounted) {
      await importRecordsFromJson(context);
    }
  }

  /// 📌 Veritabanında aynı Sırpça kelime varsa true döner
  Future<bool> wordExists(String sirpca) async {
    final db = await database;
    final result = await db.query(
      'words',
      where: 'sirpca = ?',
      whereArgs: [sirpca],
    );
    return result.isNotEmpty;
  }

  /// 📌 Asset içindeki SQL veritabanındaki kayıt sayısını döndürür.
  ///    (Sadece okuma amaçlı; uygulama veritabanına dokunmaz.)
  Future<int> countWordsAssetSql() async {
    // 1️⃣ Asset dosyasını belleğe yükle
    final byteData = await rootBundle.load('assets/database/ser_tr_dict.db');

    // 2️⃣ Geçici dizine kopyala
    final tmpDir = await getTemporaryDirectory();
    final tempPath = join(tmpDir.path, 'asset_temp.db');
    final tempFile = File(tempPath);
    await tempFile.writeAsBytes(
      byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
      flush: true,
    );

    // 3️⃣ Sadece okuma modunda aç ve COUNT(*) yap
    final db = await openDatabase(tempPath, readOnly: true);
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM words'),
    );
    await db.close();

    // 4️⃣ (İsteğe bağlı) geçici dosyayı sil
    await tempFile.delete();

    return result ?? 0;
  }
}
