// 📁 lib/services/export_file_service.dart
//
// ============================================================================
// 📦 ExportFileService – Dosya Üretim Servisi
// ============================================================================
//
// Bu servis yalnızca dosya üretme işini yapar.
//
// Sorumlulukları:
// • CSV oluşturmak
// • JSON oluşturmak
// • XLSX oluşturmak
//
// Not:
// • Download klasörüne kopyalama burada yapılmaz
// • İzin kontrolü burada yapılmaz
// • Temp klasör yönetimi burada yapılmaz
//
// Bu yapı sayesinde servis tek sorumluluk ilkesine uygun kalır.
// ============================================================================

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../models/netflix_item.dart';

class ExportFileService {
  // ==========================================================================
  // 📄 exportCsv()
  // ==========================================================================
  // Verilen kayıt listesini CSV dosyasına dönüştürür.
  //
  // Format:
  //   Title,Date
  //   Example Movie,04/03/2026
  //
  Future<void> exportCsv(List<NetflixItem> items, String path) async {
    final data = <List<String>>[
      ['Title', 'Date'],
      ...items.map((e) => [e.title, e.date]),
    ];

    final csv = const ListToCsvConverter().convert(data);
    await File(path).writeAsString(csv);
  }

  // ==========================================================================
  // 📄 exportJson()
  // ==========================================================================
  // Verilen kayıt listesini JSON formatında dosyaya yazar.
  //
  // Format:
  // [
  //   { "title": "...", "date": "04/03/2026" }
  // ]
  //
  Future<void> exportJson(List<NetflixItem> items, String path) async {
    final jsonList = items
        .map((e) => {
      'title': e.title,
      'date': e.date,
    })
        .toList();

    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);
    await File(path).writeAsString(jsonStr);
  }

  // ==========================================================================
  // 📊 exportExcel()
  // ==========================================================================
  // Verilen kayıt listesini Excel dosyasına dönüştürür.
  //
  // Bu sürümde başlık formatları korunur:
  // • koyu mavi başlık
  // • beyaz yazı
  // • center align
  // • border
  // • zebra satırlar
  // • auto filter
  // • autoFitColumn
  //
  Future<void> exportExcel(List<NetflixItem> items, String path) async {
    final workbook = xlsio.Workbook();

    try {
      final sheet = workbook.worksheets[0];

      // --------------------------------------------------------
      // 🔵 Başlık satırı
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

      // Başlık satırını sabitle
      sheet.getRangeByIndex(2, 1).freezePanes();

      // --------------------------------------------------------
      // 📊 Veri satırları
      // --------------------------------------------------------
      for (int i = 0; i < items.length; i++) {
        final rowIndex = i + 2;

        sheet.getRangeByIndex(rowIndex, 1).setText(items[i].title);
        sheet.getRangeByIndex(rowIndex, 2).setText(items[i].date);

        // Zebra satır
        if (rowIndex % 2 == 0) {
          sheet
              .getRangeByIndex(rowIndex, 1, rowIndex, 2)
              .cellStyle
              .backColorRgb = const Color.fromARGB(255, 220, 235, 255);
        }
      }

      final lastRow = items.length + 1;

      // --------------------------------------------------------
      // 🔍 Filter + AutoFit
      // --------------------------------------------------------
      sheet.autoFilters.filterRange = sheet.getRangeByIndex(1, 1, lastRow, 2);

      sheet.autoFitColumn(1);
      sheet.autoFitColumn(2);

      final bytes = workbook.saveAsStream();
      await File(path).writeAsBytes(bytes, flush: true);
    } finally {
      workbook.dispose();
    }
  }
}