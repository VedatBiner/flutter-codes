// 📁 lib/widgets/custom_body.dart
//
// ============================================================================
// 📦 CustomBody – Ana Liste Gövdesi (Filmler + Diziler)
// ============================================================================
//
// Bu dosya, HomePage ekranının “body” kısmını oluşturur.
// Uygulamanın ana işlevi olan Netflix izleme geçmişini:
//
//   • Diziler (SeriesSection)  →  ExpansionTile tabanlı grup yapı
//   • Filmler (MovieSection)   →  ExpansionTile tabanlı düz liste
//
// şeklinde iki ayrı bölüm halinde kullanıcıya sunar.
//
// ---------------------------------------------------------------------------
// 🎯 Bu dosyanın ana amacı
// ---------------------------------------------------------------------------
// 1) Ana sayfanın gövde düzenini (layout) tek yerden yönetmek.
// 2) Film/dizi içerik mantığını (OMDb, poster, long-press viewer vb.) BURAYA
//    taşımamak; ilgili alt widget ’lara dağıtmak.
// 3) ExpansionTile kontrolünü tek noktada tutmak:
//    Diziler açılınca Filmler kapansın (ve tersi).
//
// ---------------------------------------------------------------------------
// 🔹 Sorumluluklar (Scope)
// ---------------------------------------------------------------------------
// ✅ Yapılanlar:
//   • Loading durumuna göre spinner gösterme
//   • FilterChips ile filtre seçimi UI ’ı
//   • SeriesSection ve MovieSection’ı ekrana yerleştirme
//   • Bölümler arası aç/kapa davranışını controller ile yönetme
//
// ❌ Yapılmayanlar (Alt widget ’lara devredildi):
//   • OMDb API çağrıları / lazy-load
//   • Poster thumbnail / hero viewer / swipe-to-close
//   • Satır render detayları (ListTile subtitle formatları vb.)
//
// ---------------------------------------------------------------------------
// 🧠 Mimari Not (Neden böyle?)
// ---------------------------------------------------------------------------
// CustomBody “orchestrator” gibi davranır.
// Yani:
//   - Ana ekran düzenini kurar,
//   - Alt widget ’lara gerekli veriyi ve callback ’leri verir,
//   - Bölümler arası UI koordinasyonunu yapar.
//
// Böylece dosya büyümez, bakımı kolay kalır.
//
// ============================================================================

import 'package:flutter/material.dart';

import '../models/filter_option.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import 'filter_chips.dart';
import 'body_widgets/movie_section.dart';
import 'body_widgets/series_section.dart';

class CustomBody extends StatefulWidget {
  /// HomePage yükleme durumunu buraya gönderir.
  /// true iken liste yerine spinner gösterilir.
  final bool loading;

  /// Filtre uygulanmış film listesi (UI ’da gösterilecek liste).
  /// Not: Bu liste HomePage tarafında search + filter sonrası gelir.
  final List<NetflixItem> movies;

  /// Filtre uygulanmış dizi listesi (UI ’da gösterilecek liste).
  /// Not: Bu liste HomePage tarafında search + filter sonrası gelir.
  final List<SeriesGroup> series;

  /// Aktif filtre seçeneği (chip seçiminde işaretli görünen).
  final FilterOption filter;

  /// FilterChips içinde kullanıcı yeni bir filtre seçince tetiklenir.
  /// HomePage bu callback ile filter state ’ini günceller ve listeyi yeniden üretir.
  final ValueChanged<FilterOption> onFilterSelected;

  /// Film satırına tıklanınca çalışır.
  /// Genelde: OMDb lazy-load başlatmak veya detay güncellemek için kullanılır.
  final ValueChanged<NetflixItem> onMovieTap;

  const CustomBody({
    super.key,
    required this.loading,
    required this.movies,
    required this.series,
    required this.filter,
    required this.onFilterSelected,
    required this.onMovieTap,
  });

  /// =========================================================================
  /// 🧬 createState()
  /// =========================================================================
  /// CustomBody stateful olduğu için Expansion controller gibi “durum” tutar.
  /// Bu method, widget ’ın state objesini üretir.
  @override
  State<CustomBody> createState() => _CustomBodyState();
}

/// ============================================================================
/// 🎛 _CustomBodyState – Expansion Controller Yönetimi
/// ============================================================================
///
/// Bu state sınıfı iki ExpansionTile’ın controller ’larını yönetir:
///
///   • _seriesController → Diziler bölümünün ExpansionTile kontrolü
///   • _moviesController → Filmler bölümünün ExpansionTile kontrolü
///
/// Amaç:
/// Kullanıcı bir bölümü açtığında diğerini otomatik kapatmak.
///
/// Örnek davranış:
///   - Diziler açıldı → Filmler collapse
///   - Filmler açıldı → Diziler collapse
///
/// Böylece ekranda gereksiz uzun scroll oluşmaz ve UI daha kontrollü kalır.
/// ============================================================================

class _CustomBodyState extends State<CustomBody> {
  /// Diziler bölümünün ExpansionTile controller ’ı
  final _seriesController = ExpansibleController();

  /// Filmler bölümünün ExpansionTile controller ’ı
  final _moviesController = ExpansibleController();

  /// =========================================================================
  /// 🏗 build()
  /// =========================================================================
  /// CustomBody’nin tüm UI ağacını üretir.
  ///
  /// Akış:
  /// 1) loading == true ise:
  ///    • Veri henüz hazır değildir → ortada spinner gösterilir.
  ///
  /// 2) loading == false ise:
  ///    • Üstte FilterChips gösterilir
  ///    • Altta ListView içinde iki bölüm yer alır:
  ///       a) SeriesSection (Diziler)
  ///       b) MovieSection  (Filmler)
  ///
  /// Bölümler arası koordinasyon:
  ///  • SeriesSection açılırsa → _moviesController.collapse()
  ///  • MovieSection açılırsa  → _seriesController.collapse()
  ///
  /// Not:
  /// Burada “dizi/film satır detayları” yoktur. O işler:
  ///  • series_section.dart / series_tile.dart
  ///  • movie_section.dart / movie_tile.dart
  /// dosyalarında çözülür.
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    // 1) Loading ekranı
    if (widget.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2) Normal ekran
    return Column(
      children: [
        // ------------------------------------------------------------
        // 🔘 Üst Filtre Chip ’leri
        // ------------------------------------------------------------
        // Kullanıcı burada filtre seçer; seçilen filtre HomePage’e callback ile gider.
        FilterChips(filter: widget.filter, onSelected: widget.onFilterSelected),

        // ------------------------------------------------------------
        // 📜 Liste Alanı
        // ------------------------------------------------------------
        // Expanded: Column içinde ListView’in ekrana yayılmasını sağlar.
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              // ------------------------------------------------------
              // 📺 Diziler Bölümü
              // ------------------------------------------------------
              // Diziler açılınca filmleri kapatır.
              SeriesSection(
                series: widget.series,
                seriesController: _seriesController,
                onExpand: () => _moviesController.collapse(),
              ),
              const SizedBox(height: 20),

              // ------------------------------------------------------
              // 🎬 Filmler Bölümü
              // ------------------------------------------------------
              // Filmler açılınca dizileri kapatır.
              MovieSection(
                movies: widget.movies,
                moviesController: _moviesController,
                onExpand: () => _seriesController.collapse(),
                onMovieTap: widget.onMovieTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
