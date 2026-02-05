// 📃 <----- lib/utils/fc_files/excel_helper.dart ----->
//
// Excel oluşturma (Netflix Watchlist) - STİLLİ + GERÇEK TARİH
// -----------------------------------------------------------
// • Title,Date şemasını kullanır
// • Date hücresi DateTime olarak yazılır (Excel date)
// • numberFormat ile dd/MM/yyyy görüntülenir
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../../../constants/file_info.dart';
import '../../models/netflix_item.dart';

DateTime? _parseNetflixDateMmDdYy(String raw) {
  final s = raw.trim();
  final p = s.split('/');
  if (p.length != 3) return null;

  final mm = int.tryParse(p[0]);
  final dd = int.tryParse(p[1]);
  final yy = int.tryParse(p[2]);

  if (mm == null || dd == null || yy == null) return null;

  // Netflix history genelde 2 haneli yıl → 20xx
  final yyyy = (yy < 100) ? (2000 + yy) : yy;

  // basit doğrulama
  if (mm < 1 || mm > 12 || dd < 1 || dd > 31) return null;

  return DateTime(yyyy, mm, dd);
}

Future<void> createStyledExcelFromItemsSyncfusion({
  required List<NetflixItem> items,
  String? outputPath, // null ise Documents/{fileNameXlsx}
}) async {
  const tag = 'excel_helper';

  try {
    final directory = await getApplicationDocumentsDirectory();
    final excelPath = outputPath ?? join(directory.path, fileNameXlsx);

    log("📄 Excel hedef yolu: $excelPath", name: tag);

    final file = File(excelPath);
    if (await file.exists()) {
      await file.delete();
    }

    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    // --------------------------------------------------------
    // 🔵 HEADER (Title, Date)
    // --------------------------------------------------------
    final headers = ['Title', 'Date'];

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

    // Freeze header
    sheet.getRangeByIndex(2, 1).freezePanes();

    // --------------------------------------------------------
    // 📊 DATA
    // --------------------------------------------------------
    int rowIndex = 2;

    for (final item in items) {
      // Title
      sheet.getRangeByIndex(rowIndex, 1).setText(item.title);

      // Date (Excel DateTime)
      final dt = _parseNetflixDateMmDdYy(item.date);
      final dateCell = sheet.getRangeByIndex(rowIndex, 2);

      if (dt != null) {
        dateCell.dateTime = dt; // ✅ gerçek tarih
        dateCell.numberFormat = 'dd/MM/yyyy'; // ✅ görüntü formatı
      } else {
        // fallback: bozuk tarih gelirse string yaz
        dateCell.setText(item.date);
      }

      // Zebra satır
      if (rowIndex % 2 == 0) {
        sheet
            .getRangeByIndex(rowIndex, 1, rowIndex, 2)
            .cellStyle
            .backColorRgb = const Color.fromARGB(255, 220, 235, 255);
      }

      // Border
      sheet
          .getRangeByIndex(rowIndex, 1, rowIndex, 2)
          .cellStyle
          .borders
          .all
          .lineStyle = xlsio.LineStyle.thin;

      rowIndex++;
    }

    final lastRow = rowIndex - 1;

    // Filter + AutoFit
    if (lastRow >= 2) {
      sheet.autoFilters.filterRange = sheet.getRangeByIndex(1, 1, lastRow, 2);
    }

    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);

    final bytes = workbook.saveAsStream();
    workbook.dispose();
    await File(excelPath).writeAsBytes(bytes);

    log('✅ Excel oluşturuldu (stilli + tarih): ${items.length} kayıt', name: tag);
  } catch (e, st) {
    log('❌ Excel oluşturma hatası: $e', name: tag, error: e, stackTrace: st);
  }
}
