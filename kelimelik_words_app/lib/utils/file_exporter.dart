// 📃 <----- lib/utils/file_exporter.dart ----->
//
// SQL → CSV → JSON → XLSX → ZIP pipeline
// -----------------------------------------------------------
// Bu dosya, veritabanındaki en güncel verilere göre
// 4 dosya üretir:
//
// 1) kelimelik_backup.json
// 2) kelimelik_backup.csv
// 3) kelimelik_backup.xlsx
// 4) kelimelik.db  (birebir kopya)
// 5) kelimelik_backup.zip (tüm dosyalar içinde)
//
// Tüm üretim işlemleri Documents/{appName} altına yapılır.
// Sonra hepsi Download/{appName} klasörüne kopyalanır.
// Download erişimi için izin home_page.dart içinde yönetilir.

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../widgets/bottom_banner_helper.dart';
import 'external_copy.dart';
import 'fc_files/excel_helper.dart'; // createExcelFromAssetCsvSyncfusion
import 'fc_files/zip_helper.dart';

const _tag = "file_exporter";

Future<void> runFullExportPipeline(
  BuildContext context, {
  void Function(String msg)? onStatus,
  void Function(bool exporting)? onExporting,
  void Function(String zipPath)? onFinished,
}) async {
  onStatus?.call("Export başlatılıyor…");
  onExporting?.call(true);

  final banner = showLoadingBanner(
    context,
    message: "Lütfen bekleyiniz…\nYedek hazırlanıyor.",
  );

  try {
    log("🚀 Export pipeline başladı", name: _tag);

    // ----------------------------------------------------------
    // 📁 Documents/{appName} klasörünü oluştur
    // ----------------------------------------------------------
    final docs = await getApplicationDocumentsDirectory();
    final exportDir = Directory(join(docs.path, appName));
    await exportDir.create(recursive: true);

    onStatus?.call("SQL verileri okunuyor…");

    // ----------------------------------------------------------
    // 🔥 SQL → Liste
    // ----------------------------------------------------------
    final items = await DbHelper.instance.getRecords();
    final count = items.length;

    log("📌 Toplam kayıt: $count", name: _tag);
    onStatus?.call("$count kayıt işleniyor…");

    // ----------------------------------------------------------
    // 1️⃣ CSV (DbHelper kendi fonksiyonu ile) + exportDir’e kopya
    // ----------------------------------------------------------
    onStatus?.call("CSV oluşturuluyor…");
    final deviceCsv = await DbHelper.instance
        .exportRecordsToCsv(); // docs/kelimelik_backup.csv
    final csvPath = join(exportDir.path, fileNameCsv);
    await File(deviceCsv).copy(csvPath);
    log("✅ CSV hazır: $csvPath", name: _tag);

    // ----------------------------------------------------------
    // 2️⃣ JSON (DbHelper fonksiyonu) + exportDir’e kopya
    // ----------------------------------------------------------
    onStatus?.call("JSON oluşturuluyor…");
    final jsonOriginal = await DbHelper.instance
        .exportRecordsToJson(); // docs/kelimelik_backup.json
    final jsonPath = join(exportDir.path, fileNameJson);
    await File(jsonOriginal).copy(jsonPath);
    log("✅ JSON hazır: $jsonPath", name: _tag);

    // ----------------------------------------------------------
    // 3️⃣ Excel — önce docs altında üret, sonra exportDir’e kopyala
    // ----------------------------------------------------------
    onStatus?.call("Excel (XLSX) oluşturuluyor…");

    // 📌 Bu fonksiyon: docs/path/fileNameXlsx konumuna yazar
    await createExcelFromAssetCsvSyncfusion();

    final excelDevicePath = join(docs.path, fileNameXlsx);
    final excelPath = join(exportDir.path, fileNameXlsx);

    if (await File(excelDevicePath).exists()) {
      await File(excelDevicePath).copy(excelPath);
      log("✅ Excel hazır: $excelPath", name: _tag);
    } else {
      log("⚠️ Excel dosyası bulunamadı: $excelDevicePath", name: _tag);
    }

    // ----------------------------------------------------------
    // 4️⃣ SQL dosyasının kopyasını exportDir’e al
    // ----------------------------------------------------------
    onStatus?.call("SQL veritabanı kopyalanıyor…");
    final sqlOriginal = join(docs.path, fileNameSql);
    final sqlPath = join(exportDir.path, fileNameSql);

    if (await File(sqlOriginal).exists()) {
      await File(sqlOriginal).copy(sqlPath);
      log("✅ SQL hazır: $sqlPath", name: _tag);
    } else {
      log("⚠️ SQL dosyası bulunamadı: $sqlOriginal", name: _tag);
    }

    // ----------------------------------------------------------
    // 5️⃣ ZIP oluştur — TÜM dosyalar (CSV + JSON + XLSX + SQL)
    // ----------------------------------------------------------
    onStatus?.call("ZIP arşivi oluşturuluyor…");

    final zipPath = await createZipArchive(
      outputDir: exportDir.path,
      files: [csvPath, jsonPath, excelPath, sqlPath],
    );
    log("✅ ZIP hazır: $zipPath", name: _tag);

    // ----------------------------------------------------------
    // 6️⃣ Download/kelimelik_words_app klasörüne kopyala
    // ----------------------------------------------------------
    onStatus?.call("Download klasörüne kopyalanıyor…");

    await copyBackupToDownload(
      files: [csvPath, jsonPath, excelPath, sqlPath, zipPath],
      folderName:
          appName, // → /storage/emulated/0/Download/kelimelik_words_app/
    );

    log("✅ Download klasörüne kopyalandı", name: _tag);
    log("🎁 ZIP tamamlandı: $zipPath", name: _tag);

    // ----------------------------------------------------------
    // ✔ Tamamlandı
    // ----------------------------------------------------------
    onStatus?.call("Export tamamlandı.");
    onFinished?.call(zipPath);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Yedekleme başarılı! $count kayıt export edildi."),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  } catch (e, st) {
    log("❌ Export hata: $e", name: _tag, error: e, stackTrace: st);
    onStatus?.call("Hata: $e");

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Export Hatası: $e"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  } finally {
    banner.close();
    onExporting?.call(false);
    log("🏁 Export pipeline bitti", name: _tag);
  }
}
