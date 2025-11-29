// 📃 <----- lib/services/export_items.dart ----->
//
// UI → backup_notification_helper → exportItemsToFileFormats()
// Bu dosya, file_exporter.dart dosyasındaki runFullExport() fonksiyonunu çağırır.
// Sonuçları ExportItems modeli halinde UI 'ya döndürür.
//

import '../../constants/file_info.dart';
import '../file_exporter.dart';

class ExportItems {
  final int count;
  final String? jsonPath;
  final String? csvPath;
  final String? xlsxPath;
  final String? sqlPath;
  final String? zipPath;

  ExportItems({
    required this.count,
    this.jsonPath,
    this.csvPath,
    this.xlsxPath,
    this.sqlPath,
    this.zipPath,
  });
}

/// 📌 Tüm yedekleme akışını tetikleyen fonksiyon.
/// SQL → CSV → XLSX → JSON → ZIP
Future<ExportItems> exportItemsToFileFormats({String? subfolder}) async {
  final result = await runFullExport(subfolder: subfolder);

  return ExportItems(
    count: result['count'] ?? 0,
    jsonPath: result[fileNameJson],
    csvPath: result[fileNameCsv],
    xlsxPath: result[fileNameXlsx],
    sqlPath: result[fileNameSql],
    zipPath: result[fileNameZip],
  );
}
