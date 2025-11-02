// 📃 <----- file_creator.dart ----->
//
// Bu yardımcı; CSV/JSON/XLSX üretimi, veritabanı ve dışa kopyalama akışını yönetir.
// - initializeAppDataFlow(...) tek çağrıyla tüm akışı yürütür
// - Veritabanı kontrolü (varsa import atlanır → çift kayıt engellenir)
// - Asset CSV → Cihaz CSV (tarihleri aa/gg/yy → gg/aa/yy çevirir)
// - Asset CSV → Cihaz JSON (tarih dönüşümü ile)
// - Asset CSV → Cihaz XLSX (Syncfusion; başlık stilleri + tüm sütunlara auto-fit)
// - JSON → SQL import (tek transaction + batch + progress callback)
// - Cihaz içi dosyaları Download/{appName} içine kopyalama ve paylaşma
//
// Not: Veriniz çok büyükse (10k+ satır), JSON parse kısmını compute() ile
// ayrı isolate’a taşıyabiliriz. Şimdilik tek iş parçacığı yeterli hızda çalışır.
//

// ========== Dart & Flutter imports ==========
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
// Dışa kopyalama / izin / paylaşım
import 'package:external_path/external_path.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
// SQL (Db sayacı + conflict alg.)
import 'package:sqflite/sqflite.dart' show Sqflite, ConflictAlgorithm;
// Excel
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

// ========== App imports ==========
import '../constants/file_info.dart';
import '../db/db_helper.dart';
import '../models/item_model.dart';

typedef ProgressCallback =
    void Function(double progress, int processed, int total);

/// 🚀 Tek merkez: Uygulama açılışında tüm dosya & DB akışını başlat.
/// - DB varsa: JSON→SQL import atlanır (çift kayıt önlenir).
/// - Dosyalar (CSV/JSON/XLSX) cihaz dizinine yazılır.
/// - Ardından Download/{appName} içine kopyalanır.
Future<void> initializeAppDataFlow({ProgressCallback? onProgressChange}) async {
  const tag = 'Initializer';
  log('🚀 initializeAppDataFlow başladı', name: tag);

  // 1) DB var mı?
  final dbExists = await _databaseExists();

  // 2) Dosyaları oluştur (CSV/JSON/XLSX) — her zaman güncel üret
  await createDeviceCsvFromAssetWithDateFix();
  await createJsonFromAssetCsv();
  await createExcelFromAssetCsvSyncfusion();

  // 3) JSON → SQL (sadece DB boşsa; çift kayıt önler)
  if (!dbExists) {
    await importJsonToDatabaseFast(onProgressChange: onProgressChange);
  } else {
    final db = await DbHelper.instance.database;
    final existing =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $sqlTableName'),
        ) ??
        0;
    log('🟢 Veritabanı dolu ($existing kayıt). JSON→SQL atlandı.', name: tag);
  }

  // 4) Download/{appName} dizinine kopyala
  await copyBackupFilesToDownload();

  log('✅ initializeAppDataFlow tamamlandı', name: tag);
}

// ===================================================================
// 1) Veritabanı kontrolü
// ===================================================================

/// 📌 Uygulama içi DB dosyası var mı?
Future<bool> _databaseExists() async {
  const tag = 'DB Check';
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = join(directory.path, fileNameSql);
  final dbFile = File(dbPath);

  if (await dbFile.exists()) {
    log('✅ Veritabanı var: $dbPath', name: tag);
    return true;
  } else {
    log('⚠️ Veritabanı yok: $dbPath', name: tag);

    // Asset CSV var mı? Bilgi amaçlı log
    const assetCsvPath = 'assets/database/$assetsFileNameCsv';
    try {
      final data = await rootBundle.loadString(assetCsvPath);
      if (data.isNotEmpty) {
        log('✅ Asset CSV dosyası bulundu: $assetCsvPath', name: tag);
      } else {
        log('⚠️ Asset CSV boş veya okunamadı: $assetCsvPath', name: tag);
      }
    } catch (_) {
      log('⚠️ Asset CSV dosyası bulunamadı: $assetCsvPath', name: tag);
    }
    return false;
  }
}

// ===================================================================
// 2) CSV (asset) → CSV (device) [tarih: aa/gg/yy → gg/aa/yy]
// ===================================================================

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

    // Başlıklar + Date sütunu
    final headers = rows.first.map((e) => e.toString()).toList();
    final dateIdx = headers.indexWhere((h) => h.trim().toLowerCase() == 'date');

    final List<List<String>> out = [headers.map((e) => e.toString()).toList()];
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i].map((e) => e.toString()).toList();
      if (dateIdx != -1 && row.length > dateIdx) {
        row[dateIdx] = _mmddyyToDdmmyy(row[dateIdx]);
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

// ===================================================================
// 3) CSV (asset) → JSON (device) [tarih dönüştürülmüş]
// ===================================================================

/// 📦 Asset CSV’yi okuyup JSON dosyasına dönüştürür.
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

// ===================================================================
// 4) CSV (asset) → XLSX (device) [Syncfusion; başlıklar + auto-fit]
// ===================================================================

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
      cell.cellStyle.vAlign = xlsio.VAlignType.center;
    }

    // Veri satırları (tarih dönüştür)
    for (int r = 1; r < rows.length; r++) {
      final row = rows[r].map((e) => e.toString()).toList();
      if (dateIdx != -1 && row.length > dateIdx) {
        row[dateIdx] = _mmddyyToDdmmyy(row[dateIdx]);
      }
      for (int c = 0; c < headers.length; c++) {
        sheet
            .getRangeByIndex(r + 1, c + 1)
            .setText(row.length > c ? row[c] : '');
      }
    }

    // Başlık satırını renklendir (A1:??1)
    sheet.getRangeByName('A1:${_getColumnLetter(headers.length)}1')
      ..cellStyle.bold = true
      ..cellStyle.backColor = '#C00000'
      ..cellStyle.fontColor = '#FFFFFF'
      ..cellStyle.hAlign = xlsio.HAlignType.center;

    // 🔧 Tüm sütunları auto-fit (parametreli; tek tek)
    _autoFitAllColumns(sheet, headers.length);

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

