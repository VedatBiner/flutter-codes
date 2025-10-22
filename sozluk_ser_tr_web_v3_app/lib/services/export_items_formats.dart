// <📜 ----- lib/services/export_items_formats.dart ----->
/*
  🧩 Word dışa aktarma format yardımcıları (CSV & XLSX)

  NE YAPAR?
  - buildWordsCsvNoId:  List<Word> → UTF-8 BOM 'lu CSV (başlıklar: sirpca,turkce,userEmail)
  - buildWordsXlsxNoId: List<Word> → XLSX (başlık kalın & koyu mavi + beyaz, ilk 3 kolona AutoFilter, auto-fit)

  NOTLAR
  - Bu modül YALNIZCA içerik üretir (String veya Uint8List). Dosyaya kaydetme/indirme
    işlemi üst katmanda (JsonSaver) yapılır.
  - ID alanı istenmediği için her iki formatta da yer almaz.
*/

// 📌 Dart hazır paketleri
import 'dart:typed_data';

/// 📌 Flutter hazır paketleri
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

/// 📌 Yardımcı yüklemeler burada
import '../models/word_model.dart';

/// 📌 CSV üretimi (UTF-8 BOM + başlık) — ID YOK
String buildWordsCsvNoId(List<Word> list) {
  final headers = ['sirpca', 'turkce', 'userEmail'];
  final sb = StringBuffer();
  sb.write('\uFEFF'); // Excel uyumu için BOM
  sb.writeln(headers.map(_csvEscape).join(','));

  for (final w in list) {
    final row = [w.sirpca, w.turkce, w.userEmail].map(_csvEscape).join(',');
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

/// 📌 XLSX üretimi (Syncfusion XlsIO: AutoFilter + başlık stili + auto-fit) — ID YOK
Uint8List buildWordsXlsxNoId(List<Word> list) {
  final wb = xlsio.Workbook();
  final sheet = wb.worksheets[0];

  // Başlıklar
  final headers = ['sirpca', 'turkce', 'userEmail'];

  // 1) Başlık satırı
  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  // 2) Başlık stili
  final headerStyle = wb.styles.add('header');
  headerStyle.bold = true;
  headerStyle.fontColor = '#FFFFFFFF';
  headerStyle.backColor = '#FF0D47A1';
  headerStyle.hAlign = xlsio.HAlignType.center;
  headerStyle.vAlign = xlsio.VAlignType.center;
  sheet.getRangeByIndex(1, 1, 1, headers.length).cellStyle = headerStyle;

  // 2.5) Freeze Panes → 2. satır / 1. sütun (üstteki 1. satırı sabitler)
  sheet.getRangeByIndex(2, 1).freezePanes();
  // Not: İlk sütunu da sabitlemek istersen: sheet.freezePanes(2, 2);

  // 3) Veri satırları
  for (int r = 0; r < list.length; r++) {
    final w = list[r];
    sheet.getRangeByIndex(r + 2, 1).setText(w.sirpca);
    sheet.getRangeByIndex(r + 2, 2).setText(w.turkce);
    sheet.getRangeByIndex(r + 2, 3).setText(w.userEmail);
  }

  final lastRow = 1 + list.length;

  // 4) AutoFilter → A:C
  sheet.autoFilters.filterRange = sheet.getRangeByIndex(1, 1, lastRow, 3);

  // 5) Auto-fit
  sheet.getRangeByIndex(1, 1, lastRow, 3).autoFitColumns();

  final bytes = wb.saveAsStream();
  wb.dispose();
  return Uint8List.fromList(bytes);
}
