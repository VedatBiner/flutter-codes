// 📃 <----- lib/utils/file_exporter.dart ----->
//
// SQL → CSV → XLSX → JSON → ZIP
// Tüm yedek dosyalarını üretir ve döner.
// UI bu dosyayı DOĞRUDAN kullanmaz → export_items.dart kullanır.
//

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../constants/file_info.dart';
import '../db/db_helper.dart';
import 'fc_files/zip_helper.dart';

/// 📌 Tüm export işlemlerini çalıştırır.
/// Geriye: Map<String,String> döner → dosya yolları.
Future<Map<String, String>> runFullExport({String? subfolder}) async {
  const tag = "file_exporter";

  // Uygulama Documents dizini
  final directory = await getApplicationDocumentsDirectory();
  final basePath = directory.path;

  // Tek noktadan tüm dosya yolları:
  final jsonFull = join(basePath, fileNameJson);
  final csvFull = join(basePath, fileNameCsv);
  final xlsxFull = join(basePath, fileNameXlsx);
  final sqlFull = join(basePath, fileNameSql);

  log("📦 Export başladı...", name: tag);

  // ============================================================
  // 1️⃣ SQL → CSV
  // ============================================================

  final rows = await DbHelper.instance.getRawRecords(); // Word,Meaning listesi
  final csvBuffer = StringBuffer("Word,Meaning\n");

  for (final r in rows) {
    csvBuffer.writeln("${r.word},${r.meaning}");
  }

  await File(csvFull).writeAsString(csvBuffer.toString());
  log("✅ CSV oluşturuldu: $csvFull", name: tag);

  // ============================================================
  // 2️⃣ CSV → XLSX
  // ============================================================

  final workbook = xlsio.Workbook();
  final sheet = workbook.worksheets[0];

  // Başlık
  sheet.getRangeByIndex(1, 1).setText("Word");
  sheet.getRangeByIndex(1, 2).setText("Meaning");

  // Satırlar
  for (int i = 0; i < rows.length; i++) {
    sheet.getRangeByIndex(i + 2, 1).setText(rows[i].word);
    sheet.getRangeByIndex(i + 2, 2).setText(rows[i].meaning);
  }

  final bytes = workbook.saveAsStream();
  workbook.dispose();
  await File(xlsxFull).writeAsBytes(bytes);
  log("✅ XLSX oluşturuldu: $xlsxFull", name: tag);

  // ============================================================
  // 3️⃣ CSV → JSON
  // ============================================================

  final jsonList = rows
      .map((r) => {"Word": r.word, "Meaning": r.meaning})
      .toList();

  final jsonString = const JsonEncoder.withIndent("  ").convert(jsonList);
  await File(jsonFull).writeAsString(jsonString);
  log("✅ JSON oluşturuldu: $jsonFull", name: tag);

  // ============================================================
  // 4️⃣ ZIP → tümünü sıkıştır
  // ============================================================

  final zipPath = await createZipArchive();
  log("📦 ZIP oluşturuldu: $zipPath", name: tag);

  // ============================================================
  // 5️⃣ Download klasörüne kopyala (subfolder)
  // ============================================================

  final downloads = Directory(
    "/storage/emulated/0/Download/${subfolder ?? appName}",
  );

  if (!await downloads.exists()) {
    await downloads.create(recursive: true);
  }

  Future<String> copy(String srcPath) async {
    final filename = basename(srcPath);
    final dst = join(downloads.path, filename);
    await File(srcPath).copy(dst);
    return dst;
  }

  final map = {
    fileNameJson: await copy(jsonFull),
    fileNameCsv: await copy(csvFull),
    fileNameXlsx: await copy(xlsxFull),
    fileNameSql: await copy(sqlFull),
    fileNameZip: await copy(zipPath),
    "count": rows.length.toString(),
  };

  log("📁 Dosyalar download klasörüne kopyalandı.", name: tag);

  return map;
}
