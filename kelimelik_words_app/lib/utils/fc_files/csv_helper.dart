// 📃 <----- lib/utils/fc_files/csv_helper.dart ----->
//
// CSV üretimi ARTIK TEK MERKEZDEN yapılır
// -----------------------------------------------------------
// • CSV SADECE veritabanından üretilir
// • Asset CSV cihaz CSV 'yi ASLA EZMEZ
// • Tarih bilgisi DB (created_at) sütunundan okunur
// • CSV başlığı: Kelime,Anlam,Tarih
// -----------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/file_info.dart';
import '../../db/db_helper.dart';

const _tag = "csv_helper";

/// ---------------------------------------------------------------------------
/// 📌 DB → CSV EXPORT (TEK DOĞRU CSV KAYNAĞI)
/// ---------------------------------------------------------------------------
///
/// • Kelime, Anlam ve Tarih sütunları oluşturulur
/// • created_at NULL veya boş ise varsayılan tarih yazılır
/// • CSV her zaman yeniden üretilir
///
Future<String> exportCsvFromDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, fileNameCsv);

  final words = await DbHelper.instance.getRecords();

  final buffer = StringBuffer();

  // 🔹 CSV başlık
  buffer.writeln("Kelime,Anlam,Tarih");

  for (final w in words) {
    final kelime = w.word.replaceAll(",", "");
    final anlam = w.meaning.replaceAll(",", "");

    // 🔹 Tarih DB ’den okunur
    final tarih = (w.createdAt != null && w.createdAt!.trim().isNotEmpty)
        ? w.createdAt!
        : "15.12.2025";

    buffer.writeln("$kelime,$anlam,$tarih");
  }

  await File(path).writeAsString(buffer.toString());

  log("✅ CSV DB ’den üretildi → ${words.length} kayıt", name: _tag);

  return path;
}
