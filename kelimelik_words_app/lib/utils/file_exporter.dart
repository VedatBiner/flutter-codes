// 📃 <----- lib/utils/file_exporter.dart ----->
//
// SQL → CSV / JSON / XLSX → ZIP → Download kopyalama
// Tüm dosyalar EN GÜNCEL SQL verisinden yeniden üretilir.
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

const _tag = "file_exporter";

/// Full export işlemini tetikler:
/// 1) En güncel SQL → rows
/// 2) CSV üret
/// 3) JSON üret
/// 4) XLSX üret
/// 5) ZIP üret
/// 6) Download klasörüne kopyala
Future<Map<String, String>> runFullExport({String? subfolder}) async {
  log("🚀 Full Export başladı...", name: _tag);

  final dir = await getApplicationDocumentsDirectory();
  final basePath = dir.path;

  final csvFull = join(basePath, fileNameCsv);
  final jsonFull = join(basePath, fileNameJson);
  final xlsxFull = join(basePath, fileNameXlsx);
  final sqlFull = join(basePath, fileNameSql);

  // -----------------------------
  // 1️⃣ EN GÜNCEL SQL verisini çek
  // -----------------------------
  final rows = await DbHelper.instance.getRecords();
  log("📦 SQL 'den okunan kayıt sayısı: ${rows.length}", name: _tag);

  // -----------------------------
  // 2️⃣ CSV üret (SIFIRDAN)
  // -----------------------------
  final csvBuffer = StringBuffer("Word,Meaning\n");
  for (final r in rows) {
    csvBuffer.writeln("${r.word},${r.meaning}");
  }
  await File(csvFull).writeAsString(csvBuffer.toString());
  log("✅ CSV oluşturuldu → $csvFull", name: _tag);

  // -----------------------------
  // 3️⃣ JSON üret (SIFIRDAN)
  // -----------------------------
  final jsonList = rows
      .map((r) => {"Word": r.word, "Meaning": r.meaning})
      .toList();

  await File(
    jsonFull,
  ).writeAsString(const JsonEncoder.withIndent("  ").convert(jsonList));
  log("✅ JSON oluşturuldu → $jsonFull", name: _tag);

  // -----------------------------
  // 4️⃣ XLSX üret (SIFIRDAN)
  // -----------------------------
  final workbook = xlsio.Workbook();
  final sheet = workbook.worksheets[0];

  sheet.getRangeByIndex(1, 1).setText("Word");
  sheet.getRangeByIndex(1, 2).setText("Meaning");

  for (int i = 0; i < rows.length; i++) {
    sheet.getRangeByIndex(i + 2, 1).setText(rows[i].word);
    sheet.getRangeByIndex(i + 2, 2).setText(rows[i].meaning);
  }

  final excelBytes = workbook.saveAsStream();
  workbook.dispose();
  await File(xlsxFull).writeAsBytes(excelBytes);
  log("✅ XLSX oluşturuldu → $xlsxFull", name: _tag);

  // -----------------------------
  // 5️⃣ ZIP üret (EN GÜNCEL DOSYALARLA)
  // -----------------------------
  final zipFull = await createZipArchive(
    files: [csvFull, jsonFull, xlsxFull, sqlFull],
  );
  log("📦 ZIP oluşturuldu → $zipFull", name: _tag);

  // -----------------------------
  // 6️⃣ Download dizinine kopyala
  // -----------------------------
  final result = await _copyToDownloadFolder(
    subfolder,
    csv: csvFull,
    json: jsonFull,
    xlsx: xlsxFull,
    sql: sqlFull,
    zip: zipFull,
  );

  log("🎉 Full Export tamamlandı.", name: _tag);
  log("📁 Download klasörüne kopyalanan dosyalar:", name: _tag);
  result.forEach((key, value) => log("$key → $value", name: _tag));

  return result;
}

/// Download klasörüne güvenli kopyalama
Future<Map<String, String>> _copyToDownloadFolder(
  String? subfolder, {
  required String csv,
  required String json,
  required String xlsx,
  required String sql,
  required String zip,
}) async {
  final folder = Directory(
    "/storage/emulated/0/Download/${subfolder ?? appName}",
  );

  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }

  Future<String> cp(String src) async {
    final dst = join(folder.path, basename(src));
    await File(src).copy(dst);
    return dst;
  }

  return {
    fileNameCsv: await cp(csv),
    fileNameJson: await cp(json),
    fileNameXlsx: await cp(xlsx),
    fileNameSql: await cp(sql),
    fileNameZip: await cp(zip),
    "count": (await DbHelper.instance.countRecords()).toString(),
  };
}
