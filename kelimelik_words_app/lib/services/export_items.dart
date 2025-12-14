// 📃 <----- lib/utils/export_items.dart ----->
//
// SQL → CSV → JSON → XLSX → ZIP üretir.
// Bu dosya, db_helper.dart, json_helper.dart ve excel_helper.dart
// yapısına %100 uyumludur.
// -----------------------------------------------------------
// • CSV: DbHelper.exportRecordsToCsv()
// • JSON: List<Word> → JSON string
// • Excel: List<Word> → XLSX (Syncfusion)
// • SQL: DB dosyasını birebir kopyalar
// • ZIP: kelimelik_words_app klasörünün TAMAMI tek zip içinde
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../utils/fc_files/excel_helper.dart';

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

/// 🔥 SQL → CSV → JSON → XLSX → ZIP Pipeline
///
/// ZIP içine **Documents/{appName} klasörünün TAMAMI** eklenir.
/// ZIP adı: fileNameZip
Future<ExportItems> exportItemsToFileFormats({String? subfolder}) async {
  const tag = "export_items";

  // ----------------------------------------------------------
  // 📁 Documents/{appName} klasörü
  // ----------------------------------------------------------
  final docs = await getApplicationDocumentsDirectory();
  final exportDir = Directory(join(docs.path, subfolder ?? appName));
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

  // ----------------------------------------------------------
  // 2️⃣ CSV
  // ----------------------------------------------------------
  final deviceCsv = await DbHelper.instance.exportRecordsToCsv();
  await File(deviceCsv).copy(csvPath);

  // ----------------------------------------------------------
  // 3️⃣ JSON
  // ----------------------------------------------------------
  final jsonStr = const JsonEncoder.withIndent(
    '  ',
  ).convert(items.map((e) => e.toMap()).toList());
  await File(jsonPath).writeAsString(jsonStr);

  // ----------------------------------------------------------
  // 4️⃣ XLSX (FORMATLI)
  // ----------------------------------------------------------
  await exportItemsToExcel(excelPath, items);

  // ----------------------------------------------------------
  // 5️⃣ SQL kopyala
  // ----------------------------------------------------------
  final sqlOriginal = File(join(docs.path, fileNameSql));
  if (await sqlOriginal.exists()) {
    await sqlOriginal.copy(sqlPath);
  }

  // ----------------------------------------------------------
  // 6️⃣ ZIP → klasör bazlı
  // ----------------------------------------------------------
  final zipPath = join(docs.path, fileNameZip);

  final encoder = ZipFileEncoder();
  encoder.create(zipPath);

  // 🔥 ÖNEMLİ: klasörün TAMAMI zip ’e ekleniyor
  encoder.addDirectory(
    exportDir,
    includeDirName: true, // kelimelik_words_app ismi ZIP içinde görünsün
  );

  encoder.close();

  log("🎁 ZIP oluşturuldu (klasör bazlı): $zipPath", name: tag);

  return ExportItems(
    count: count,
    csvPath: csvPath,
    jsonPath: jsonPath,
    excelPath: excelPath,
    sqlPath: sqlPath,
    zipPath: zipPath,
  );
}
