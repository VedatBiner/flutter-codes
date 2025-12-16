// 📃 <----- lib/utils/export_items.dart ----->
//
// SQL → CSV → JSON → XLSX üretir.
// Bu dosya, db_helper.dart, json_helper.dart ve excel_helper.dart
// yapısına %100 uyumludur.
// -----------------------------------------------------------
// • CSV: DbHelper.exportRecordsToCsv()
// • JSON: List<Word> → JSON string
// • Excel: List<Word> → XLSX (Syncfusion – formatlı)
// • SQL: DB dosyası birebir kopyalanır
// • ZIP: ❌ ŞİMDİLİK İPTAL
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../utils/fc_files/csv_helper.dart';

class ExportItems {
  final int count;
  final String csvPath;
  final String jsonPath;
  final String excelPath;
  final String sqlPath;

  /// ZIP artık yok → boş string
  final String zipPath;

  ExportItems({
    required this.count,
    required this.csvPath,
    required this.jsonPath,
    required this.excelPath,
    required this.sqlPath,
    required this.zipPath,
  });
}

/// 🔥 SQL → CSV → JSON → XLSX Pipeline
///
/// • Geçici klasör: Documents/{subfolder}
/// • ZIP üretilmez
/// • Klasör silme işlemi DIŞARIDAN yapılır
Future<ExportItems> exportItemsToFileFormats({
  required String subfolder,
}) async {
  const tag = "export_items";

  // ----------------------------------------------------------
  // 📁 Documents/{subfolder} klasörü (GEÇİCİ)
  // ----------------------------------------------------------
  final docs = await getApplicationDocumentsDirectory();
  final exportDir = Directory(join(docs.path, subfolder));
  await exportDir.create(recursive: true);

  log("📂 Export klasörü: ${exportDir.path}", name: tag);

  // ----------------------------------------------------------
  // 📄 Dosya yolları
  // ----------------------------------------------------------
  final csvPath = join(exportDir.path, fileNameCsv);
  final jsonPath = join(exportDir.path, fileNameJson);
  final excelPath = join(exportDir.path, fileNameXlsx);
  final sqlPath = join(exportDir.path, fileNameSql);

  // ----------------------------------------------------------
  // 1️⃣ SQL → Liste
  // ----------------------------------------------------------
  final items = await DbHelper.instance.getRecords();
  final count = items.length;

  log("📌 Export edilecek kayıt: $count", name: tag);

  // ----------------------------------------------------------
  // 2️⃣ CSV (TEK MERKEZ: csv_helper.dart)
  // ----------------------------------------------------------
  final deviceCsv = await exportCsvFromDatabase();
  await File(deviceCsv).copy(csvPath);

  // ----------------------------------------------------------
  // 3️⃣ JSON
  // ----------------------------------------------------------
  final jsonStr = const JsonEncoder.withIndent(
    '  ',
  ).convert(items.map((e) => e.toMap()).toList());
  await File(jsonPath).writeAsString(jsonStr);

  // ----------------------------------------------------------
  // 4️⃣ XLSX
  // ----------------------------------------------------------
  // Excel üretimi CSV üzerinden yapılır
  // (excel_helper.dart → createExcelFromAssetCsvSyncfusion)
  log("📊 Excel CSV üzerinden üretildi", name: tag);

  // ----------------------------------------------------------
  // 5️⃣ SQL dosyasını kopyala
  // ----------------------------------------------------------
  final sqlOriginal = File(join(docs.path, fileNameSql));
  if (await sqlOriginal.exists()) {
    await sqlOriginal.copy(sqlPath);
  } else {
    log("⚠️ SQL dosyası bulunamadı", name: tag);
  }

  log("✅ Export tamamlandı (ZIP yok)", name: tag);

  return ExportItems(
    count: count,
    csvPath: csvPath,
    jsonPath: jsonPath,
    excelPath: excelPath,
    sqlPath: sqlPath,
    zipPath: "", // ZIP bilinçli olarak boş
  );
}
