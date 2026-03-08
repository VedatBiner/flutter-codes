// 📁 <----- lib/models/filter_option.dart ----->
//
// ============================================================================
// 🔎 FilterOption – İçerik Filtreleme Seçenekleri
// ============================================================================
//
// Bu enum uygulamada kullanılacak filtre seçeneklerini temsil eder.
//
// Kullanıldığı yerler:
//
// • FilterChips widget
// • Liste filtreleme fonksiyonları
// • Arama sonuçlarını sınırlamak
//
// ============================================================================

enum FilterOption { all, movies, series, last30days }

/// ============================================================================
/// 🧩 FilterOptionLabel Extension
/// ============================================================================
///
/// Bu extension FilterOption enum 'una ek davranış kazandırır.
///
/// Amaç:
/// Enum değerlerini UI ’da gösterilecek metinlere çevirmek.
///
/// Örnek:
///
/// FilterOption.movies.label  -> "Filmler"
///
/// Bu sayede UI tarafında switch-case yazmaya gerek kalmaz.
/// ============================================================================
extension FilterOptionLabel on FilterOption {
  /// UI 'da gösterilecek metni döndürür
  String get label {
    switch (this) {
      case FilterOption.all:
        return "Tümü";

      case FilterOption.movies:
        return "Filmler";

      case FilterOption.series:
        return "Diziler";

      case FilterOption.last30days:
        return "Son 30 Gün";
    }
  }
}
