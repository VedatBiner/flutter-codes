// 📃 <----- lib/utils/fc_files/sync_helper.dart ----->
//
// CSV ↔ SQL Incremental Sync
// -----------------------------------------------------------
// • Device CSV (Documents/fileNameCsv) ile SQLite veritabanını
//   karşılaştırır.
// • Eksik kelimeler SQL'e EKLENİR.
// • Varsa, anlamı değişmiş kelimelerin anlamı GÜNCELLENİR.
// • Kullanıcının sonradan eklediği kelimeler SİLİNMEZ.
// -----------------------------------------------------------
// Bu dosya, db_helper.dart içindeki mevcut yapıya %100 uyumludur.
//
// ⚠️ NOT (GÜNCEL DURUM):
// CSV artık 3 sütun içerir: Kelime,Anlam,Tarih
// Bu nedenle sync sırasında:
//   - Kelime = 1. sütun
//   - Anlam  = 2. sütun
//   - Tarih  = 3. sütun (VARSA) okunur ama DB’ye meaning olarak yazılmaz
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';
import '../../db/db_helper.dart';
import '../../models/item_model.dart';

class CsvDbSyncResult {
  final int totalCsv;
  final int totalDbBefore;
  final int inserted;
  final int updated;

  const CsvDbSyncResult({
    required this.totalCsv,
    required this.totalDbBefore,
    required this.inserted,
    required this.updated,
  });
}

/// 📌 Device CSV ile veritabanını incremental olarak senkronize eder.
/// Hiçbir SQL kaydı silinmez.
/// - Asset → Device CSV : createOrUpdateDeviceCsvFromAsset() tarafından yapılmış olmalı.
/// - Bu fonksiyon sadece: Eksik kayıt ekler, farklı anlamları günceller.
Future<CsvDbSyncResult> syncCsvWithDatabase() async {
  const tag = 'sync_helper';

  // 1️⃣ Device Documents klasöründen CSV yolunu hesapla
  final docs = await getApplicationDocumentsDirectory();
  final csvPath = join(docs.path, fileNameCsv);
  final csvFile = File(csvPath);

  if (!await csvFile.exists()) {
    log('❌ syncCsvWithDatabase: CSV bulunamadı: $csvPath', name: tag);
    return const CsvDbSyncResult(
      totalCsv: 0,
      totalDbBefore: 0,
      inserted: 0,
      updated: 0,
    );
  }

  // 2️⃣ CSV satırlarını oku
  final lines = await csvFile.readAsLines();
  if (lines.isEmpty) {
    log('⚠️ syncCsvWithDatabase: CSV boş.', name: tag);
    return const CsvDbSyncResult(
      totalCsv: 0,
      totalDbBefore: 0,
      inserted: 0,
      updated: 0,
    );
  }

  // İlk satır başlık olduğu için atlıyoruz
  final dataLines = lines.skip(1).where((l) => l.trim().isNotEmpty).toList();

  // 3️⃣ CSV → Word list
  // CSV formatı: Kelime,Anlam,Tarih
  // Bu sync işlemi için Tarih (3. sütun) DB’ye meaning olarak yazılmaz.
  final List<Word> csvWords = [];
  for (final line in dataLines) {
    final parts = line.split(',');
    if (parts.length < 2) continue;

    final kelime = parts[0].trim();
    final anlam = parts[1].trim(); // ✅ SADECE 2. SÜTUN

    if (kelime.isEmpty || anlam.isEmpty) continue;

    csvWords.add(Word(word: kelime, meaning: anlam));
  }

  // 4️⃣ Mevcut DB kayıtlarını al
  final dbWords = await DbHelper.instance.getRecords();
  final totalDbBefore = dbWords.length;

  // word (lowercase) → Word map
  final Map<String, Word> dbMap = {
    for (final w in dbWords) w.word.toLowerCase(): w,
  };

  // 5️⃣ Eksik olanlar ve güncellenecekler
  final List<Word> toInsert = [];
  int updatedCount = 0;

  for (final csvWord in csvWords) {
    final key = csvWord.word.toLowerCase();
    final existing = dbMap[key];

    if (existing == null) {
      // DB 'de yok → yeni eklenecek
      toInsert.add(csvWord);
    } else {
      // Var ama anlamı farklı mı?
      final dbMeaning = existing.meaning.trim();
      final csvMeaning = csvWord.meaning.trim();
      if (dbMeaning != csvMeaning) {
        // Sadece anlam güncelle
        final updatedWord = Word(
          id: existing.id,
          word: existing.word,
          meaning: csvWord.meaning,
        );
        await DbHelper.instance.updateRecord(updatedWord);
        updatedCount++;
      }
    }
  }

  // 6️⃣ Batch insert ile eksik kelimeleri ekle
  if (toInsert.isNotEmpty) {
    await DbHelper.instance.insertBatch(toInsert);
  }

  final result = CsvDbSyncResult(
    totalCsv: csvWords.length,
    totalDbBefore: totalDbBefore,
    inserted: toInsert.length,
    updated: updatedCount,
  );

  log('🔄 CSV↔SQL Sync tamamlandı:', name: tag);
  log('   • CSV Toplam: ${result.totalCsv}', name: tag);
  log('   • DB (önce) : ${result.totalDbBefore}', name: tag);
  log('   • INSERT    : ${result.inserted}', name: tag);
  log('   • UPDATE    : ${result.updated}', name: tag);

  return result;
}
