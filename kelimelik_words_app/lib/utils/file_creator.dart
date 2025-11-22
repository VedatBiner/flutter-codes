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
// 6️⃣ Tüm dosyalardan bir ZIP arşivi oluşturulur (zip_helper.dart).
// 7️⃣ Tüm dosyalar Download/{appName} dizinine kopyalanır (download_helper.dart).
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
import 'fc_files/excel_helper.dart';
import 'fc_files/json_helper.dart';
// import 'fc_files/download_helper.dart'; // Download dizinine kopyalama
// import 'fc_files/sql_helper.dart'; // JSON → SQL aktarımı burada

import 'fc_files/zip_helper.dart'; // ZIP arşivi oluşturma

/// 🚀 Uygulama başlatıldığında çağrılır.
/// Tüm veri dosyalarını, veritabanını ve dışa aktarmayı yönetir.
Future<void> initializeAppDataFlow() async {
  const tag = 'file_creator';
  log('🚀 initializeAppDataFlow başladı', name: tag);

  // 📂 Dizinleri al
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = join(directory.path, fileNameSql);
  final dbFile = File(dbPath);

  // ✅ Veritabanı var mı kontrolü (hem dosya hem kayıt sayısı)
  bool dbExists = await dbFile.exists();
  int recordCount = 0;

  if (dbExists) {
    try {
      recordCount = await DbHelper.instance.countRecords();
    } catch (e) {
      log('⚠️ Veritabanı kontrolü sırasında hata: $e', name: tag);
    }
  }

  // 🧩 Eğer veritabanı mevcut ve kayıt da varsa işlem yapılmaz
  if (dbExists && recordCount > 0) {
    log(
      '[JSON→SQL Import (Batch)] 🟢 Veritabanı zaten dolu ($recordCount kayıt). Tekrar oluşturulmadı.',
      name: tag,
    );
    return;
  }

  // 🔹 Aksi durumda sıfırdan oluşturma süreci başlatılır
  log(
    '⚠️ Veritabanı bulunamadı veya boş. Asset CSV ’den veri oluşturulacak.',
    name: tag,
  );

  /// 1️⃣ CSV oluştur (cihazda yoksa)
  await createDeviceCsvFromAsset();

  /// 2️⃣ JSON oluştur (cihazda yoksa)
  await createJsonFromAssetCsv();

  /// 3️⃣ Excel oluştur (excel_helper.dart)
  await createExcelFromAssetCsvSyncfusion();

  /// 4️⃣ JSON → SQL aktarımı (sql_helper.dart)
  // await importJsonToDatabaseFast();

  /// 5️⃣ ZIP arşivi oluştur
  await createZipArchive();

  // 6️⃣ Dosyaları Download dizinine kopyala
  // await copyBackupFilesToDownload();

  log('✅ initializeAppDataFlow tamamlandı.', name: tag);
}
