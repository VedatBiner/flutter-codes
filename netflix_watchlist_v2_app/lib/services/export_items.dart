// 📃 <----- lib/services/export_items.dart ----->
//
// ============================================================================
// 📦 ExportItems Service – Veri Dışa Aktarma Servisi
// ============================================================================
//
// Bu servis, uygulamadaki film ve dizi verilerini üç farklı dosya formatına
// dönüştürerek cihazın Download klasörüne kaydeder.
//
// Desteklenen formatlar:
//   • CSV
//   • JSON
//   • XLSX (Excel)
//
// ---------------------------------------------------------------------------
// 📌 Genel Çalışma Akışı
// ---------------------------------------------------------------------------
//
// 1️⃣ Asset içindeki CSV verisi okunur.
// 2️⃣ Film ve dizi bölümleri tek bir listeye dönüştürülür.
// 3️⃣ Bu liste:
//
//      → CSV dosyasına
//      → JSON dosyasına
//      → XLSX (Excel) dosyasına
//
//    dönüştürülür.
//
// 4️⃣ Dosyalar önce geçici olarak:
//
//      Documents/{subfolder}
//
//    klasörüne yazılır.
//
// 5️⃣ Daha sonra kullanıcı erişimi için:
//
//      Download/{appName}
//
//    klasörüne kopyalanır.
//
// 6️⃣ Son olarak geçici klasör temizlenir.
//
// ---------------------------------------------------------------------------
// 📌 Neden geçici klasör kullanıyoruz?
// ---------------------------------------------------------------------------
//
// Çünkü:
//
// • Documents dizini uygulama tarafından güvenli yazma alanıdır.
// • Download dizini için ek izin gerekir.
// • Önce güvenli ortamda üretip sonra kopyalamak daha stabil çalışır.
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
// 📦 ExportItems Model
// ============================================================================
//
// Bu model export işleminin sonucunu temsil eder.
//
// İçerdiği bilgiler:
//
//   • count      → kaç kayıt export edildi
//   • csvPath    → Download içindeki CSV dosyası
//   • jsonPath   → Download içindeki JSON dosyası
//   • excelPath  → Download içindeki XLSX dosyası
//
// Bu path 'ler özellikle:
//
//   • paylaşım (share)
//   • bildirim
//   • dosya açma
//
// işlemleri için kullanılır.
//
// ============================================================================
class ExportItems {
  final int count;

