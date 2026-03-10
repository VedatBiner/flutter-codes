// 📁 <----- lib/models/filter_option.dart ----->
//
// ============================================================================
// 🔎 FilterOption – İçerik Filtreleme Seçenekleri
// ============================================================================
//
// Bu enum, uygulamada kullanılacak filtre seçeneklerini temsil eder.
//
// Neden enum?
// • Tip güvenliği sağlar
// • String yazım hatalarını önler
// • UI ve filtre motoru arasında ortak dil oluşturur
//
// ============================================================================

enum FilterOption {
  all,
  movies,
  series,
  last30days,
}

/// ============================================================================
/// 🧩 FilterOptionLabel Extension
/// ============================================================================
///
/// Enum değerlerini kullanıcıya gösterilecek metne çevirir.
///
/// Böylece UI tarafında sabit string yazmaya gerek kalmaz.
/// ============================================================================
extension FilterOptionLabel on FilterOption {
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