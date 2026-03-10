// 📁 <----- lib/widgets/filter_chips.dart ----->
//
// ============================================================================
// 🎛 FilterChips – İçerik Filtreleme Chip Bileşeni
// ============================================================================
//
// Bu widget, kullanıcıya ChoiceChip tabanlı filtre seçenekleri sunar.
//
// Filtre metinleri doğrudan UI içinde yazılmaz.
// Bunun yerine FilterOption enum içindeki `label` extension ’ı kullanılır.
//
// Böylece:
// • kod tekrar etmez
// • yeni filtre eklemek kolay olur
// • çoklu dil desteği ileride daha kolay eklenir
//
// ============================================================================

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../models/filter_option.dart';

class FilterChips extends StatelessWidget {
  final FilterOption filter;
  final ValueChanged<FilterOption> onSelected;

  const FilterChips({
    super.key,
    required this.filter,
    required this.onSelected,
  });

  /// =========================================================================
  /// 🏗 build()
  /// =========================================================================
  ///
  /// Filtre chip ’lerini ekrana yerleştirir.
  /// Wrap kullanıldığı için chip ’ler taşarsa alt satıra geçer.
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    return ChipTheme(
      data: ChipThemeData(
        backgroundColor: drawerColor,
        selectedColor: editButtonColor,
        labelStyle: const TextStyle(fontFamily: 'Oswald')
            .copyWith(color: menuColor),
        secondaryLabelStyle: const TextStyle(fontFamily: 'Oswald')
            .copyWith(color: menuColor),
        shape: const StadiumBorder(),
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

  /// =========================================================================
  /// 🔘 _filterChip()
  /// =========================================================================
  ///
  /// Tek bir filtre seçeneği için ChoiceChip üretir.
  /// =========================================================================
  Widget _filterChip(FilterOption option) {
    final selected = filter == option;

    return ChoiceChip(
      label: Text(option.label),
      selected: selected,
      onSelected: (_) => onSelected(option),
    );
  }
}