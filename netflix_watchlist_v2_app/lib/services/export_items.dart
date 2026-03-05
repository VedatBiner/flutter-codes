// 📃 <----- lib/services/export_items_service.dart ----->
//
// ============================================================================
// 📦 ExportItemsService – Veri Dışa Aktarma Servisi (Modüler / Enterprise)
// ============================================================================
//
// Bu servis, uygulamadaki film ve dizi verilerini üç farklı dosya formatına
// dönüştürür:
//
//   • CSV
//   • JSON
//   • XLSX (Excel)
//
// ---------------------------------------------------------------------------
// 🧠 Mimari Tasarım
// ---------------------------------------------------------------------------
// Önceki tek fonksiyonlu yapı yerine bu sürümde işlevler küçük parçalara
// bölünmüştür:
//
//   exportItemsToFileFormats()
//       │
//       ├── _collectAllItems()   → film + dizi bölümlerini tek liste yapar
//       ├── _exportCsv()         → CSV üretir
//       ├── _exportJson()        → JSON üretir
//       ├── _exportExcel()       → Excel üretir
//       ├── _copyToDownload()    → Download klasörüne kopyalar
//       └── _cleanupTemp()       → geçici klasörü siler
//
// Bu yaklaşımın avantajları:
//
// 1️⃣ Kod okunabilirliği artar
// 2️⃣ Test edilebilirlik artar
// 3️⃣ Hata yönetimi kolaylaşır
// 4️⃣ Gelecekte yeni format eklemek kolay olur
//
// ---------------------------------------------------------------------------
// 📌 Export Akışı
// ---------------------------------------------------------------------------
//
// 1️⃣ CSV parser ile asset verisi okunur
// 2️⃣ Dizi bölümleri tek listeye çevrilir
// 3️⃣ Geçici klasörde dosyalar oluşturulur
// 4️⃣ Storage izni kontrol edilir
// 5️⃣ Download/{appName} klasörüne kopyalanır
// 6️⃣ Temp klasör temizlenir
//
// ============================================================================

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../constants/file_info.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_parser.dart';
import '../utils/storage_permission_helper.dart';


// ============================================================================
// 📦 ExportItems Result Model
// ============================================================================
//
// Export işlemi tamamlandıktan sonra UI katmanına döndürülen veri modelidir.
//
// İçerdiği bilgiler:
//
//   • count      → export edilen toplam kayıt sayısı
//   • csvPath    → Download klasöründeki CSV dosyasının yolu
//   • jsonPath   → Download klasöründeki JSON dosyasının yolu
//   • excelPath  → Download klasöründeki XLSX dosyasının yolu
//
// Bu bilgiler:
//
//   • bildirim gösterme
//   • paylaşma
//   • dosya açma
//
// işlemleri için kullanılır.
//
// ============================================================================
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


// ============================================================================
// 🚀 exportItemsToFileFormats()
// ============================================================================
//
// Servisin ana giriş noktasıdır.
//
// Parametre:
//   subfolder → geçici export klasörünün adı
//
// Örnek:
//   Documents/netflix_export/
//
// ============================================================================
Future<ExportItems> exportItemsToFileFormats({
  required String subfolder,
}) async {
  const tag = "export_items_service";

  final docs = await getApplicationDocumentsDirectory();
  final tempDir = Directory(join(docs.path, subfolder));

  await tempDir.create(recursive: true);

  log("📂 Temp klasör: ${tempDir.path}", name: tag);

  final tempCsvPath = join(tempDir.path, fileNameCsv);
  final tempJsonPath = join(tempDir.path, fileNameJson);
  final tempExcelPath = join(tempDir.path, fileNameXlsx);

  try {

    // ------------------------------------------------------------------------
    // 1️⃣ Asset verisini oku
    // ------------------------------------------------------------------------
    final parsed = await CsvParser.parseCsvFast();

    final items = _collectAllItems(parsed.movies, parsed.series);

    final count = items.length;

    log("📊 Export kayıt sayısı: $count", name: tag);

    // ------------------------------------------------------------------------
    // 2️⃣ Dosyaları üret
    // ------------------------------------------------------------------------
    await _exportCsv(items, tempCsvPath);
    await _exportJson(items, tempJsonPath);
    await _exportExcel(items, tempExcelPath);

    // ------------------------------------------------------------------------
    // 3️⃣ Download klasörüne kopyala
    // ------------------------------------------------------------------------
    final paths = await _copyToDownload(
      tempCsvPath,
      tempJsonPath,
      tempExcelPath,
    );

    return ExportItems(
      count: count,
      csvPath: paths[0],
      jsonPath: paths[1],
      excelPath: paths[2],
    );

  } finally {

    // ------------------------------------------------------------------------
    // 🧹 Geçici klasörü temizle
    // ------------------------------------------------------------------------
    await _cleanupTemp(tempDir, tag);
  }
}


