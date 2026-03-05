// ============================================================================
// 📦 ExportItems Model
// ============================================================================
//
// Export işlemi tamamlandıktan sonra UI katmanına döndürülen veri modelidir.
//
// İçerdiği bilgiler:
//
//   • count      → export edilen toplam kayıt sayısı
//   • csvPath    → Download klasöründeki CSV dosyasının yolu
//   • jsonPath   → Download klasöründeki JSON dosyasının yolu
//   • excelPath  → Download klasöründeki XLSX dosyasının yolu
//
// UI bu verileri:
//
//   • bildirim gösterme
//   • dosya paylaşma
//   • loglama
//
// işlemleri için kullanır.
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