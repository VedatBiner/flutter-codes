// 📃 <----- lib/utils/file_exporter.dart ----->
//
// Tam Yedek Alma Sistemi
// -----------------------------------------------------------
// Akış:
//   1️⃣ SQL → CSV export
//   2️⃣ CSV → XLSX export
//   3️⃣ SQL → JSON export
//   4️⃣ CSV / XLSX / JSON üzerine yazılır
//   5️⃣ ZIP dosyası yeniden oluşturulur
//   6️⃣ Tüm dosyalar Download/uygulama_adi içine kopyalanır
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/file_info.dart';
import '../db/db_helper.dart';
import 'zip_helper.dart';

const tag = "file_exporter";

/// Ana fonksiyon → Tüm yedekleme sürecini yönetir
Future<void> exportAllData() async {
  final sw = Stopwatch()..start();

  log("📦 Yedekleme süreci başladı…", name: tag);

  // 📌 Storage iznini iste
  await _ensureStoragePermission();

  // 📌 Belgeler dizini
  final dir = await getApplicationDocumentsDirectory();
  final csvFull = join(dir.path, fileNameCsv);
  final xlsxFull = join(dir.path, fileNameXlsx);
  final jsonFull = join(dir.path, fileNameJson);
  final sqlFull = join(dir.path, fileNameSql);
  final zipFull = join(dir.path, fileNameZip);

  // -----------------------------------------------------------
  // 1️⃣ SQL → CSV
  // -----------------------------------------------------------
  await _exportSqlToCsv(csvFull);

  // -----------------------------------------------------------
  // 2️⃣ CSV → XLSX
  // -----------------------------------------------------------
  await _exportCsvToExcel(csvFull, xlsxFull);

  // -----------------------------------------------------------
  // 3️⃣ SQL → JSON
  // -----------------------------------------------------------
  await _exportSqlToJson(jsonFull);

  // -----------------------------------------------------------
  // 4️⃣ ZIP dosyasını yeniden oluştur
  // -----------------------------------------------------------
  final zipPath = await createZipArchive();
  log("🗜 ZIP oluşturuldu: $zipPath", name: tag);

  // -----------------------------------------------------------
  // 5️⃣ Tüm dosyaları Download/x klasörüne kopyala
  // -----------------------------------------------------------
  await _copyAllBackupsToDownload([
    csvFull,
    xlsxFull,
    jsonFull,
    sqlFull,
    zipFull,
  ]);

  sw.stop();
  log("✅ Tüm yedekleme tamamlandı: ${sw.elapsedMilliseconds} ms", name: tag);
}

//
// -----------------------------------------------------------
// 🔧 SQL → CSV
// -----------------------------------------------------------
Future<void> _exportSqlToCsv(String csvFull) async {
  log("➡ SQL → CSV export başlıyor…", name: tag);

  final words = await DbHelper.instance.getRecords();
  final buffer = StringBuffer();

  buffer.writeln("Word,Meaning");

  for (final w in words) {
    final safeMeaning = w.meaning.replaceAll(",", ";");
    buffer.writeln("${w.word},$safeMeaning");
  }

  await File(csvFull).writeAsString(buffer.toString());
  log("✔ CSV oluşturuldu: $csvFull", name: tag);
}

//
// -----------------------------------------------------------
// 🔧 SQL → JSON
// -----------------------------------------------------------
Future<void> _exportSqlToJson(String jsonFull) async {
  log("➡ SQL → JSON export başlıyor…", name: tag);

  final words = await DbHelper.instance.getRecords();

  final list = words
      .map((w) => {"Word": w.word, "Meaning": w.meaning})
      .toList();

  final jsonStr = const JsonEncoder.withIndent("  ").convert(list);
  await File(jsonFull).writeAsString(jsonStr);

  log("✔ JSON oluşturuldu: $jsonFull", name: tag);
}

//
// -----------------------------------------------------------
// 🔧 CSV → XLSX (Syncfusion veya Excel paketi ile)
// -----------------------------------------------------------
Future<void> _exportCsvToExcel(String csvFull, String xlsxFull) async {
  log("➡ CSV → XLSX export başlıyor…", name: tag);

  final csv = await File(csvFull).readAsString();
  final lines = csv.split("\n").where((e) => e.trim().isNotEmpty).toList();

  // Excel paketi ile basit XLSX oluşturma
  final rows = lines.map((e) => e.split(",")).toList();

  // excel paketi kullanılıyor:
  final excel = Excel.createExcel();
  final sheet = excel['Sheet1'];

  for (int r = 0; r < rows.length; r++) {
    for (int c = 0; c < rows[r].length; c++) {
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r))
              .value =
          rows[r][c];
    }
  }

  final excelBytes = excel.encode();
  if (excelBytes != null) {
    await File(xlsxFull).writeAsBytes(excelBytes);
    log("✔ XLSX oluşturuldu: $xlsxFull", name: tag);
  }
}

//
// -----------------------------------------------------------
// 🔧 Tüm yedek dosyalarını Download klasörüne kopyalama
// -----------------------------------------------------------
Future<void> _copyAllBackupsToDownload(List<String> filePaths) async {
  final downloads = Directory("/storage/emulated/0/Download/$appName");

  if (!await downloads.exists()) {
    await downloads.create(recursive: true);
    log("📁 Download klasörü oluşturuldu: ${downloads.path}", name: tag);
  }

  for (final srcPath in filePaths) {
    final file = File(srcPath);
    if (await file.exists()) {
      final newPath = join(downloads.path, basename(srcPath));
      await file.copy(newPath);
      log("📤 Kopyalandı → $newPath", name: tag);
    } else {
      log("⚠️ Kopyalanamadı, dosya yok: $srcPath", name: tag);
    }
  }
}

//
// -----------------------------------------------------------
// 🔧 Depolama izni
// -----------------------------------------------------------
Future<void> _ensureStoragePermission() async {
  if (await Permission.storage.isGranted) return;

  final status = await Permission.storage.request();
  if (!status.isGranted) {
    log("❌ Storage izni verilmedi!", name: tag);
  }
}
