// 📃 <----- lib/utils/file_creator.dart ----->
//
// 🎬 Netflix Film List App
// -----------------------------------------------------------
// Uygulama veri akışı:
// 1️⃣ Veritabanı var mı kontrol edilir.
// 2️⃣ Yoksa asset içindeki CSV okunur, tarih formatı düzeltilir.
// 3️⃣ CSV → JSON ve Excel dosyaları oluşturulur.
// 4️⃣ JSON → SQL aktarımı yapılır (batch olarak, hızlı).
// 5️⃣ Tüm dosyalar Download/{appName} dizinine kopyalanır (download_helper.dart).
//
// Ayrıca:
//  • Eğer veritabanı zaten varsa, hiçbir yeniden oluşturma yapılmaz.
//  • Eksik dosyalar otomatik tamamlanır.
//  • Modern Android izin sistemi ile uyumludur.
//
// Kullanım:
//   await initializeAppDataFlow();
//
// -----------------------------------------------------------

// 📦 Dart & Flutter paketleri
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

// 📦 Uygulama dosyaları
import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../models/item_model.dart';
import 'fc_files/download_helper.dart'; // ✅ kopyalama işlemi buradan çağrılıyor

/// 🚀 Uygulama başlatıldığında çağrılır.
/// Tüm veri dosyalarını, veritabanını ve dışa aktarmayı yönetir.
Future<void> initializeAppDataFlow() async {
  const tag = 'AppDataFlow';
  log('🚀 initializeAppDataFlow başladı', name: tag);

  // 📂 Dizinleri al
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = join(directory.path, fileNameSql);
  final dbFile = File(dbPath);

  // ✅ Eğer veritabanı varsa hiçbir şey yapma
  if (await dbFile.exists()) {
    final count = await DbHelper.instance.countRecords();
    log(
      '[JSON→SQL Import (Batch)] 🟢 Veritabanı zaten dolu ($count kayıt). Tekrar oluşturulmadı.',
      name: tag,
    );
    return;
  }

  // 🔹 Veritabanı yoksa işlem sırasını başlat
  log(
    '⚠️ Veritabanı bulunamadı, asset CSV ’den veri oluşturulacak.',
    name: tag,
  );

  // 1️⃣ CSV oluştur (cihazda yoksa)
  await _createDeviceCsvFromAssetWithDateFix();

  // 2️⃣ JSON oluştur (cihazda yoksa)
  await _createJsonFromAssetCsv();

  // 3️⃣ Excel oluştur (cihazda yoksa)
  await _createExcelFromAssetCsvSyncfusion();

  // 4️⃣ JSON → SQL aktarımı (batch)
  await _importJsonToDatabaseFast();

  // 5️⃣ Dosyaları Download dizinine kopyala (artık ayrı helper ’da)
  await copyBackupFilesToDownload();

  log('✅ initializeAppDataFlow tamamlandı.', name: tag);
}

// ---------------------------------------------------------------------
// 🧩 AŞAMA 1 — CSV OLUŞTURMA (Tarih dönüştürmeli)
// ---------------------------------------------------------------------
Future<void> _createDeviceCsvFromAssetWithDateFix() async {
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

    if (!await File(outPath).exists()) {
      await File(outPath).writeAsString(csvOut);
      log('✅ CSV oluşturuldu: $outPath', name: tag);
    } else {
      log('ℹ️ CSV zaten mevcut, yeniden oluşturulmadı.', name: tag);
    }
  } catch (e) {
    log('❌ CSV oluşturma hatası: $e', name: tag);
  }
}

// ---------------------------------------------------------------------
// 🧩 AŞAMA 2 — JSON OLUŞTURMA
// ---------------------------------------------------------------------
Future<void> _createJsonFromAssetCsv() async {
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

      final record = <String, dynamic>{};
      for (int j = 0; j < headers.length; j++) {
        var value = row[j].toString().trim();
        if (j == dateIdx) value = _mmddyyToDdmmyy(value);
        record[headers[j]] = value;
      }
      jsonList.add(record);
    }

    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);

    if (!await File(jsonPath).exists()) {
      await File(jsonPath).writeAsString(jsonStr);
      log('✅ JSON dosyası oluşturuldu: $jsonPath', name: tag);
    } else {
      log('ℹ️ JSON zaten mevcut, yeniden oluşturulmadı.', name: tag);
    }
  } catch (e) {
    log('❌ CSV→JSON dönüştürme hatası: $e', name: tag);
  }
}

// ---------------------------------------------------------------------
// 🧩 AŞAMA 3 — EXCEL (Syncfusion) OLUŞTURMA
// ---------------------------------------------------------------------
Future<void> _createExcelFromAssetCsvSyncfusion() async {
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
    }

    // Veriler
    for (int r = 1; r < rows.length; r++) {
      final row = List<String>.from(rows[r].map((e) => e.toString()));
      if (row.length > dateIdx && dateIdx != -1) {
        row[dateIdx] = _mmddyyToDdmmyy(row[dateIdx]);
      }
      for (int c = 0; c < headers.length; c++) {
        sheet.getRangeByIndex(r + 1, c + 1).setText(row[c]);
      }
    }

    // Sütun genişliklerini otomatik ayarla
    for (int c = 1; c <= headers.length; c++) {
      sheet.autoFitColumn(c);
    }

    final directory = await getApplicationDocumentsDirectory();
    final excelPath = join(directory.path, fileNameXlsx);

    if (!await File(excelPath).exists()) {
      final bytes = workbook.saveAsStream();
      await File(excelPath).writeAsBytes(bytes, flush: true);
      workbook.dispose();
      log('✅ Excel oluşturuldu: $excelPath', name: tag);
    } else {
      log('ℹ️ Excel zaten mevcut, yeniden oluşturulmadı.', name: tag);
    }
  } catch (e) {
    log('❌ CSV→Excel (Syncfusion) hatası: $e', name: tag);
  }
}

// ---------------------------------------------------------------------
// 🧩 AŞAMA 4 — JSON → SQL (Batch Import)
// ---------------------------------------------------------------------
Future<void> _importJsonToDatabaseFast() async {
  const tag = 'JSON→SQL Import (Batch)';
  try {
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);
    final file = File(jsonPath);

    if (!await file.exists()) {
      log('⚠️ JSON dosyası bulunamadı.', name: tag);
      return;
    }

    final jsonStr = await file.readAsString();
    final List<dynamic> jsonList = json.decode(jsonStr);
    final items = jsonList.map(
      (e) => NetflixItem(
        netflixItemName: e['Title'] ?? '',
        watchDate: e['Date'] ?? '',
      ),
    );

    await DbHelper.instance.insertBatch(items.toList());
    final count = await DbHelper.instance.countRecords();
    log('✅ SQL batch aktarımı tamamlandı ($count kayıt).', name: tag);
  } catch (e) {
    log('❌ JSON→SQL import hatası: $e', name: tag);
  }
}

// ---------------------------------------------------------------------
// 🔧 Yardımcı Fonksiyonlar
// ---------------------------------------------------------------------

/// 🗓️ "aa/gg/yy" → "gg/aa/yy" dönüştürme
String _mmddyyToDdmmyy(String s) {
  try {
    final parts = s.split('/');
    if (parts.length != 3) return s;
    return '${parts[1].padLeft(2, '0')}/${parts[0].padLeft(2, '0')}/${parts[2].padLeft(2, '0')}';
  } catch (_) {
    return s;
  }
}
