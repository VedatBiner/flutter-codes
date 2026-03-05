// ============================================================================
// 📦 ExportRepository
// ============================================================================
//
// Repository Pattern içinde en üst veri katmanıdır.
//
// Görevleri:
//
//   1️⃣ CSV parser ile veriyi okumak
//   2️⃣ ExportFileService kullanarak dosyaları üretmek
//   3️⃣ Download klasörüne kopyalamak
//   4️⃣ UI 'a ExportItems sonucu döndürmek
//
// Repository UI ile Service arasında köprü görevi görür.
// ============================================================================

import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../models/export_items.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../services/export_file_service.dart';
import '../utils/csv_parser.dart';
import '../utils/storage_permission_helper.dart';

class ExportRepository {

  final ExportFileService _service = ExportFileService();

  Future<ExportItems> exportAll() async {

    // ------------------------------------------------------------------------
    // 1️⃣ CSV parser ile veriyi oku
    // ------------------------------------------------------------------------
    final parsed = await CsvParser.parseCsvFast();

    final List<NetflixItem> movies = parsed.movies;
    final List<SeriesGroup> series = parsed.series;

    final items = <NetflixItem>[];

    items.addAll(movies);

    for (final s in series) {
      for (final season in s.seasons) {
        for (final ep in season.episodes) {
          items.add(
            NetflixItem(
              title: ep.title,
              date: ep.date,
            ),
          );
        }
      }
    }

    final count = items.length;

    // ------------------------------------------------------------------------
    // 2️⃣ TEMP klasör oluştur
    // ------------------------------------------------------------------------
    final docs = await getApplicationDocumentsDirectory();
    final tempDir = Directory(join(docs.path, "export_temp"));

    await tempDir.create(recursive: true);

    final tempCsv = join(tempDir.path, fileNameCsv);
    final tempJson = join(tempDir.path, fileNameJson);
    final tempExcel = join(tempDir.path, fileNameXlsx);

    // ------------------------------------------------------------------------
    // 3️⃣ Dosyaları üret
    // ------------------------------------------------------------------------
    await _service.exportCsv(items, tempCsv);
    await _service.exportJson(items, tempJson);
    await _service.exportExcel(items, tempExcel);

    // ------------------------------------------------------------------------
    // 4️⃣ Download klasörüne kopyala
    // ------------------------------------------------------------------------
    final ok = await ensureStoragePermission();

    if (!ok) {
      throw Exception("Storage izni verilmedi");
    }

    final downloadDir =
    await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );

    final appDir = Directory(join(downloadDir, appName));

    await appDir.create(recursive: true);

    final outCsv = join(appDir.path, fileNameCsv);
    final outJson = join(appDir.path, fileNameJson);
    final outExcel = join(appDir.path, fileNameXlsx);

    await File(tempCsv).copy(outCsv);
    await File(tempJson).copy(outJson);
    await File(tempExcel).copy(outExcel);

    // ------------------------------------------------------------------------
    // 5️⃣ TEMP klasörü sil
    // ------------------------------------------------------------------------
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }

    return ExportItems(
      count: count,
      csvPath: outCsv,
      jsonPath: outJson,
      excelPath: outExcel,
    );
  }
}