// 📃 <----- file_creator.dart ----->
//
//  Bu dosya veritabanı ve yedek dosya işlemlerini yönetir.
//  • Veritabanı var mı kontrol eder.
//  • Asset içindeki CSV’yi okuyarak JSON, CSV ve Excel oluşturur.
//  • CSV → JSON, JSON → SQL dönüşümlerini içerir.
//  • JSON → SQL aktarımı toplu (batch) şekilde yapılır (çok hızlı).
//

// 📌 Dart paketleri
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// 📌 Flutter paketleri
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

// 📌 Uygulama sabitleri
import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../models/item_model.dart';

/// 🗓️ "aa/gg/yy" → "gg/aa/yy" dönüştürme
String _mmddyyToDdmmyy(String s) {
  try {
    final parts = s.split('/');
    if (parts.length != 3) return s;
    final month = parts[0].padLeft(2, '0');
    final day = parts[1].padLeft(2, '0');
    final year = parts[2].padLeft(2, '0');
    return '$day/$month/$year';
  } catch (_) {
    return s;
  }
}

/// 📦 Asset ’teki CSV ’yi okuyup tarihleri "aa/gg/yy" → "gg/aa/yy" çevirir
/// ve sonucu cihazda [fileNameCsv] adıyla kaydeder.
Future<void> createDeviceCsvFromAssetWithDateFix() async {
  const tag = 'CSV Builder';
  try {
    const assetCsvPath = 'assets/database/$assetsFileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);
    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvRaw);
    if (rows.isEmpty) {
      log('⚠️ Asset CSV boş!', name: tag);
      return;
    }

    final headers = rows.first.map((e) => e.toString()).toList();
    final dateIdx = headers.indexWhere((h) => h.trim().toLowerCase() == 'date');

    final List<List<dynamic>> out = [headers];
    for (int i = 1; i < rows.length; i++) {
      final row = List<dynamic>.from(rows[i]);
      if (row.length > dateIdx && dateIdx != -1) {
        row[dateIdx] = _mmddyyToDdmmyy(row[dateIdx].toString());
      }
      out.add(row);
    }

    final csvOut = const ListToCsvConverter().convert(out);
    final directory = await getApplicationDocumentsDirectory();
    final outPath = join(directory.path, fileNameCsv);
    await File(outPath).writeAsString(csvOut);

    log('✅ Dönüştürülmüş CSV oluşturuldu: $outPath', name: tag);
    log('📦 Satır sayısı (başlık dahil): ${out.length}', name: tag);
  } catch (e) {
    log('❌ CSV oluşturma hatası: $e', name: tag);
  }
}

/// 📦 Asset içindeki CSV’yi okuyup JSON dosyasına dönüştürür.
/// Tarihleri "aa/gg/yy" → "gg/aa/yy" çevirir ve cihazda [fileNameJson] olarak kaydeder.
Future<void> createJsonFromAssetCsv() async {
  const tag = 'CSV→JSON Builder';
  try {
    const assetCsvPath = 'assets/database/$assetsFileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);
    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvRaw);

    if (rows.isEmpty) {
      log('⚠️ Asset CSV boş!', name: tag);
      return;
    }

    final headers = rows.first.map((e) => e.toString().trim()).toList();
    final dateIdx = headers.indexWhere(
      (h) => h.toLowerCase() == 'date' || h.toLowerCase() == 'watched date',
    );

    final List<Map<String, dynamic>> jsonList = [];
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length != headers.length) continue;

      final Map<String, dynamic> record = {};
      for (int j = 0; j < headers.length; j++) {
        final key = headers[j];
        var value = row[j].toString().trim();
        if (j == dateIdx) value = _mmddyyToDdmmyy(value);
        record[key] = value;
      }
      jsonList.add(record);
    }

    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);
    await File(jsonPath).writeAsString(jsonStr);

    log('✅ JSON dosyası oluşturuldu: $jsonPath', name: tag);
    log('📦 Kayıt sayısı: ${jsonList.length}', name: tag);
  } catch (e) {
    log('❌ CSV→JSON dönüştürme hatası: $e', name: tag);
  }
}

