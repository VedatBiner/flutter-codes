// 📃 <----- lib/utils/export_items.dart ----->
//
// SQL → CSV → JSON → XLSX → ZIP üretir.
// -----------------------------------------------------------
// db_helper.dart + excel_helper.dart ile tam uyumlu
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../utils/fc_files/excel_helper.dart';
import '../utils/fc_files/zip_helper.dart';

class ExportItems {
  final int count;
  final String csvPath;
  final String jsonPath;
  final String excelPath;
  final String sqlPath;
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

Future<ExportItems> exportItemsToFileFormats({
  required String? subfolder,
}) async {
  const tag = "export_items";

  // 📁 Documents klasörü
  final docs = await getApplicationDocumentsDirectory();
  final exportDir = Directory(join(docs.path, subfolder ?? appName));
  await exportDir.create(recursive: true);

  log("📂 Export klasörü: ${exportDir.path}", name: tag);

  // 📄 Dosya yolları
  final csvPath = join(exportDir.path, fileNameCsv);
  final jsonPath = join(exportDir.path, fileNameJson);
  final excelPath = join(exportDir.path, fileNameXlsx);
  final sqlPath = join(exportDir.path, fileNameSql);

  // ----------------------------------------------------------
  // 1️⃣ SQL → Liste
  // ----------------------------------------------------------
  final items = await DbHelper.instance.getRecords();
  final count = items.length;

  log("📌 Export edilecek toplam kayıt: $count", name: tag);

  // ----------------------------------------------------------
  // 2️⃣ CSV
  // ----------------------------------------------------------
  final deviceCsvPath = await DbHelper.instance.exportRecordsToCsv();
  await File(deviceCsvPath).copy(csvPath);

  // ----------------------------------------------------------
  // 3️⃣ JSON
  // ----------------------------------------------------------
  final jsonStr = exportItemsToJsonString(items);
  await File(jsonPath).writeAsString(jsonStr);

  // ----------------------------------------------------------
  // 4️⃣ XLSX — DOĞRU FONKSİYON
  // ----------------------------------------------------------
  await exportItemsToExcel(excelPath, items);

  // ----------------------------------------------------------
  // 5️⃣ SQL dosyası kopyalama
  // ----------------------------------------------------------
  final sqlOriginal = File(join(docs.path, fileNameSql));

  if (await sqlOriginal.exists()) {
    await sqlOriginal.copy(sqlPath);
    log("📦 SQL kopyalandı: $sqlPath", name: tag);
  } else {
    log("❌ SQL dosyası bulunamadı!", name: tag);
  }

  // ----------------------------------------------------------
  // 6️⃣ ZIP oluştur
  // ----------------------------------------------------------
  final zipPath = await createZipArchive(
    outputDir: exportDir.path,
    files: [csvPath, jsonPath, excelPath, sqlPath],
  );

  log("🎁 ZIP oluşturuldu: $zipPath", name: tag);

  return ExportItems(
    count: count,
    csvPath: csvPath,
    jsonPath: jsonPath,
    excelPath: excelPath,
    sqlPath: sqlPath,
    zipPath: zipPath,
  );
}

// JSON formatlama (indent)
String exportItemsToJsonString(List items) {
  final list = items.map((w) => w.toMap()).toList();
  return const JsonEncoder.withIndent('  ').convert(list);
}
