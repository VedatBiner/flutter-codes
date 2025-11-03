// 📃 <----- lib/utils/fc_files/excel_helper.dart ----->
//
// 🎬 Netflix Film List App
// -----------------------------------------------------------
// Bu dosya, asset içindeki CSV verisini okuyarak
// Syncfusion XLSX formatında biçimli bir Excel dosyası oluşturur.
//
// 🧩 Adımlar:
//   1️⃣ assets/database klasöründen CSV dosyasını okur.
//   2️⃣ CSV verilerini ayrıştırır ve tarihleri "aa/gg/yy" → "gg/aa/yy" formatına çevirir.
//   3️⃣ Başlıkları koyu ve renklendirilmiş şekilde Excel ’e yazar.
//   4️⃣ Verileri satır satır ekler.
//   5️⃣ Tüm sütun genişliklerini otomatik ayarlar (auto-fit).
//   6️⃣ Excel dosyasını uygulamanın app_flutter dizinine kaydeder.
//
// 📁 Çıktı dosyası:
//   /data/user/0/<package_name>/app_flutter/netflix_list_backup.xlsx
//
// 🔧 Kütüphaneler:
//   - syncfusion_flutter_xlsio
//   - csv
//   - path_provider
//   - path
//
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../../constants/file_info.dart';
import 'date_formatter.dart';

/// 📊 Asset içindeki CSV 'yi okuyup, tarih formatlarını düzelterek
/// biçimli bir Excel (XLSX) dosyası oluşturur.
Future<void> createExcelFromAssetCsvSyncfusion() async {
  const tag = 'ExcelHelper';

  try {
    // 1️⃣ Asset CSV dosyasını oku
    const assetCsvPath = 'assets/database/$assetsFileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    // 2️⃣ CSV satırlarını ayrıştır
    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvRaw);

    if (rows.isEmpty) {
      log('⚠️ Asset CSV boş veya okunamadı.', name: tag);
      return;
    }

    // 3️⃣ Başlıkları ve tarih sütunu index ’ini belirle
    final headers = rows.first.map((e) => e.toString().trim()).toList();
    final dateIdx = headers.indexWhere(
      (h) => h.toLowerCase() == 'date' || h.toLowerCase() == 'watched date',
    );

    // 4️⃣ Yeni Excel çalışma kitabı oluştur
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];
    sheet.name = 'Netflix_Data';

    // -----------------------------------------------------------
    // 🧱 Başlık satırını yaz ve biçimlendir
    // -----------------------------------------------------------
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(1, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#1E1E1E'; // koyu gri arka plan
      cell.cellStyle.fontColor = '#FFFFFF'; // beyaz yazı
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
      cell.cellStyle.vAlign = xlsio.VAlignType.center;
    }

    // -----------------------------------------------------------
    // 🧩 Verileri satır satır ekle
    // -----------------------------------------------------------
    for (int r = 1; r < rows.length; r++) {
      final row = List<String>.from(rows[r].map((e) => e.toString()));
      if (row.length > dateIdx && dateIdx != -1) {
        row[dateIdx] = formatUsToEuDate(row[dateIdx].toString());
      }
      for (int c = 0; c < headers.length; c++) {
        sheet.getRangeByIndex(r + 1, c + 1).setText(row[c]);
      }
    }

    // -----------------------------------------------------------
    // 🧮 Sütun genişliklerini otomatik ayarla
    // -----------------------------------------------------------
    for (int c = 1; c <= headers.length; c++) {
      sheet.autoFitColumn(c);
    }

    // -----------------------------------------------------------
    // 💾 Excel dosyasını kaydet
    // -----------------------------------------------------------
    final directory = await getApplicationDocumentsDirectory();
    final excelPath = join(directory.path, fileNameXlsx);

    // Eğer dosya zaten varsa, yeniden yazma
    if (!await File(excelPath).exists()) {
      final bytes = workbook.saveAsStream();
      await File(excelPath).writeAsBytes(bytes, flush: true);
      workbook.dispose();
      log('✅ Excel dosyası oluşturuldu: $excelPath', name: tag);
      log('📦 Satır sayısı (başlık dahil): ${rows.length}', name: tag);
    } else {
      log('ℹ️ Excel zaten mevcut, yeniden oluşturulmadı.', name: tag);
    }
  } catch (e, st) {
    log(
      '❌ CSV→Excel (Syncfusion) hatası: $e',
      name: tag,
      error: e,
      stackTrace: st,
    );
  }
}