/// 🔧 Tüm sütunları indeks vererek `autoFitColumn(colIndex)` ile genişlet
void _autoFitAllColumns(xlsio.Worksheet sheet, int colCount) {
  for (int col = 1; col <= colCount; col++) {
    sheet.autoFitColumn(col); // ✅ parametreli çağrı şart
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

// ===================================================================
// 5) JSON (device) → SQL (batch+transaction+progress)
// ===================================================================

Future<void> importJsonToDatabaseFast({
  ProgressCallback? onProgressChange,
}) async {
  const tag = 'JSON→SQL Import (Batch)';

  try {
    final directory = await getApplicationDocumentsDirectory();
    final jsonPath = join(directory.path, fileNameJson);
    final file = File(jsonPath);

    if (!await file.exists()) {
      log('⚠️ JSON bulunamadı: $jsonPath (import atlandı)', name: tag);
      return;
    }

    final db = await DbHelper.instance.database;

    // Veritabanı doluysa tekrar oluşturma (çift kaydı engeller)
    final existing =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $sqlTableName'),
        ) ??
        0;
    if (existing > 0) {
      log('🟢 Veritabanı dolu ($existing kayıt). Import atlandı.', name: tag);
      return;
    }

    // JSON oku (gerekirse compute ile ayrılabilir)
    final jsonStr = await file.readAsString();
    final List<dynamic> list = json.decode(jsonStr);

    if (list.isEmpty) {
      log('⚠️ JSON boş, import yapılmadı.', name: tag);
      return;
    }

    final total = list.length;
    final batchSize = 1000; // büyük setlerde daha hızlı
    int processed = 0;

    await db.transaction((txn) async {
      for (int start = 0; start < total; start += batchSize) {
        final end = (start + batchSize > total) ? total : start + batchSize;
        final slice = list.sublist(start, end);

        final batch = txn.batch();
        for (final raw in slice) {
          // CSV→JSON üretimindeki başlıklara göre alan seçimi
          // Netflix CSV 'lerinde genelde 'Title' ve 'Date' olur.
          final map = raw as Map<String, dynamic>;
          final name = (map['Title'] ?? map['Name'] ?? map['title'] ?? '')
              .toString();
          final date = (map['Date'] ?? map['Watched Date'] ?? '').toString();

          final item = NetflixItem(netflixItemName: name, watchDate: date);
          batch.insert(
            sqlTableName,
            item.toMap(),
            conflictAlgorithm:
                ConflictAlgorithm.ignore, // aynı kayıtları es geç
          );
        }

        await batch.commit(noResult: true);
        processed = end;

        if (onProgressChange != null) {
          final prog = processed / total;
          onProgressChange(prog, processed, total);
        }
      }
    });

    log('✅ JSON import tamamlandı. ($processed/$total)', name: tag);
  } catch (e) {
    log('🚨 JSON→SQL import hatası: $e', name: tag);
  }
}

// ===================================================================
// 6) Download/{appName} dizinine kopyalama & paylaşım
// ===================================================================

/// 📦 Cihaz içi (app documents) dosyaları Download/{appName} dizinine kopyalar.
Future<void> copyBackupFilesToDownload() async {
  const tag = 'External Copy';

  try {
    // Android 13+ için READ/WRITE izinleri farklı olabilir; temel izin:
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      log('❌ Depolama izni verilmedi.', name: tag);
      return;
    }

    final downloadDir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );
    final targetDir = Directory(join(downloadDir, appName));

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
      log('📁 Klasör oluşturuldu: ${targetDir.path}', name: tag);
    }

    final internalDir = await getApplicationDocumentsDirectory();
    final List<String> fileNames = [
      fileNameCsv,
      fileNameJson,
      fileNameXlsx,
      fileNameSql,
    ];

    for (final name in fileNames) {
      final src = File(join(internalDir.path, name));
      final dest = File(join(targetDir.path, name));

      if (await src.exists()) {
        await src.copy(dest.path);
        log('✅ Kopyalandı: $name → ${targetDir.path}', name: tag);
      } else {
        log('⚠️ Kaynak dosya yok: ${src.path}', name: tag);
      }
    }

    log('🎉 Tüm dosyalar Download/$appName içine kopyalandı.', name: tag);
  } catch (e) {
    log('🚨 Kopyalama hatası: $e', name: tag);
  }
}

/// 📤 Download/{appName} dizinindeki dosyaları paylaşır (isteğe bağlı)
Future<void> shareBackupFolder() async {
  const tag = 'External Share';
  try {
    final downloadDir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );
    final folderPath = join(downloadDir, appName);
    final dir = Directory(folderPath);

    if (await dir.exists()) {
      final files = dir.listSync().whereType<File>().toList();
      if (files.isEmpty) {
        log('⚠️ Paylaşılacak dosya yok.', name: tag);
        return;
      }

      await Share.shareXFiles(
        files.map((f) => XFile(f.path)).toList(),
        text: '📂 $appName yedek dosyaları',
      );

      log('✅ Paylaşım ekranı açıldı.', name: tag);
    } else {
      log('⚠️ Dizin yok: $folderPath', name: tag);
    }
  } catch (e) {
    log('🚨 Paylaşım hatası: $e', name: tag);
  }
}
