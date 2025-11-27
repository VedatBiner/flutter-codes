// 📃 <----- lib/utils/fc_files/fc_report.dart ----->
//
// CSV / JSON / SQL tutarlılık raporu
// --------------------------------------------
// • CSV kayıt sayısı
// • JSON kayıt sayısı
// • SQL kayıt sayısı
// • TUTARSIZLIK kontrolü
// --------------------------------------------

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';
import '../../db/db_helper.dart';

const tag = "file_report";

/// CSV - JSON - SQL tutarlılık raporu
Future<void> runConsistencyReport() async {
  final directory = await getApplicationDocumentsDirectory();
  final csvPath = join(directory.path, fileNameCsv);
  final jsonPath = join(directory.path, fileNameJson);

  // 📜 CSV oku
  final csvRaw = await File(csvPath).readAsString();
  final csvLines = csvRaw
      .replaceAll("\r\n", "\n")
      .replaceAll("\r", "\n")
      .split("\n")
      .where((e) => e.trim().isNotEmpty)
      .toList();

  final csvCount = csvLines.length - 1;

  // 📜 JSON oku
  final jsonList =
      jsonDecode(await File(jsonPath).readAsString()) as List<dynamic>;
  final jsonCount = jsonList.length;

  // 📜 SQL say
  final sqlCount = await DbHelper.instance.countRecords();

  // 📊 RAPOR
  log(logLine, name: tag);
  log("📊 CSV: $csvCount | JSON: $jsonCount | SQL: $sqlCount", name: tag);

  if (csvCount == jsonCount && jsonCount == sqlCount) {
    log("✅ TUTARLI", name: tag);
  } else {
    log("❌ TUTARSIZLIK VAR", name: tag);
  }

  log(logLine, name: tag);
}
