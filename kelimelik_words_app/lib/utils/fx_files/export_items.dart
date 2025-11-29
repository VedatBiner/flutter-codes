// 📃 <----- lib/services/export_items.dart ----->

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

Future<ExportItems> exportItemsToFileFormats({String? subfolder}) async {
  final result = await runFullExport(subfolder: subfolder);

  return ExportItems(
    count: int.tryParse(result['count'] ?? "0") ?? 0, // ✔ DÜZELTİLDİ
    jsonPath: result[fileNameJson],
    csvPath: result[fileNameCsv],
    xlsxPath: result[fileNameXlsx],
    sqlPath: result[fileNameSql],
    zipPath: result[fileNameZip],
  );
}