  /// Download içindeki kesin dosya yolları
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
// Uygulamadaki tüm film ve dizi verilerini:
//
//   • CSV
//   • JSON
//   • XLSX
//
// formatlarında export eder.
//
// Parametre:
//
//   subfolder → Documents dizini altında kullanılacak geçici klasör adı
//
// Örnek:
//   Documents/netflix_exports/
//
// ============================================================================
Future<ExportItems> exportItemsToFileFormats({
  required String subfolder,
}) async {
  const tag = "export_items";

  // --------------------------------------------------------------------------
  // 0️⃣ Geçici export dizini oluştur
  // --------------------------------------------------------------------------
  //
  // Documents klasörü uygulamanın güvenli yazma alanıdır.
  // Burada geçici dosyalar oluşturulur.
  //
  final docs = await getApplicationDocumentsDirectory();

  final tempDir = Directory(join(docs.path, subfolder));
  await tempDir.create(recursive: true);

  log("📂 Temp export klasörü: ${tempDir.path}", name: tag);

  final tempCsvPath = join(tempDir.path, fileNameCsv);
  final tempJsonPath = join(tempDir.path, fileNameJson);
  final tempExcelPath = join(tempDir.path, fileNameXlsx);


  try {

    // ------------------------------------------------------------------------
    // 1️⃣ Asset CSV verisini oku
    // ------------------------------------------------------------------------
    //
    // CsvParser.parseCsvFast()
    // compute() kullanarak CSV parsing işlemini ayrı isolate içinde yapar.
    //
    final parsed = await CsvParser.parseCsvFast();

    final List<NetflixItem> allMovies = parsed.movies;
    final List<SeriesGroup> allSeries = parsed.series;


    // ------------------------------------------------------------------------
    // 2️⃣ Dizi bölümlerini film listesine ekle
    // ------------------------------------------------------------------------
    //
    // Diziler sezon/bölüm yapısında tutulur.
    // Export sırasında tüm kayıtları tek listeye çeviriyoruz.
    //
    final allItems = <NetflixItem>[];

    allItems.addAll(allMovies);

    for (final seriesGroup in allSeries) {
      for (final season in seriesGroup.seasons) {
        for (final episode in season.episodes) {
          allItems.add(
            NetflixItem(
              title: episode.title,
              date: episode.date,
            ),
          );
        }
      }
    }

    final count = allItems.length;

    log("📌 Export edilecek kayıt: $count", name: tag);


    // ------------------------------------------------------------------------
    // 3️⃣ CSV dosyası oluştur
    // ------------------------------------------------------------------------
    final List<List<String>> csvData = [
      ['Title', 'Date'],
    ];

    for (final item in allItems) {
      csvData.add([item.title, item.date]);
    }

    final csvString = const ListToCsvConverter().convert(csvData);

    await File(tempCsvPath).writeAsString(csvString);

    log("📄 TEMP CSV: $tempCsvPath", name: tag);


    // ------------------------------------------------------------------------
    // 4️⃣ JSON dosyası oluştur
    // ------------------------------------------------------------------------
    final jsonList = allItems
        .map((e) => {
      'title': e.title,
      'date': e.date,
    })
        .toList();

    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);

    await File(tempJsonPath).writeAsString(jsonStr);

    log("📄 TEMP JSON: $tempJsonPath", name: tag);


    // ------------------------------------------------------------------------
    // 5️⃣ XLSX (Excel) dosyası oluştur
    // ------------------------------------------------------------------------
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    sheet.getRangeByIndex(1, 1).setText('Title');
    sheet.getRangeByIndex(1, 2).setText('Date');

    for (int i = 0; i < allItems.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText(allItems[i].title);
      sheet.getRangeByIndex(i + 2, 2).setText(allItems[i].date);
    }

    final bytes = workbook.saveAsStream();

    await File(tempExcelPath).writeAsBytes(bytes);

    workbook.dispose();

    log("📊 TEMP XLSX: $tempExcelPath", name: tag);


    // ------------------------------------------------------------------------
    // 6️⃣ Storage izni kontrolü
    // ------------------------------------------------------------------------
    final ok = await ensureStoragePermission();

    if (!ok) {
      throw Exception(
        "Depolama izni verilmedi (Download kopyalama yapılamadı).",
      );
    }


    // ------------------------------------------------------------------------
    // 7️⃣ Download klasörünü bul
    // ------------------------------------------------------------------------
    final downloadDir =
    await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );

    final downloadAppDir = Directory(join(downloadDir, appName));

    await downloadAppDir.create(recursive: true);


    final outCsvPath = join(downloadAppDir.path, fileNameCsv);
    final outJsonPath = join(downloadAppDir.path, fileNameJson);
    final outExcelPath = join(downloadAppDir.path, fileNameXlsx);


    // ------------------------------------------------------------------------
    // 8️⃣ Dosyaları Download klasörüne kopyala
    // ------------------------------------------------------------------------
    await File(tempCsvPath).copy(outCsvPath);
    await File(tempJsonPath).copy(outJsonPath);
    await File(tempExcelPath).copy(outExcelPath);

    log("📥 Download kopyaları hazır:", name: tag);
    log("✅ CSV: $outCsvPath", name: tag);
    log("✅ JSON: $outJsonPath", name: tag);
    log("✅ XLSX: $outExcelPath", name: tag);
    log("✅ Export tamamlandı", name: tag);


    // ------------------------------------------------------------------------
    // 9️⃣ Sonuç nesnesini döndür
    // ------------------------------------------------------------------------
    return ExportItems(
      count: count,
      csvPath: outCsvPath,
      jsonPath: outJsonPath,
      excelPath: outExcelPath,
    );


  } finally {

    // ------------------------------------------------------------------------
    // 🧹 Temp klasörü temizle
    // ------------------------------------------------------------------------
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
      log("🧹 Temp export klasörü silindi: ${tempDir.path}", name: tag);
    }
  }
}