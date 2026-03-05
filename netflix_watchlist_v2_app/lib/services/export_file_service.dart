// ============================================================================
// 📦 ExportFileService
// ============================================================================
//
// Bu servis sadece DOSYA üretme işlemini yapar.
//
// Repository pattern içinde bu katman:
//
//   • CSV üretir
//   • JSON üretir
//   • XLSX üretir
//
// Ancak:
//
//   • veri nereden geldiğini bilmez
//   • UI ile iletişim kurmaz
//
// Böylece Single Responsibility Principle korunur.
// ============================================================================

import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../models/netflix_item.dart';

class ExportFileService {

  // ==========================================================================
  // CSV EXPORT
  // ==========================================================================
  Future<void> exportCsv(List<NetflixItem> items, String path) async {

    final data = <List<String>>[
      ['Title', 'Date'],
    ];

    data.addAll(
      items.map((e) => [e.title, e.date]),
    );

    final csv = const ListToCsvConverter().convert(data);

    await File(path).writeAsString(csv);
  }

  // ==========================================================================
  // JSON EXPORT
  // ==========================================================================
  Future<void> exportJson(List<NetflixItem> items, String path) async {

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

  // ==========================================================================
  // XLSX EXPORT
  // ==========================================================================
  Future<void> exportExcel(List<NetflixItem> items, String path) async {

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
}