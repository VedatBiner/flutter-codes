// 📃 <----- file_creator.dart ----->
//
// NetflixFilmListApp için dosya yöneticisi:
// ✅ Asset → CSV / JSON / Excel dönüştürme
// ✅ Batch (hızlı) SQL import
// ✅ Download/{appName} dizinine otomatik kopyalama
// ✅ Paylaşım (Share Plus)
// ✅ Depolama izin kontrolü
//

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../constants/file_info.dart';
import '../db/db_helper.dart';

// 🔹 Ortak tarih dönüştürücü (MM/DD/YY → DD/MM/YY)
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

/// 🔹 Kolon harfi hesaplayıcı (örnek: 1→A, 27→AA)
String _getColumnLetter(int colNumber) {
  String colLetter = '';
  while (colNumber > 0) {
    int remainder = (colNumber - 1) % 26;
    colLetter = String.fromCharCode(65 + remainder) + colLetter;
    colNumber = (colNumber - remainder - 1) ~/ 26;
  }
  return colLetter;
}

/// 🗃️ Veritabanı var mı kontrol eder, yoksa asset CSV’yi kullanarak dosyaları oluşturur.
Future<void> checkIfDatabaseExists() async {
  const tag = 'DB Check';
  try {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, fileNameSql);
    final dbFile = File(dbPath);

    if (await dbFile.exists()) {
      log('✅ Veritabanı var: $dbPath', name: tag);
    } else {
      log('⚠️ Veritabanı yok: $dbPath', name: tag);

      const assetCsvPath = 'assets/database/$assetsFileNameCsv';
      try {
        final data = await rootBundle.loadString(assetCsvPath);
        if (data.isNotEmpty) {
          log('✅ Asset CSV bulundu: $assetCsvPath', name: tag);

          await createDeviceCsvFromAssetWithDateFix();
          await createJsonFromAssetCsv();
          await createExcelFromAssetCsvSyncfusion();
          await importJsonToDatabaseFast();

          await copyBackupFilesToDownload();
        } else {
          log('⚠️ Asset CSV boş veya okunamadı: $assetCsvPath', name: tag);
        }
      } catch (e) {
        log('❌ Asset CSV okunamadı: $e', name: tag);
      }
    }
  } catch (e) {
    log('🚨 Veritabanı kontrol hatası: $e', name: tag);
  }
}

/// 📦 Asset CSV’yi okuyup tarihleri düzeltir, cihazda yeni CSV oluşturur.
Future<void> createDeviceCsvFromAssetWithDateFix() async {
  const tag = 'CSV Builder';
  try {
    const assetCsvPath = 'assets/database/$assetsFileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvRaw);
    if (rows.isEmpty) return;

    final headers = rows.first.map((e) => e.toString()).toList();

    // 🔧 TİP HATASI DÜZELTME: out'u List<List<dynamic>> olarak başlat ve headers'ı cast et
    final List<List<dynamic>> out = [headers.cast<dynamic>()];

    final dateIdx = headers.indexWhere((h) => h.toLowerCase() == 'date');

    for (int i = 1; i < rows.length; i++) {
      final row = List<dynamic>.from(rows[i]);
      if (dateIdx != -1 && row.length > dateIdx) {
        row[dateIdx] = _mmddyyToDdmmyy(row[dateIdx].toString());
      }
      out.add(row); // ✅ Artık tip uyumsuzluğu yok
    }

    final csvOut = const ListToCsvConverter().convert(out);
    final dir = await getApplicationDocumentsDirectory();
    final csvPath = join(dir.path, fileNameCsv);
    await File(csvPath).writeAsString(csvOut);

    log('✅ Dönüştürülmüş CSV oluşturuldu: $csvPath', name: tag);
    log('📦 Satır sayısı: ${out.length}', name: tag);
  } catch (e) {
    log('❌ CSV oluşturma hatası: $e', name: tag);
  }
}

/// 📊 CSV → JSON dönüştürür ve cihazda kaydeder.
Future<void> createJsonFromAssetCsv() async {
  const tag = 'CSV→JSON Builder';
  try {
    const assetCsvPath = 'assets/database/$assetsFileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvRaw);
    if (rows.isEmpty) return;

    final headers = rows.first.map((e) => e.toString().trim()).toList();
    final dateIdx = headers.indexWhere(
      (h) => h.toLowerCase() == 'date' || h.toLowerCase() == 'watched date',
    );

    final jsonList = <Map<String, dynamic>>[];
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
    final dir = await getApplicationDocumentsDirectory();
    final jsonPath = join(dir.path, fileNameJson);
    await File(jsonPath).writeAsString(jsonStr);

    log('✅ JSON oluşturuldu: $jsonPath', name: tag);
    log('📦 Kayıt sayısı: ${jsonList.length}', name: tag);
  } catch (e) {
    log('❌ CSV→JSON hatası: $e', name: tag);
  }
}

