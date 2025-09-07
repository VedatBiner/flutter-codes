// <📜 ----- lib/services/export_items_format.dart ----->
/*
  🧩 Malzeme dışa aktarma format yardımcıları (CSV & XLSX)

  NE YAPAR?
  - buildWordsCsvNoId:  List<Malzeme> → UTF-8 BOM'lu CSV (başlıklar: Malzeme, Açıklama, Miktar)
  - buildWordsXlsxNoId: List<Malzeme> → XLSX (başlık stili, Freeze Panes, AutoFilter, auto-fit)
  - miktar alanı her zaman TAM SAYI (int) olarak yazılır.

  NOTLAR
  - Bu modül YALNIZCA içerik üretir (String veya Uint8List). Dosyaya kaydetme/indirme
    işlemi üst katmanda yapılır.
*/

// 📌 Dart hazır paketleri
import 'dart:typed_data';

// 📌 3rd party
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

// 📌 Proje bağımlılıkları
import '../models/malzeme_model.dart';

/// 📌 CSV üretimi (UTF-8 BOM + başlık) — ID YOK — miktar = int
String buildWordsCsvNoId(List<Malzeme> list) {
  final headers = ['Malzeme', 'Açıklama', 'Miktar'];
  final sb = StringBuffer();

  // Excel uyumu için BOM (UTF-8)
  sb.write('\uFEFF');
  sb.writeln(headers.map(_csvEscape).join(','));

  for (final w in list) {
    // miktarı kesin int 'e çevir
    final int qty = (w.miktar is int)
        ? (w.miktar as int)
        : (w.miktar as num).toInt();

    final row = <String>[
      w.malzeme, // (nullable ise: w.malzeme ?? '')
      w.aciklama ?? '', // String? → String
      qty.toString(), // int → String
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
  final out = v.replaceAll('"', '""');
  return needsQuotes ? '"$out"' : out;
}

/// 📌 XLSX üretimi (Freeze Panes + başlık stili + AutoFilter + auto-fit) — ID YOK — miktar = int
Uint8List buildWordsXlsxNoId(List<Malzeme> list) {
  final wb = xlsio.Workbook();
  final sheet = wb.worksheets[0];

  // Başlıklar
  final headers = ['Malzeme', 'Açıklama', 'Miktar'];
  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  // Başlık stili
  final headerStyle = wb.styles.add('header');
  headerStyle.bold = true;
  headerStyle.fontColor = '#FFFFFFFF';
  headerStyle.backColor = '#FF0D47A1';
  headerStyle.hAlign = xlsio.HAlignType.center;
  headerStyle.vAlign = xlsio.VAlignType.center;
  sheet.getRangeByIndex(1, 1, 1, headers.length).cellStyle = headerStyle;

  // Freeze Panes
  sheet.getRangeByIndex(2, 1).freezePanes();

  // --- Veri satırları + max uzunluk hesabı (Miktar sütunu için) ---
  int maxQtyChars = headers[2].length; // "Miktar" = 6
  for (int r = 0; r < list.length; r++) {
    final w = list[r];

    // Malzeme
    sheet.getRangeByIndex(r + 2, 1).setText(w.malzeme);

    // Açıklama (wrap)
    final descCell = sheet.getRangeByIndex(r + 2, 2);
    descCell.setText(w.aciklama ?? '');
    descCell.cellStyle.wrapText = true;

    // Miktar (int olarak)
    final int qty = (w.miktar is int)
        ? (w.miktar as int)
        : (w.miktar as num).toInt();
    final qtyCell = sheet.getRangeByIndex(r + 2, 3);
    qtyCell.setNumber(qty.toDouble());
    qtyCell.numberFormat = '0';

    // En uzun miktar karakter sayısını takip et
    final len = qty.toString().length;
    if (len > maxQtyChars) maxQtyChars = len;
  }

  final lastRow = 1 + list.length;

  // AutoFilter
  sheet.autoFilters.filterRange = sheet.getRangeByIndex(1, 1, lastRow, 3);

  // Auto-fit tüm sütunlar
  sheet.getRangeByIndex(1, 1, lastRow, 3).autoFitColumns();

  // Açıklama sütununu biraz genişlet (görünürlük için)
  sheet.getRangeByIndex(1, 2, lastRow, 2).columnWidth = 40;

  // 🔧 Miktar sütununu manuel ayarla:
  // karakter tabanlı genişlik ~ karakter sayısı + küçük bir pay
  final double qtyWidth = (maxQtyChars + 2).toDouble(); // +2 küçük tampon
  sheet.getRangeByIndex(1, 3, lastRow, 3).columnWidth = qtyWidth;

  final bytes = wb.saveAsStream();
  wb.dispose();
  return Uint8List.fromList(bytes);
}
