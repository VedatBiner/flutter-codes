// 📃 <----- lib/utils/fc_files/excel_helper.dart ----->
//
// Excel oluşturma işlemi (Kelime – Anlam – Tarih)
// -----------------------------------------------------------
// • Excel HER ZAMAN yeniden oluşturulur
// • CSV ile %100 uyumludur (Kelime, Anlam, Tarih)
// • Tarih CSV ’den okunur (sabit değil)
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../../constants/file_info.dart';

/// ---------------------------------------------------------------------------
/// 📌 CSV ’den Excel oluşturur (Kelime – Anlam – Tarih)
/// ---------------------------------------------------------------------------
Future<void> createExcelFromAssetCsvSyncfusion() async {
  const tag = 'excel_helper';

  try {
    final directory = await getApplicationDocumentsDirectory();
    final excelPath = join(directory.path, fileNameXlsx);

    log("📄 Excel hedef yolu: $excelPath", name: tag);

    // 🔄 Eski Excel varsa sil
    final file = File(excelPath);
    if (await file.exists()) {
      await file.delete();
    }

    // 📥 CSV oku
    final csvPath = join(directory.path, fileNameCsv);
    final csvFile = File(csvPath);

    if (!await csvFile.exists()) {
      log('❌ CSV bulunamadı, Excel üretilemedi.', name: tag);
      return;
    }

    final csvRaw = await csvFile.readAsString();
    final rows = csvRaw
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .split('\n')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    if (rows.length <= 1) {
      log('⚠️ CSV boş veya sadece başlık var.', name: tag);
      return;
    }

    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    // --------------------------------------------------------
    // 🔵 BAŞLIK SATIRI
    // --------------------------------------------------------
    final headers = ['Kelime', 'Anlam', 'Tarih'];

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

    // Başlık sabit
    sheet.getRangeByIndex(2, 1).freezePanes();

    // --------------------------------------------------------
    // 📊 VERİ SATIRLARI
    // --------------------------------------------------------
    int rowIndex = 2;

    for (int i = 1; i < rows.length; i++) {
      final parts = rows[i].split(',');

      // Kelime
      if (parts.isNotEmpty) {
        sheet.getRangeByIndex(rowIndex, 1).setText(parts[0].trim());
      }

      // Anlam
      if (parts.length >= 2) {
        sheet.getRangeByIndex(rowIndex, 2).setText(parts[1].trim());
      }

      // 📅 Tarih (CSV ’den)
      if (parts.length >= 3) {
        sheet.getRangeByIndex(rowIndex, 3).setText(parts[2].trim());
      }

      // 🎨 Zebra satır
      if (rowIndex % 2 == 0) {
        sheet.getRangeByIndex(rowIndex, 1, rowIndex, 3).cellStyle.backColorRgb =
            const Color.fromARGB(255, 220, 235, 255);
      }

      rowIndex++;
    }

    final lastRow = rowIndex - 1;

    // --------------------------------------------------------
    // 🔍 Filter + AutoFit
    // --------------------------------------------------------
    sheet.autoFilters.filterRange = sheet.getRangeByIndex(1, 1, lastRow, 3);

    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(3);

    // --------------------------------------------------------
    // 💾 Kaydet
    // --------------------------------------------------------
    final bytes = workbook.saveAsStream();
    workbook.dispose();
    await File(excelPath).writeAsBytes(bytes);

    log(
      '✅ Excel oluşturuldu (Kelime–Anlam–Tarih): ${rows.length - 1} kayıt',
      name: tag,
    );
  } catch (e, st) {
    log('❌ Excel oluşturma hatası: $e', name: tag, error: e, stackTrace: st);
  }
}
