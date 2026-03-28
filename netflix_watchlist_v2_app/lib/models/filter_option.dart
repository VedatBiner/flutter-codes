// 📁 <----- lib/models/filter_option.dart ----->
//
// ============================================================================
// 🔎 FilterOption – İçerik Filtreleme Seçenekleri
// ============================================================================
//
// Bu dosya uygulamada kullanılacak filtre seçeneklerini tanımlayan
// enum yapısını içerir.
//
// ---------------------------------------------------------------------------
// 🎯 Amaç
// ---------------------------------------------------------------------------
// Kullanıcının içerikleri farklı kriterlere göre filtreleyebilmesini sağlamak.
//
// Bu filtreler genellikle:
//
// • chip butonları
// • dropdown menüler
// • toggle seçenekleri
//
// gibi UI bileşenlerinde kullanılır.
//
// ---------------------------------------------------------------------------
// 🧠 Neden enum kullanıyoruz?
// ---------------------------------------------------------------------------
// Eğer filtreleri String olarak tutsaydık:
//
// ❌ yazım hatası riski olurdu
// ❌ kod okunabilirliği düşerdi
// ❌ refactor işlemleri zorlaşırdı
//
// Enum kullanınca:
//
// ✅ tip güvenliği sağlanır
// ✅ IDE autocomplete desteği gelir
// ✅ switch-case ile temiz kontrol yapılır
// ✅ UI ve filtreleme mantığı aynı ortak tip üzerinden konuşur
//
// ============================================================================

/// ============================================================================
/// 🔎 FilterOption
/// ============================================================================
/// Uygulamada kullanılabilecek filtre seçeneklerini temsil eder.
///
/// Kullanıldığı yerler:
/// • FilterChips widget
/// • WatchlistFilterEngine
/// • HomePage state yönetimi
/// ============================================================================
enum FilterOption {
  /// Tüm içerikleri gösterir.
  all,

  /// Sadece filmleri gösterir.
  movies,

  /// Sadece dizileri gösterir.
  series,

  /// Son 30 gün içindeki içerikleri gösterir.
  last30days,
}

/// ============================================================================
/// 🧩 FilterOptionLabel Extension
/// ============================================================================
///
/// Bu extension, enum değerlerini kullanıcıya gösterilecek metne çevirir.
///
/// Böylece UI tarafında sabit string yazmaya gerek kalmaz.
///
/// Örnek:
///   FilterOption.movies.label -> "Filmler"
///
/// Avantajları:
/// • metinler tek yerde tutulur
/// • yeni filtre eklemek kolaylaşır
/// • ileride çoklu dil desteği eklemek daha kolay olur
/// ============================================================================
extension FilterOptionLabel on FilterOption {
  /// Enum değerine karşılık gelen UI etiketini döndürür.
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