/// 📗 CSV → Excel (Syncfusion) dönüştürür ve kaydeder.
Future<void> createExcelFromAssetCsvSyncfusion() async {
  const tag = 'CSV→Excel';
  try {
    const assetCsvPath = 'assets/database/$assetsFileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvRaw);
    if (rows.isEmpty) return;

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
      cell.cellStyle.backColor = '#C00000';
      cell.cellStyle.fontColor = '#FFFFFF';
    }

    // Veriler
    for (int r = 1; r < rows.length; r++) {
      final row = List<String>.from(rows[r].map((e) => e.toString()));
      if (dateIdx != -1 && row.length > dateIdx) {
        row[dateIdx] = _mmddyyToDdmmyy(row[dateIdx]);
      }
      for (int c = 0; c < headers.length; c++) {
        sheet.getRangeByIndex(r + 1, c + 1).setText(row[c]);
      }
    }

    final dir = await getApplicationDocumentsDirectory();
    final excelPath = join(dir.path, fileNameXlsx);
    final bytes = workbook.saveAsStream();
    await File(excelPath).writeAsBytes(bytes, flush: true);
    workbook.dispose();

    log('✅ Excel oluşturuldu: $excelPath', name: tag);
  } catch (e) {
    log('❌ Excel oluşturma hatası: $e', name: tag);
  }
}

/// 🚀 JSON → SQL aktarımı (batch hızlı)
Future<void> importJsonToDatabaseFast() async {
  const tag = 'JSON→SQL Import (Batch)';
  try {
    final dir = await getApplicationDocumentsDirectory();
    final jsonPath = join(dir.path, fileNameJson);
    final file = File(jsonPath);
    if (!await file.exists()) return;

    final db = await DbHelper.instance.database;
    final existing = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $sqlTableName'),
    );
    if ((existing ?? 0) > 0) {
      log(
        '🟢 Veritabanı zaten dolu ($existing kayıt). Tekrar oluşturulmadı.',
        name: tag,
      );
      return;
    }

    final jsonData = jsonDecode(await file.readAsString());
    if (jsonData is! List) return;

    final batch = db.batch();
    for (final record in jsonData) {
      batch.insert(sqlTableName, {
        'netflixItemName': record['Title'] ?? record['Name'] ?? '',
        'watchDate': record['Date'] ?? record['Watched Date'] ?? '',
      });
    }
    await batch.commit(noResult: true);

    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $sqlTableName'),
    );
    log('✅ Batch import tamamlandı ($count kayıt).', name: tag);
  } catch (e) {
    log('❌ Batch import hatası: $e', name: tag);
  }
}

/// 📂 Tüm yedekleri /Download/{appName}/ dizinine kopyalar.
Future<void> copyBackupFilesToDownload() async {
  const tag = 'External Copy';
  try {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      log('❌ Depolama izni verilmedi.', name: tag);
      return;
    }

    final downloadDir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );
    final targetDir = Directory(join(downloadDir, appName));
    if (!await targetDir.exists()) await targetDir.create(recursive: true);

    final internalDir = await getApplicationDocumentsDirectory();
    final files = [fileNameCsv, fileNameJson, fileNameXlsx, fileNameSql];

    for (final name in files) {
      final src = File(join(internalDir.path, name));
      final dest = File(join(targetDir.path, name));
      if (await src.exists()) {
        await src.copy(dest.path);
        log('✅ Kopyalandı: $name → ${targetDir.path}', name: tag);
      } else {
        log('⚠️ Kaynak dosya yok: ${src.path}', name: tag);
      }
    }
    log('🎉 Dosyalar Download dizinine taşındı.', name: tag);
  } catch (e) {
    log('🚨 Kopyalama hatası: $e', name: tag);
  }
}

/// 📤 Download/{appName} dizinindeki dosyaları paylaşır.
Future<void> shareBackupFolder() async {
  const tag = 'External Share';
  try {
    final downloadDir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );
    final folderPath = join(downloadDir, appName);
    final dir = Directory(folderPath);

    if (!await dir.exists()) {
      log('⚠️ Dizin yok: $folderPath', name: tag);
      return;
    }

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
  } catch (e) {
    log('🚨 Paylaşım hatası: $e', name: tag);
  }
}
