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
// Download erişimi home_page.dart tarafından yönetilir.

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../widgets/bottom_banner_helper.dart';
import 'fc_files/excel_helper.dart'; // <-- Excel için
// <-- JSON üretimi için
import 'fc_files/zip_helper.dart';

const _tag = "file_exporter";

/// 📤 *TAM EXPORT PIPELINE*
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

    //----------------------------------------------------------------------
    // 📁 Documents/{appName} klasörünü oluştur
    //----------------------------------------------------------------------
    final documents = await getApplicationDocumentsDirectory();
    final exportDir = Directory(join(documents.path, appName));
    await exportDir.create(recursive: true);

    onStatus?.call("SQL verileri okunuyor…");

    //----------------------------------------------------------------------
    // 🔥 SQL → Liste
    //----------------------------------------------------------------------
    final items = await DbHelper.instance.getRecords();
    final count = items.length;

    log("📌 Toplam kayıt: $count", name: _tag);
    onStatus?.call("$count kayıt işleniyor…");

    //----------------------------------------------------------------------
    // 1️⃣ CSV Üret (DbHelper fonksiyonu)
    //----------------------------------------------------------------------
    onStatus?.call("CSV oluşturuluyor…");
    final csvPath = await DbHelper.instance.exportRecordsToCsv();

    //----------------------------------------------------------------------
    // 2️⃣ JSON Üret (DbHelper fonksiyonu)
    //----------------------------------------------------------------------
    onStatus?.call("JSON oluşturuluyor…");
    final jsonPath = await DbHelper.instance.exportRecordsToJson();

    //----------------------------------------------------------------------
    // 3️⃣ XLSX Üret — veritabanındaki güncel kayıtlarla
    //----------------------------------------------------------------------
    onStatus?.call("XLSX oluşturuluyor…");

    final excelPath = join(exportDir.path, fileNameXlsx);
    await exportItemsToExcelFromList(excelPath, items);

    //----------------------------------------------------------------------
    // 4️⃣ SQL dosyasının kopyasını export klasörüne al
    //----------------------------------------------------------------------
    onStatus?.call("Veritabanı kopyalanıyor…");

    final dbOriginal = await getApplicationDocumentsDirectory();
    final dbFullPath = join(dbOriginal.path, fileNameSql);

    final sqlCopyPath = join(exportDir.path, fileNameSql);
    await File(dbFullPath).copy(sqlCopyPath);

    //----------------------------------------------------------------------
    // 5️⃣ ZIP oluştur — TÜM DOSYALAR
    //----------------------------------------------------------------------
    onStatus?.call("ZIP oluşturuluyor…");

    final zipPath = await createZipArchive(
      outputDir: exportDir.path,
      files: [csvPath, jsonPath, excelPath, sqlCopyPath],
    );

    log("🎁 ZIP tamamlandı: $zipPath", name: _tag);

    //----------------------------------------------------------------------
    // ✔ Tamamlandı
    //----------------------------------------------------------------------
    onStatus?.call("Export tamamlandı.");
    onFinished?.call(zipPath);
  } catch (e, st) {
    log("❌ Export hata: $e", name: _tag, error: e, stackTrace: st);
    onStatus?.call("Hata: $e");

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Export Hatası: $e")));
    }
  } finally {
    banner.close();
    onExporting?.call(false);
    log("🏁 Export pipeline bitti", name: _tag);
  }
}