// ============================================================================
// 📥 _collectAllItems()
// ============================================================================
//
// Film listesi ve dizi bölümlerini tek bir listeye dönüştürür.
//
// Dizi yapısı:
//
//   SeriesGroup
//      └─ Season
//            └─ Episode
//
// Export sırasında her bölüm tek bir kayıt olarak alınır.
//
// ============================================================================
List<NetflixItem> _collectAllItems(
    List<NetflixItem> movies,
    List<SeriesGroup> series,
    ) {

  final items = <NetflixItem>[];

  items.addAll(movies);

  for (final s in series) {
    for (final season in s.seasons) {
      for (final ep in season.episodes) {
        items.add(
          NetflixItem(
            title: ep.title,
            date: ep.date,
          ),
        );
      }
    }
  }

  return items;
}


// ============================================================================
// 📄 _exportCsv()
// ============================================================================
//
// NetflixItem listesini CSV formatına dönüştürür.
//
// CSV format:
//
//   Title,Date
//   Film 1,2024-01-01
//
// ============================================================================
Future<void> _exportCsv(
    List<NetflixItem> items,
    String path,
    ) async {

  final data = <List<String>>[
    ['Title', 'Date'],
  ];

  data.addAll(items.map((e) => [e.title, e.date]));

  final csv = const ListToCsvConverter().convert(data);

  await File(path).writeAsString(csv);
}


// ============================================================================
// 📄 _exportJson()
// ============================================================================
//
// Listeyi JSON array formatına dönüştürür.
//
// Örnek:
//
// [
//   { "title": "...", "date": "..." }
// ]
//
// ============================================================================
Future<void> _exportJson(
    List<NetflixItem> items,
    String path,
    ) async {

  final jsonList = items
      .map((e) => {
    "title": e.title,
    "date": e.date,
  })
      .toList();

  final jsonStr =
  const JsonEncoder.withIndent('  ').convert(jsonList);

  await File(path).writeAsString(jsonStr);
}


// ============================================================================
// 📊 _exportExcel()
// ============================================================================
//
// Syncfusion kütüphanesi kullanılarak XLSX dosyası oluşturulur.
//
// Excel yapısı:
//
//   A1: Title
//   B1: Date
//
// ============================================================================
Future<void> _exportExcel(
    List<NetflixItem> items,
    String path,
    ) async {

  final workbook = xlsio.Workbook();

  try {

    final sheet = workbook.worksheets[0];

    sheet.getRangeByIndex(1, 1).setText('Title');
    sheet.getRangeByIndex(1, 2).setText('Date');

    for (int i = 0; i < items.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText(items[i].title);
      sheet.getRangeByIndex(i + 2, 2).setText(items[i].date);
    }

    final bytes = workbook.saveAsStream();

    await File(path).writeAsBytes(bytes);

  } finally {

    workbook.dispose();
  }
}


// ============================================================================
// 📥 _copyToDownload()
// ============================================================================
//
// TEMP klasörde oluşturulan dosyaları Download/{appName} klasörüne kopyalar.
//
// Bu sayede:
//
// • kullanıcı dosyaları File Manager ile görebilir
// • share işlemleri kolay olur
//
// ============================================================================
Future<List<String>> _copyToDownload(
    String tempCsv,
    String tempJson,
    String tempExcel,
    ) async {

  final ok = await ensureStoragePermission();

  if (!ok) {
    throw Exception("Storage izni verilmedi.");
  }

  final downloadDir =
  await ExternalPath.getExternalStoragePublicDirectory(
    ExternalPath.DIRECTORY_DOWNLOAD,
  );

  final appDir = Directory(join(downloadDir, appName));

  await appDir.create(recursive: true);

  final csvOut = join(appDir.path, fileNameCsv);
  final jsonOut = join(appDir.path, fileNameJson);
  final excelOut = join(appDir.path, fileNameXlsx);

  await File(tempCsv).copy(csvOut);
  await File(tempJson).copy(jsonOut);
  await File(tempExcel).copy(excelOut);

  return [csvOut, jsonOut, excelOut];
}


// ============================================================================
// 🧹 _cleanupTemp()
// ============================================================================
//
// Export bittikten sonra geçici klasörü siler.
//
// ============================================================================
Future<void> _cleanupTemp(
    Directory dir,
    String tag,
    ) async {

  if (await dir.exists()) {
    await dir.delete(recursive: true);
    log("🧹 Temp klasör silindi: ${dir.path}", name: tag);
  }
}