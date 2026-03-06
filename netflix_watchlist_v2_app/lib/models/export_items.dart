// 📁 lib/models/export_items.dart
//
// ============================================================================
// 📦 ExportItems – Export Sonuç Modeli
// ============================================================================
//
// Bu model, export işlemi tamamlandıktan sonra UI katmanına döndürülen
// sonucu temsil eder.
//
// İçerdiği bilgiler:
// • count     → toplam export edilen kayıt sayısı
// • csvPath   → Download klasöründeki CSV dosya yolu
// • jsonPath  → Download klasöründeki JSON dosya yolu
// • excelPath → Download klasöründeki XLSX dosya yolu
//
// Bu model bildirim, paylaşım ve loglama işlemlerinde kullanılır.
// ============================================================================

class ExportItems {
  final int count;
  final String csvPath;
  final String jsonPath;
  final String excelPath;

  ExportItems({
    required this.count,
    required this.csvPath,
    required this.jsonPath,
    required this.excelPath,
  });
}