// <📜 ----- lib/services/export_words.dart ----->
/*
  📦 Firestore → JSON + CSV dışa aktarma (Word modeli ile, web + mobil/desktop uyumlu)

  NE YAPAR?
  1) `collectionName` koleksiyonunu `withConverter<Word>` ile **tipli** okur.
  2) `FieldPath.documentId` ile **sayfalı** olarak TÜM belgeleri çeker (pageSize).
  3) Aynı veriyle iki çıktı üretir:
     • JSON: pretty-print, dosya adı `fileNameJson`
     • CSV : BOM (UTF-8) + başlık (id,sirpca,turkce,userEmail), dosya adı `fileNameCsv`
  4) Web’de tarayıcı indirmesi, Android/Desktop’ta **Downloads**, iOS’ta **Belgeler + Paylaş**.

  GERİ DÖNÜŞ:
  - İki dosyanın da kaydedildiği tam yolları ve istatistikleri döndürür.
*/

import 'dart:convert';
import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/file_info.dart';
import '../models/word_model.dart';
import '../utils/json_saver.dart';

class ExportResult {
  final String jsonPath;
  final String csvPath;
  final int count;
  final int elapsedMs;
  const ExportResult({
    required this.jsonPath,
    required this.csvPath,
    required this.count,
    required this.elapsedMs,
  });
}

Future<ExportResult> exportWordsToJsonAndCsv({
  int pageSize = 1000,
  String? subfolder = 'kelimelik_words_app',
}) async {
  final sw = Stopwatch()..start();
  final List<Word> all = [];

  try {
    final col = FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<Word>(
          fromFirestore: Word.fromFirestore,
          toFirestore: (w, _) => w.toFirestore(),
        );

    Query<Word> base = col.orderBy(FieldPath.documentId);
    String? lastId;

    while (true) {
      var q = base.limit(pageSize);
      if (lastId != null) q = q.startAfter([lastId]);

      final snap = await q.get();
      if (snap.docs.isEmpty) break;

      for (final d in snap.docs) {
        all.add(d.data());
      }

      lastId = snap.docs.last.id;
      if (snap.docs.length < pageSize) break;
    }

    // --- JSON
    final jsonStr = const JsonEncoder.withIndent(
      '  ',
    ).convert(all.map((w) => w.toJson(includeId: true)).toList());
    final jsonSavedAt = await JsonSaver.saveToDownloads(
      jsonStr,
      fileNameJson,
      subfolder: subfolder,
    );

    // --- CSV (UTF-8 BOM + başlık satırı)
    final csvStr = _buildCsv(all);
    final csvSavedAt = await JsonSaver.saveTextToDownloads(
      csvStr,
      fileNameCsv,
      contentType: 'text/csv; charset=utf-8',
      subfolder: subfolder,
    );

    sw.stop();
    log(
      '📦 Export tamam: ${all.length} kayıt, ${sw.elapsedMilliseconds} ms',
      name: collectionName,
    );

    return ExportResult(
      jsonPath: jsonSavedAt,
      csvPath: csvSavedAt,
      count: all.length,
      elapsedMs: sw.elapsedMilliseconds,
    );
  } catch (e, st) {
    sw.stop();
    log(
      '❌ Hata (exportWordsToJsonAndCsv): $e',
      name: collectionName,
      error: e,
      stackTrace: st,
      level: 1000,
    );
    rethrow;
  }
}

// CSV üretimi — Excel uyumu için UTF-8 BOM eklenir.
String _buildCsv(List<Word> list) {
  // Başlıklar
  final headers = ['id', 'sirpca', 'turkce', 'userEmail'];
  final sb = StringBuffer();

  // UTF-8 BOM (Excel için)
  sb.write('\uFEFF');

  // Başlık satırı
  sb.writeln(headers.map(_csvEscape).join(','));

  // Satırlar
  for (final w in list) {
    final row = [
      w.id ?? '',
      w.sirpca,
      w.turkce,
      w.userEmail,
    ].map(_csvEscape).join(',');
    sb.writeln(row);
  }
  return sb.toString();
}

String _csvEscape(String v) {
  final needsQuotes =
      v.contains(',') ||
      v.contains('"') ||
      v.contains('\n') ||
      v.contains('\r');
  var out = v.replaceAll('"', '""');
  return needsQuotes ? '"$out"' : out;
}
