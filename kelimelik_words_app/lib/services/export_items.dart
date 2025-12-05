// 📃 <----- lib/services/export_items.dart ----->

import '../constants/file_info.dart';
import '../utils/file_exporter.dart';

class ExportItems {
  final int count;
  final String csvPath;
  final String jsonPath;
  final String xlsxPath;
  final String sqlPath;
  final String zipPath;

  ExportItems({
    required this.count,
    required this.csvPath,
    required this.jsonPath,
    required this.xlsxPath,
    required this.sqlPath,
    required this.zipPath,
  });
}

/// UI → backup_notification_helper çağırır → burası file_exporter'ı tetikler
Future<ExportItems> exportItemsToFileFormats({String? subfolder}) async {
  final map = await runFullExport(subfolder: subfolder);

  return ExportItems(
    count: int.tryParse(map["count"] ?? "0") ?? 0,
    csvPath: map[fileNameCsv] ?? "",
    jsonPath: map[fileNameJson] ?? "",
    xlsxPath: map[fileNameXlsx] ?? "",
    sqlPath: map[fileNameSql] ?? "",
    zipPath: map[fileNameZip] ?? "",
  );
}
