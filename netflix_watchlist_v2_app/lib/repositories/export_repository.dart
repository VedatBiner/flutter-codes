// 📁 lib/repositories/export_repository.dart
//
// ============================================================================
// 📦 ExportRepository – Export İş Akışı Yöneticisi
// ============================================================================
//
// Bu repository export sürecinin tamamını yönetir.
//
// Sorumlulukları:
// • Verileri okumak
// • Film + dizi bölümlerini tek listeye dönüştürmek
// • Tarihleri dd/MM/yyyy formatına çevirmek
// • Temp klasör hazırlamak
// • ExportFileService ile dosyaları üretmek
// • Storage izni kontrol etmek
// • Download/{appName} klasörüne dosyaları kopyalamak
// • Temp klasörü temizlemek
//
// Bu yapı sayesinde UI sadece repository çağırır.
// ============================================================================

import 'dart:developer';
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
  final ExportFileService _fileService = ExportFileService();

  // ==========================================================================
  // 🚀 exportAll()
  // ==========================================================================
  // Export işleminin ana giriş noktasıdır.
  //
  // Parametre:
  // • subfolder → Documents altında kullanılacak geçici klasör adı
  //
  // Dönen değer:
  // • ExportItems → UI bildirim ve paylaşım için kullanılır
  //
  Future<ExportItems> exportAll({
    String subfolder = 'netflix_watchlist_temp_export',
  }) async {
    const tag = "export_repository";

    // ----------------------------------------------------------
    // 1️⃣ Temp klasörü hazırla
    // ----------------------------------------------------------
    final docs = await getApplicationDocumentsDirectory();
    final tempDir = Directory(join(docs.path, subfolder));
    await tempDir.create(recursive: true);

    log("📂 Temp export klasörü: ${tempDir.path}", name: tag);

    final tempCsvPath = join(tempDir.path, fileNameCsv);
    final tempJsonPath = join(tempDir.path, fileNameJson);
    final tempExcelPath = join(tempDir.path, fileNameXlsx);

    try {
      // --------------------------------------------------------
      // 2️⃣ Kaynak veriyi oku
      // --------------------------------------------------------
      final parsed = await CsvParser.parseCsvFast();

      // --------------------------------------------------------
      // 3️⃣ Tüm kayıtları tek listeye çevir
      // --------------------------------------------------------
      final allItems = _collectAllItems(parsed.movies, parsed.series);
      final count = allItems.length;

      log("📌 Export edilecek kayıt: $count", name: tag);

      // --------------------------------------------------------
      // 4️⃣ Dosyaları temp klasörde üret
      // --------------------------------------------------------
      await _fileService.exportCsv(allItems, tempCsvPath);
      log("📄 TEMP CSV: $tempCsvPath", name: tag);

      await _fileService.exportJson(allItems, tempJsonPath);
      log("📄 TEMP JSON: $tempJsonPath", name: tag);

      await _fileService.exportExcel(allItems, tempExcelPath);
      log("📊 TEMP XLSX: $tempExcelPath", name: tag);

      // --------------------------------------------------------
      // 5️⃣ Download klasörüne kopyala
      // --------------------------------------------------------
      final outputPaths = await _copyToDownload(
        tempCsvPath: tempCsvPath,
        tempJsonPath: tempJsonPath,
        tempExcelPath: tempExcelPath,
      );

      log("✅ Export tamamlandı", name: tag);

      return ExportItems(
        count: count,
        csvPath: outputPaths.csvPath,
        jsonPath: outputPaths.jsonPath,
        excelPath: outputPaths.excelPath,
      );
    } finally {
      // --------------------------------------------------------
      // 6️⃣ Temp klasörü temizle
      // --------------------------------------------------------
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
        log("🧹 Temp export klasörü silindi: ${tempDir.path}", name: tag);
      }
    }
  }

  // ==========================================================================
  // 📥 _collectAllItems()
  // ==========================================================================
  // Film ve dizi bölümlerini tek bir NetflixItem listesine çevirir.
  //
  // Önemli:
  // • Tarih burada dd/MM/yyyy formatına çevrilir
  //
  List<NetflixItem> _collectAllItems(
      List<NetflixItem> movies,
      List<SeriesGroup> series,
      ) {
    final allItems = <NetflixItem>[];

    // Filmleri ekle
    for (final movie in movies) {
      allItems.add(
        NetflixItem(
          title: movie.title,
          date: _normalizeDate(movie.date),
          year: movie.year,
          genre: movie.genre,
          rating: movie.rating,
          poster: movie.poster,
          type: movie.type,
          originalTitle: movie.originalTitle,
          imdbId: movie.imdbId,
        ),
      );
    }

    // Dizi bölümlerini ekle
    for (final seriesGroup in series) {
      for (final season in seriesGroup.seasons) {
        for (final episode in season.episodes) {
          allItems.add(
            NetflixItem(
              title: episode.title,
              date: _normalizeDate(episode.date),
            ),
          );
        }
      }
    }

    return allItems;
  }

  // ==========================================================================
  // 📅 _normalizeDate()
  // ==========================================================================
  // CSV parser içindeki parseDate + formatDate yardımıyla tarihi
  // dd/MM/yyyy formatına çevirir.
  //
  // Örnek:
  // 03/04/24  ->  04/03/2024
  //
  String _normalizeDate(String rawDate) {
    return formatDate(parseDate(rawDate));
  }

  // ==========================================================================
  // 📂 _copyToDownload()
  // ==========================================================================
  // Temp klasörde üretilen dosyaları Download/{appName} içine kopyalar.
  //
  // Önce storage izni kontrol edilir.
  //
  Future<_ExportOutputPaths> _copyToDownload({
    required String tempCsvPath,
    required String tempJsonPath,
    required String tempExcelPath,
  }) async {
    const tag = "export_repository";

    final ok = await ensureStoragePermission();
    if (!ok) {
      throw Exception(
        "Depolama izni verilmedi (Download kopyalama yapılamadı).",
      );
    }

    final downloadDir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );

    if (downloadDir.isEmpty) {
      throw Exception("Download klasörü bulunamadı.");
    }

    final downloadAppDir = Directory(join(downloadDir, appName));
    await downloadAppDir.create(recursive: true);

    final outCsvPath = join(downloadAppDir.path, fileNameCsv);
    final outJsonPath = join(downloadAppDir.path, fileNameJson);
    final outExcelPath = join(downloadAppDir.path, fileNameXlsx);

    await File(tempCsvPath).copy(outCsvPath);
    await File(tempJsonPath).copy(outJsonPath);
    await File(tempExcelPath).copy(outExcelPath);

    log("📥 Download kopyaları hazır:", name: tag);
    log("✅ CSV: $outCsvPath", name: tag);
    log("✅ JSON: $outJsonPath", name: tag);
    log("✅ XLSX: $outExcelPath", name: tag);

    return _ExportOutputPaths(
      csvPath: outCsvPath,
      jsonPath: outJsonPath,
      excelPath: outExcelPath,
    );
  }
}

// ============================================================================
// 📎 _ExportOutputPaths
// ============================================================================
// Repository iç kullanımına özel yardımcı model.
// ============================================================================

class _ExportOutputPaths {
  final String csvPath;
  final String jsonPath;
  final String excelPath;

  _ExportOutputPaths({
    required this.csvPath,
    required this.jsonPath,
    required this.excelPath,
  });
}