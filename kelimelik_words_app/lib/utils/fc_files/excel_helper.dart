// 📃 <----- lib/utils/fc_files/excel_helper.dart ----->
//
// Excel oluşturma işlemi
// -----------------------------------------------------------
// • Bu sürümde Excel dosyası HER ZAMAN yeniden oluşturulur.
// • CSV ile eşleştiğinden emin olmak için aynı verilerden üretilir.
//
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../../constants/file_info.dart';

/// 📌 Asset CSV 'den cihazda Excel dosyası oluşturur.
/// NOT: Bu sürümde cihazda eski Excel olsa bile *her zaman* yeniden oluşturulur.
Future<void> createExcelFromAssetCsvSyncfusion() async {
  const tag = 'excel_helper';

  try {
    final directory = await getApplicationDocumentsDirectory();
    final excelPath = join(directory.path, fileNameXlsx);

    // 🔄 Eski Excel varsa silelim (güncel olması için)
    final file = File(excelPath);
    if (await file.exists()) {
      await file.delete();
    }

    // 📥 CSV dosyasını cihazdan oku
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

    int rowIndex = 1;

    for (var line in rows) {
      final cells = line.split(',');
      for (int col = 0; col < cells.length; col++) {
        sheet.getRangeByIndex(rowIndex, col + 1).setText(cells[col].trim());
      }
      rowIndex++;
    }

    final bytes = workbook.saveAsStream();
    workbook.dispose();

    await File(excelPath).writeAsBytes(bytes);

    // İlk satır başlık olduğu için kayıt sayısı = rows.length - 1
    final recordCount = rows.isNotEmpty ? rows.length - 1 : 0;

    log('📘 Excel yeniden oluşturuldu. Kayıt sayısı: $recordCount', name: tag);
  } catch (e, st) {
    log('❌ Excel oluşturma hatası: $e', name: tag, error: e, stackTrace: st);
  }
}
