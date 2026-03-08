// 📁 <----- lib/widgets/filter_chips.dart ----->
//
// ============================================================================
// 🎛 FilterChips – İçerik Filtreleme Chip Bileşeni
// ============================================================================
//
// Bu widget, kullanıcıya içerikleri farklı kriterlere göre filtreleyebilmesi
// için ChoiceChip tabanlı bir filtre menüsü sunar.
//
// ---------------------------------------------------------------------------
// 🎯 Amaç
// ---------------------------------------------------------------------------
// Kullanıcının içerikleri şu kategorilere göre filtreleyebilmesini sağlamak:
//
// • Tümü
// • Filmler
// • Diziler
// • Son 30 gün
//
// ---------------------------------------------------------------------------
// 🧠 Mimari Yapı
// ---------------------------------------------------------------------------
// Filtre seçenekleri `FilterOption` enum içinde tanımlıdır.
//
// enum FilterOption {
//   all,
//   movies,
//   series,
//   last30days
// }
//
// Ayrıca enum içinde bir extension vardır:
//
// extension FilterOptionLabel on FilterOption
//
// Bu extension sayesinde enum değerleri UI metnine çevrilir.
//
// Örnek:
//
// FilterOption.movies.label → "Filmler"
//
// Böylece UI içinde string sabitleri kullanılmaz.
//
// ---------------------------------------------------------------------------
// 📌 Kullanım Örneği
// ---------------------------------------------------------------------------
//
// FilterChips(
//   filter: selectedFilter,
//   onSelected: (newFilter) {
//     setState(() {
//       selectedFilter = newFilter;
//     });
//   },
// )
//
// ============================================================================

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../models/filter_option.dart';

/// ============================================================================
/// 🎛 FilterChips
/// ============================================================================
///
/// Filtre seçeneklerini ChoiceChip şeklinde gösteren widget.
///
/// Parametreler:
///
/// [filter]
///   Şu anda aktif olan filtre.
///
/// [onSelected]
///   Kullanıcı yeni filtre seçtiğinde çağrılan callback.
///
/// Bu widget stateless 'tir.
/// Çünkü filtre state 'i parent widget tarafından yönetilir.
/// ============================================================================
class FilterChips extends StatelessWidget {
  /// Aktif filtre
  final FilterOption filter;

  /// Filtre değiştiğinde çağrılır
  final ValueChanged<FilterOption> onSelected;

  const FilterChips({
    super.key,
    required this.filter,
    required this.onSelected,
  });

  // ==========================================================================
  // 🏗 build()
  // ==========================================================================
  //
  // ChipTheme kullanılarak ChoiceChip bileşenlerinin görünümü
  // merkezi şekilde ayarlanır.
  //
  // Wrap widget ise chip 'lerin satır kırarak yerleşmesini sağlar.
  //
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    return ChipTheme(
      data: ChipThemeData(
        backgroundColor: drawerColor,
        selectedColor: editButtonColor,

        labelStyle: const TextStyle(
          fontFamily: 'Oswald',
        ).copyWith(color: menuColor),

        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Oswald',
        ).copyWith(color: menuColor),

        shape: const StadiumBorder(),

        // Seçildiğinde tik işareti gösterilmez
        showCheckmark: false,
      ),

      child: Padding(
        padding: const EdgeInsets.all(6),

        // Wrap sayesinde chip 'ler taşınca alt satıra iner
        child: Wrap(
          spacing: 8,

          children: [
            /// ------------------------------------------------------
            /// Filtre seçenekleri
            /// ------------------------------------------------------
            /// Enum üzerinden üretilir.
            /// Böylece UI içinde string yazılmaz.
            ///
            ...FilterOption.values.map((option) => _filterChip(option)),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // 🔘 _filterChip()
  // ==========================================================================
  //
  // Tek bir filtre chip 'i üretir.
  //
  // Parametre:
  // [option] → ilgili FilterOption enum değeri
  //
  // İşleyiş:
  //
  // 1️⃣ option == filter ise chip selected olur
  // 2️⃣ label enum extension üzerinden alınır
  // 3️⃣ onSelected callback tetiklenir
  //
  // ==========================================================================
  Widget _filterChip(FilterOption option) {
    final selected = filter == option;

    return ChoiceChip(
      label: Text(option.label),

      selected: selected,

      onSelected: (_) => onSelected(option),
    );
  }
}
