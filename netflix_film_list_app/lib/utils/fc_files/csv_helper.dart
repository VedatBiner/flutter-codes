// 📃 <----- lib/utils/fc_files/csv_helper.dart ----->
//
// 🧩 CSV Helper – Asset içindeki CSV ’den cihaz içi CSV üretici
//
// Amaç:
// -----------------------------------------------------------
//  • Asset klasöründe bulunan CSV dosyasını okur.
//  • Tarih formatlarını ABD biçiminden (MM/DD/YY) Avrupa biçimine (DD/MM/YY) çevirir.
//  • Dönüştürülmüş CSV ’yi cihazın "application documents" dizinine kaydeder.
//  • Eğer CSV zaten varsa yeniden oluşturmaz.
//
// Kullanım:
// -----------------------------------------------------------
// import 'fc_files/csv_helper.dart';
//
// await createDeviceCsvFromAssetWithDateFix();
//
// Gereken diğer dosyalar:
//  • constants/file_info.dart
//  • fc_files/date_formatter.dart (tarih dönüşüm fonksiyonu)
//
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';
import 'date_formatter.dart';

/// 📦 Asset CSV → Cihaz içi CSV dönüştürücü.
///
/// Bu fonksiyon:
///   1️⃣ `assets/database/$assetsFileNameCsv` dosyasını okur.
///   2️⃣ Tarih sütunlarını "aa/gg/yy" → "gg/aa/yy" formatına çevirir.
///   3️⃣ Düzeltilmiş CSV ’yi uygulama dizinine kaydeder.
///   4️⃣ Eğer dosya zaten varsa, yeniden yazmaz.
///
/// Örnek çıktı yolu:
///   /data/user/0/<package>/app_flutter/netflix_list_backup.csv
Future<void> createDeviceCsvFromAssetWithDateFix() async {
  const tag = 'csv_helper';

  try {
    // 1️⃣ Asset CSV dosyasını oku
    const assetCsvPath = 'assets/database/$assetsFileNameCsv';
    final csvRaw = await rootBundle.loadString(assetCsvPath);

    // 2️⃣ Satırlara dönüştür
    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvRaw);

    if (rows.isEmpty) {
      log('⚠️ Asset CSV boş!', name: tag);
      return;
    }

    // 3️⃣ Başlıkları ve tarih sütununu bul
    final headers = rows.first.map((e) => e.toString()).toList();
    final dateIdx = headers.indexWhere(
      (h) =>
          h.trim().toLowerCase() == 'date' ||
          h.trim().toLowerCase() == 'watched date',
    );

    // 4️⃣ Yeni CSV verisini oluştur
    final List<List<dynamic>> out = [headers];

    for (int i = 1; i < rows.length; i++) {
      final row = List<dynamic>.from(rows[i]);

      if (row.length > dateIdx && dateIdx != -1) {
        row[dateIdx] = formatUsToEuDate(row[dateIdx].toString());
      }

      out.add(row);
    }

    // 5️⃣ CSV string olarak yazıya dönüştür
    final csvOut = const ListToCsvConverter().convert(out);

    // 6️⃣ Çıkış dizinine kaydet
    final directory = await getApplicationDocumentsDirectory();
    final outPath = join(directory.path, fileNameCsv);
    final outFile = File(outPath);

    if (!await outFile.exists()) {
      await outFile.writeAsString(csvOut);
      log('✅ CSV oluşturuldu: $outPath', name: tag);
      log('📦 Satır sayısı (başlık dahil): ${out.length}', name: tag);
    } else {
      log('ℹ️ CSV zaten mevcut, yeniden oluşturulmadı.', name: tag);
    }
  } catch (e, st) {
    log('❌ CSV oluşturma hatası: $e', name: tag, error: e, stackTrace: st);
  }
}