/// 📊 Asset içindeki CSV’yi okuyup Syncfusion biçimli Excel dosyası (xlsx) oluşturur.
Future<void> createExcelFromAssetCsvSyncfusion() async {
  const tag = 'CSV→Excel (Syncfusion)';
  try {
    const assetCsvPath = 'assets/database/$assetsFileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);
    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvRaw);

    if (rows.isEmpty) {
      log('⚠️ Asset CSV boş!', name: tag);
      return;
    }

    final headers = rows.first.map((e) => e.toString().trim()).toList();
    final dateIdx = headers.indexWhere(
      (h) => h.toLowerCase() == 'date' || h.toLowerCase() == 'watched date',
    );

    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];
    sheet.name = 'Netflix_Data';

    // Başlıklar
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(1, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#1E1E1E';
      cell.cellStyle.fontColor = '#FFFFFF';
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
      sheet.autoFitColumn(i + 1);
    }

    // Veriler
    for (int r = 1; r < rows.length; r++) {
      final row = List<String>.from(rows[r].map((e) => e.toString()));
      if (row.length > dateIdx && dateIdx != -1) {
        row[dateIdx] = _mmddyyToDdmmyy(row[dateIdx]);
      }
      for (int c = 0; c < headers.length; c++) {
        sheet
            .getRangeByIndex(r + 1, c + 1)
            .setText(row.length > c ? row[c] : '');
      }
    }

    // Stil ve format
    for (int i = 1; i <= headers.length; i++) {
      sheet.autoFitColumn(i);
    }
    sheet.getRangeByName('A1:${_getColumnLetter(headers.length)}1')
      ..cellStyle.bold = true
      ..cellStyle.backColor = '#C00000'
      ..cellStyle.fontColor = '#FFFFFF'
      ..cellStyle.hAlign = xlsio.HAlignType.center;

    final directory = await getApplicationDocumentsDirectory();
    final excelPath = join(directory.path, fileNameXlsx);
    final bytes = workbook.saveAsStream();
    await File(excelPath).writeAsBytes(bytes, flush: true);
    workbook.dispose();

    log('✅ Syncfusion Excel oluşturuldu: $excelPath', name: tag);
    log('📦 Satır sayısı (başlık dahil): ${rows.length}', name: tag);
  } catch (e) {
    log('❌ CSV→Excel (Syncfusion) hata: $e', name: tag);
  }
}

/// 🅰️ Kolon harfi hesaplayıcı (örnek: 1→A, 26→Z, 27→AA)
String _getColumnLetter(int colNumber) {
  String colLetter = '';
  while (colNumber > 0) {
    int remainder = (colNumber - 1) % 26;
    colLetter = String.fromCharCode(65 + remainder) + colLetter;
    colNumber = (colNumber - remainder - 1) ~/ 26;
  }
  return colLetter;
}

/// ⚡ JSON → SQL hızlı (batch) aktarım
Future<void> importJsonToDatabaseFast() async {
  const tag = 'JSON→SQL Import (Batch)';
  try {
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);
    final file = File(jsonPath);

    if (!await file.exists()) {
      log('❌ JSON dosyası bulunamadı: $jsonPath', name: tag);
      return;
    }

    final jsonStr = await file.readAsString();
    final List<dynamic> jsonList = json.decode(jsonStr);
    if (jsonList.isEmpty) {
      log('⚠️ JSON dosyası boş.', name: tag);
      return;
    }

    final db = await DbHelper.instance.database;
    final batch = db.batch();

    int counter = 0;
    for (final e in jsonList) {
      final map = e as Map<String, dynamic>;
      final name = map['Title'] ?? map['Name'] ?? map['netflixItemName'] ?? '';
      final date = map['Date'] ?? map['watchDate'] ?? '';
      if (name.toString().isEmpty) continue;
      final item = NetflixItem(netflixItemName: name, watchDate: date);
      batch.insert(sqlTableName, item.toMap());

      counter++;
      if (counter % 500 == 0) {
        await batch.commit(noResult: true);
        log('✅ $counter kayıt işlendi...', name: tag);
      }
    }

    await batch.commit(noResult: true);
    log('🎉 JSON→SQL aktarımı tamamlandı. Toplam: $counter kayıt.', name: tag);
  } catch (e) {
    log('🚨 JSON→SQL aktarım hatası: $e', name: tag);
  }
}

/// 📌 Veritabanı dosyasının var olup olmadığını kontrol eder.
Future<void> checkIfDatabaseExists() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, fileNameSql);
    final dbFile = File(dbPath);

    if (await dbFile.exists()) {
      log('✅ Veritabanı var: $dbPath', name: 'DB Check');
    } else {
      log('⚠️ Veritabanı yok: $dbPath', name: 'DB Check');

      const assetCsvPath = 'assets/database/$assetsFileNameCsv';
      try {
        final data = await rootBundle.loadString(assetCsvPath);
        if (data.isNotEmpty) {
          log('✅ Asset CSV dosyası bulundu: $assetCsvPath', name: 'DB Check');
        } else {
          log('⚠️ Asset CSV dosyası boş veya okunamadı.', name: 'DB Check');
        }
      } catch (e) {
        log('⚠️ Asset CSV dosyası bulunamadı: $e', name: 'DB Check');
      }
    }
  } catch (e) {
    log('🚨 Veritabanı kontrolü sırasında hata: $e', name: 'DB Check');
  }
}
