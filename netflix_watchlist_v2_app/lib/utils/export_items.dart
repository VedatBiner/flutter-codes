// 📃 <----- lib/services/export_items.dart ----->
//
// CSV → JSON → XLSX üretir.
// • Dosyalar önce Documents/{subfolder} içine yazılır (geçici).
// • Ardından Download/{appName} içine kopyalanır (kalıcı / paylaşılabilir).
//
// Not:
// ✅ CSV/JSON içinde Date formatı: dd/MM/yyyy
// ✅ XLSX: DateTime hücresi + dd/MM/yyyy numberFormat (excel_helper)
//
//

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_parser.dart';
import '../utils/storage_permission_helper.dart';
import '../utils/excel_helper.dart';

class ExportItems {
  final int count;

  /// ✅ Download içindeki kesin path ’ler (share için bunları kullanacağız)
  final String csvPath;
  final String jsonPath;
  final String excelPath;

  ExportItems({
    required this.count,
    required this.csvPath,
    required this.jsonPath,
    required this.excelPath,
  });
}

/// MM/DD/YY (Netflix) → dd/MM/yyyy
/// Bozuk gelirse orijinali döndürür.
String _toDdMmYyyy(String rawNetflixDate) {
  try {
    final dt = parseDate(rawNetflixDate); // utils/csv_parser.dart
    return formatDate(dt); // dd/MM/yyyy
  } catch (_) {
    return rawNetflixDate;
  }
}

Future<ExportItems> exportItemsToFileFormats({
  required String subfolder,
}) async {
  const tag = "export_items";

  // ----------------------------------------------------------
  // 0) Geçici export dizini (Documents/{subfolder})
  // ----------------------------------------------------------
  final docs = await getApplicationDocumentsDirectory();
  final tempDir = Directory(join(docs.path, subfolder));
  await tempDir.create(recursive: true);
  log("📂 Temp export klasörü: ${tempDir.path}", name: tag);

  final tempCsvPath = join(tempDir.path, fileNameCsv);
  final tempJsonPath = join(tempDir.path, fileNameJson);
  final tempExcelPath = join(tempDir.path, fileNameXlsx);

  try {
    // ----------------------------------------------------------
    // 1) CSV’den verileri oku (compute ile)
    // ----------------------------------------------------------
    final parsed = await CsvParser.parseCsvFast();
    final List<NetflixItem> allMovies = parsed.movies;
    final List<SeriesGroup> allSeries = parsed.series;

    final allItems = <NetflixItem>[];
    allItems.addAll(allMovies);

    for (final seriesGroup in allSeries) {
      for (final season in seriesGroup.seasons) {
        for (final episode in season.episodes) {
          allItems.add(NetflixItem(title: episode.title, date: episode.date));
        }
      }
    }

    final count = allItems.length;
    log("📌 Export edilecek kayıt: $count", name: tag);

    // ----------------------------------------------------------
    // 2) CSV oluştur (TEMP)  -> Date: dd/MM/yyyy
    // ----------------------------------------------------------
    final List<List<String>> csvData = [
      ['Title', 'Date'],
    ];

    for (final item in allItems) {
      final formattedDate = _toDdMmYyyy(item.date);
      csvData.add([item.title, formattedDate]);
    }

    final csvString = csv.encode(csvData);
    await File(tempCsvPath).writeAsString(csvString);
    log("📄 TEMP CSV (dd/MM/yyyy): $tempCsvPath", name: tag);

    // ----------------------------------------------------------
    // 3) JSON oluştur (TEMP) -> Date: dd/MM/yyyy
    // ----------------------------------------------------------
    final jsonList = allItems
        .map((e) => {'title': e.title, 'date': _toDdMmYyyy(e.date)})
        .toList();

    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);
    await File(tempJsonPath).writeAsString(jsonStr);
    log("📄 TEMP JSON (dd/MM/yyyy): $tempJsonPath", name: tag);

    // ----------------------------------------------------------
    // 4) XLSX oluştur (TEMP) - STİLLİ + GERÇEK TARİH
    //    (Excel hücreleri DateTime, görüntü dd/MM/yyyy)
    //
    // NOT: Excel helper item.date'i MM/DD/YY olarak parse ediyor.
    // Bu yüzden allItems'i MUTATE ETMİYORUZ.
    // ----------------------------------------------------------
    await createStyledExcelFromItemsSyncfusion(
      items: allItems,
      outputPath: tempExcelPath,
    );
    log("📊 TEMP XLSX (stilli): $tempExcelPath", name: tag);

    // ----------------------------------------------------------
    // 5) Download/{appName} içine kopyala (izin kontrolü dahil)
    // ----------------------------------------------------------
    final ok = await ensureStoragePermission();
    if (!ok) {
      throw Exception(
        "Depolama izni verilmedi (Download kopyalama yapılamadı).",
      );
    }

    final downloadDir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );
    final downloadAppDir = Directory(join(downloadDir, appName));
    await downloadAppDir.create(recursive: true);

    final outCsvPath = join(downloadAppDir.path, fileNameCsv);
    final outJsonPath = join(downloadAppDir.path, fileNameJson);
    final outExcelPath = join(downloadAppDir.path, fileNameXlsx);

    await File(tempCsvPath).copy(outCsvPath);
    await File(tempJsonPath).copy(outJsonPath);
    await File(tempExcelPath).copy(outExcelPath);

    log("📥 Download kopyaları hazır:", name: tag);
    log("✅ CSV: $outCsvPath", name: tag);
    log("✅ JSON: $outJsonPath", name: tag);
    log("✅ XLSX: $outExcelPath", name: tag);
    log("✅ Export tamamlandı", name: tag);

    return ExportItems(
      count: count,
      csvPath: outCsvPath,
      jsonPath: outJsonPath,
      excelPath: outExcelPath,
    );
  } finally {
    // ----------------------------------------------------------
    // 🧹 Temp klasörü temizle
    // ----------------------------------------------------------
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
      log("🧹 Temp export klasörü silindi: ${tempDir.path}", name: tag);
    }
  }
}