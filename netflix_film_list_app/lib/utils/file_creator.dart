// 📃 <----- lib/utils/file_creator.dart ----->
//
// 🎬 Netflix Film List App
// -----------------------------------------------------------
// Uygulama veri akışı:
// 1️⃣ Veritabanı var mı kontrol edilir.
// 2️⃣ Yoksa asset içindeki CSV okunur, tarih formatı düzeltilir.
// 3️⃣ CSV → JSON dosyası oluşturulur.
// 4️⃣ JSON → SQL aktarımı yapılır (sql_helper.dart dosyasında).
// 5️⃣ Excel dosyası oluşturulur (excel_helper.dart).
// 6️⃣ Tüm dosyalar Download/{appName} dizinine kopyalanır (download_helper.dart).
//
// Ayrıca:
//  • Eğer veritabanı zaten varsa, hiçbir yeniden oluşturma yapılmaz.
//  • Eksik dosyalar otomatik tamamlanır.
//  • Modern Android izin sistemi ile uyumludur.
//
// Kullanım:
//   await initializeAppDataFlow();
//
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// 📦 Uygulama içi dosyalar
import '../constants/file_info.dart';
import '../db/db_helper.dart';
import 'fc_files/csv_helper.dart';
import 'fc_files/download_helper.dart'; // Download dizinine kopyalama
import 'fc_files/excel_helper.dart'; // CSV → Excel (Syncfusion)
import 'fc_files/json_helper.dart';
import 'fc_files/sql_helper.dart'; // JSON → SQL aktarımı burada

/// 🚀 Uygulama başlatıldığında çağrılır.
/// Tüm veri dosyalarını, veritabanını ve dışa aktarmayı yönetir.
Future<void> initializeAppDataFlow() async {
  const tag = 'AppDataFlow';
  log('🚀 initializeAppDataFlow başladı', name: tag);

  // 📂 Dizinleri al
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = join(directory.path, fileNameSql);
  final dbFile = File(dbPath);

  // ✅ Eğer veritabanı varsa hiçbir şey yapma
  if (await dbFile.exists()) {
    final count = await DbHelper.instance.countRecords();
    log(
      '[JSON→SQL Import (Batch)] 🟢 Veritabanı zaten dolu ($count kayıt). Tekrar oluşturulmadı.',
      name: tag,
    );
    return;
  }

  // 🔹 Veritabanı yoksa işlem sırasını başlat
  log(
    '⚠️ Veritabanı bulunamadı, asset CSV ’den veri oluşturulacak.',
    name: tag,
  );

  // 1️⃣ CSV oluştur (cihazda yoksa)
  await createDeviceCsvFromAssetWithDateFix();

  // 2️⃣ JSON oluştur (cihazda yoksa)
  await createJsonFromAssetCsv();

  // 3️⃣ Excel oluştur (excel_helper.dart)
  await createExcelFromAssetCsvSyncfusion();

  // 4️⃣ JSON → SQL aktarımı (sql_helper.dart)
  await importJsonToDatabaseFast();

  // 5️⃣ Dosyaları Download dizinine kopyala
  await copyBackupFilesToDownload();

  log('✅ initializeAppDataFlow tamamlandı.', name: tag);
}
