// 📁 <----- lib/widgets/filter_chips.dart ----->
//
// ============================================================================
// 🎛 FilterChips – İçerik Filtreleme Chip Bileşeni
// ============================================================================
//
// Bu widget, kullanıcıya içerikleri farklı kriterlere göre filtreleyebilmesi
// için ChoiceChip tabanlı bir filtre alanı sunar.
//
// ---------------------------------------------------------------------------
// 🎯 Amaç
// ---------------------------------------------------------------------------
// Kullanıcının içerikleri şu kategorilere göre filtreleyebilmesini sağlamak:
//
// • Tümü
// • Filmler
// • Diziler
// • Son 30 Gün
//
// ---------------------------------------------------------------------------
// 🧠 Mimari Yapı
// ---------------------------------------------------------------------------
// Filtre seçenekleri UI içinde sabit string olarak tutulmaz.
// Bunun yerine FilterOption enum ve onun label extension ’ı kullanılır.
//
// Böylece:
//
// ✅ UI daha temiz olur
// ✅ string tekrarları ortadan kalkar
// ✅ yeni filtre eklemek kolaylaşır
//
// ---------------------------------------------------------------------------
// 📌 Kullanım
// ---------------------------------------------------------------------------
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
/// Filtre seçeneklerini ChoiceChip olarak gösteren widget.
///
/// Parametreler:
/// • [filter]     → şu an aktif olan filtre
/// • [onSelected] → kullanıcı yeni filtre seçtiğinde çağrılır
///
/// Not:
/// Bu widget stateless ’tir.
/// Filtre state ’i parent widget tarafından yönetilir.
/// ============================================================================
class FilterChips extends StatelessWidget {
  /// Aktif filtre.
  final FilterOption filter;

  /// Kullanıcı yeni filtre seçtiğinde çağrılır.
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
  // ChipTheme ile tüm chip ’lerin ortak görünümü belirlenir.
  // Wrap widget ile chip ’ler yatay sıralanır ve taşarsa alt satıra geçer.
  //
  @override
  Widget build(BuildContext context) {
    return ChipTheme(
      data: ChipThemeData(
        // Seçili olmayan chip arka planı
        backgroundColor: drawerColor,

        // Seçili chip arka planı
        selectedColor: editButtonColor,

        // Normal label stili
        labelStyle: const TextStyle(
          fontFamily: 'Oswald',
        ).copyWith(
          color: menuColor,
        ),

        // Seçili durumdaki label stili
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Oswald',
        ).copyWith(
          color: menuColor,
        ),

        // Oval chip görünümü
        shape: const StadiumBorder(),

        // Varsayılan tik işaretini kapat
        showCheckmark: false,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Wrap(
          spacing: 8,
          children: FilterOption.values
              .map((option) => _filterChip(option))
              .toList(),
        ),
      ),
    );
  }

  // ==========================================================================
  // 🔘 _filterChip()
  // ==========================================================================
  //
  // Tek bir filtre seçeneği için ChoiceChip üretir.
  //
  // İşleyiş:
  // • aktif filtre ile karşılaştırılır
  // • seçiliyse selected=true olur
  // • kullanıcı tıklarsa ilgili enum değeri parent ’a bildirilir
  //
  Widget _filterChip(FilterOption option) {
    final selected = filter == option;

    return ChoiceChip(
      label: Text(option.label),
      selected: selected,
      onSelected: (_) => onSelected(option),
    );
  }
}