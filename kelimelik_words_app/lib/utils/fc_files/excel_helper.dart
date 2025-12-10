// 📃 <----- lib/utils/fc_files/excel_helper.dart ----->
//
// Excel oluşturma işlemi (Kelime – Anlam)
// -----------------------------------------------------------
// • Bu sürümde Excel dosyası HER ZAMAN yeniden oluşturulur.
// • CSV ile tamamen uyumludur (2 sütun: Kelime / Anlam)
// • export_items.dart ve file_exporter.dart ile %100 uyumludur.
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../../constants/file_info.dart';

/// ---------------------------------------------------------------------------
/// 📌 CSV’den Excel oluşturur (Kelime – Anlam)
/// ---------------------------------------------------------------------------
Future<void> createExcelFromAssetCsvSyncfusion() async {
  const tag = 'excel_helper';

  try {
    final directory = await getApplicationDocumentsDirectory();
    final excelPath = join(directory.path, fileNameXlsx);

    // 🔄 Eski Excel dosyasını sil
    final file = File(excelPath);
    if (await file.exists()) {
      await file.delete();
    }

    // 📥 CSV dosyasını oku
    final csvPath = join(directory.path, fileNameCsv);
    final csvFile = File(csvPath);

    if (!await csvFile.exists()) {
      log('❌ CSV bulunamadı, Excel üretilemedi.', name: tag);
      return;
    }

    final csvRaw = await csvFile.readAsString();
    final rows = csvRaw.split('\n').where((e) => e.trim().isNotEmpty).toList();

    if (rows.isEmpty) {
      log('⚠️ CSV boş, Excel oluşturulmadı.', name: tag);
      return;
    }

    // 📝 Excel oluştur
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    // 🔵 Başlık satırı
    final headers = ['Kelime', 'Anlam'];
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(1, i + 1);
      cell.setText(headers[i]);
      final style = cell.cellStyle;

      style.bold = true;
      style.backColorRgb = const Color.fromARGB(255, 13, 71, 161);
      style.fontColorRgb = const Color.fromARGB(255, 255, 255, 255);
      style.hAlign = xlsio.HAlignType.center;
      style.vAlign = xlsio.VAlignType.center;
      style.borders.all.lineStyle = xlsio.LineStyle.thin;
    }

    // Freeze Panes – başlık sabit kalsın
    sheet.getRangeByIndex(2, 1).freezePanes();

    // 📊 Veri satırları
    int rowIndex = 2;

    for (int i = 1; i < rows.length; i++) {
      final cells = rows[i].split(',');

      // Kelime
      if (cells.isNotEmpty) {
        sheet.getRangeByIndex(rowIndex, 1).setText(cells[0].trim());
      }

      // Anlam
      if (cells.length > 1) {
        sheet.getRangeByIndex(rowIndex, 2).setText(cells[1].trim());
      }

      // 🎨 ZEBRA RENK — Çift satırlar pastel açık mavi
      if (rowIndex % 2 == 0) {
        final rng = sheet.getRangeByIndex(rowIndex, 1, rowIndex, 2);
        rng.cellStyle.backColorRgb = const Color.fromARGB(
          255,
          220,
          235,
          255,
        ); // pastel açık mavi
      }

      rowIndex++;
    }

    // 📏 Sütun genişlikleri — ARTIK AUTO-FIT ile otomatik!
    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);

    // 💾 Kaydet
    final bytes = workbook.saveAsStream();
    workbook.dispose();

    await File(excelPath).writeAsBytes(bytes);

    log(
      '📘 Excel yeniden oluşturuldu. Kayıt sayısı: ${rows.length - 1}',
      name: tag,
    );
  } catch (e, st) {
    log('❌ Excel oluşturma hatası: $e', name: tag, error: e, stackTrace: st);
  }
}

/// ---------------------------------------------------------------------------
/// 📌 GENERIC Excel oluşturucu (her model için çalışır)
///    export_items.dart tarafından çağrılır.
/// ---------------------------------------------------------------------------
Future<void> exportItemsToExcelFromList(
  String excelPath,
  List<dynamic> items, {
  required String column1Header,
  required String column2Header,
  required String Function(dynamic) getColumn1Value,
  required String Function(dynamic) getColumn2Value,
}) async {
  final file = File(excelPath);
  if (await file.exists()) await file.delete();

  final workbook = xlsio.Workbook();
  final sheet = workbook.worksheets[0];

  // 🔵 Başlıklar
  final headers = [column1Header, column2Header];

  for (int i = 0; i < headers.length; i++) {
    final cell = sheet.getRangeByIndex(1, i + 1);
    cell.setText(headers[i]);

    final style = cell.cellStyle;
    style.bold = true;
    style.backColorRgb = const Color.fromARGB(255, 13, 71, 161);
    style.fontColorRgb = const Color.fromARGB(255, 255, 255, 255);
    style.hAlign = xlsio.HAlignType.center;
    style.vAlign = xlsio.VAlignType.center;
    style.borders.all.lineStyle = xlsio.LineStyle.thin;
  }

  // ✅ AUTO FILTER EKLE
  sheet.autoFilters.filterRange = sheet.getRangeByIndex(1, 1, 1, 2);

  // Freeze Panes
  sheet.getRangeByIndex(2, 1).freezePanes();

  // 📊 Veri satırları
  int row = 2;
  for (var item in items) {
    sheet.getRangeByIndex(row, 1).setText(getColumn1Value(item));
    sheet.getRangeByIndex(row, 2).setText(getColumn2Value(item));
    // 🎨 ZEBRA RENK — Çift satırlar pastel açık mavi
    if (row % 2 == 0) {
      final rng = sheet.getRangeByIndex(row, 1, row, 2);
      rng.cellStyle.backColorRgb = const Color.fromARGB(
        255,
        220,
        235,
        255,
      ); // pastel açık mavi
    }
    row++;
  }

  // 📏 Sütun genişlikleri — AUTO-FIT
  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);

  // 💾 Kaydet
  final bytes = workbook.saveAsStream();
  workbook.dispose();

  await file.writeAsBytes(bytes);
}

/// ---------------------------------------------------------------------------
/// 📌 Word modeline özel Excel oluşturucu
///    Word(word, meaning) yapısına göre Excel üretir.
///    export_items.dart tarafından çağrılır.
/// ---------------------------------------------------------------------------
Future<void> exportItemsToExcel(String excelPath, List<dynamic> items) async {
  await exportItemsToExcelFromList(
    excelPath,
    items,
    column1Header: "Kelime",
    column2Header: "Anlam",
    getColumn1Value: (item) => item.word,
    getColumn2Value: (item) => item.meaning,
  );
}
