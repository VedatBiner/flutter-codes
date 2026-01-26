// 📃 <----- lib/services/export_items.dart ----->
//
// CSV → JSON → XLSX üretir.
// -----------------------------------------------------------
// • CSV: Film/dizi listesinden üretilir.
// • JSON: Film/dizi listesinden üretilir.
// • Excel: Üretilen CSV üzerinden XLSX oluşturulur.
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../constants/file_info.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_parser.dart';

class ExportItems {
  final int count;
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

/// 🔥 CSV → JSON → XLSX Pipeline
///
/// • Geçici klasör: Documents/{subfolder}
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

  // ----------------------------------------------------------
  // 1️⃣ Ana CSV'den verileri oku
  // ----------------------------------------------------------
  final parsed = await CsvParser.parseCsvFast();
  final List<NetflixItem> allMovies = parsed.movies;
  final List<SeriesGroup> allSeries = parsed.series;

  // Tüm filmleri ve dizi bölümlerini tek bir listede topla
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
  // 2️⃣ Yeni CSV oluştur
  // ----------------------------------------------------------
  final List<List<String>> csvData = [
    ['Title', 'Date'], // headers
  ];
  for (final item in allItems) {
    csvData.add([item.title, item.date]);
  }
  final String csvString = const ListToCsvConverter().convert(csvData);
  await File(csvPath).writeAsString(csvString);
  log("📄 CSV oluşturuldu: $csvPath", name: tag);

  // ----------------------------------------------------------
  // 3️⃣ JSON oluştur
  // ----------------------------------------------------------
  // final jsonStr = const JsonEncoder.withIndent(
  //   '  ',
  // ).convert(allItems.map((e) => e.toMap()).toList());
  // await File(jsonPath).writeAsString(jsonStr);
  // log("📄 JSON oluşturuldu: $jsonPath", name: tag);

  // ----------------------------------------------------------
  // 4️⃣ XLSX (Excel) oluştur
  // ----------------------------------------------------------
  final xlsio.Workbook workbook = xlsio.Workbook();
  final xlsio.Worksheet sheet = workbook.worksheets[0];

  // Başlıkları ekle
  sheet.getRangeByIndex(1, 1).setText('Title');
  sheet.getRangeByIndex(1, 2).setText('Date');

  // Verileri ekle
  for (int i = 0; i < allItems.length; i++) {
    sheet.getRangeByIndex(i + 2, 1).setText(allItems[i].title);
    sheet.getRangeByIndex(i + 2, 2).setText(allItems[i].date);
  }

  final List<int> bytes = workbook.saveAsStream();
  await File(excelPath).writeAsBytes(bytes);
  workbook.dispose();
  log("📊 Excel oluşturuldu: $excelPath", name: tag);

  log("✅ Export tamamlandı", name: tag);

  return ExportItems(
    count: count,
    csvPath: csvPath,
    jsonPath: jsonPath,
    excelPath: excelPath,
  );
}
