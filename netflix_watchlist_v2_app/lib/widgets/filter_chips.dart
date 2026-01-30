// 📁 lib/widgets/filter_chips.dart
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../models/filter_option.dart';

class FilterChips extends StatelessWidget {
  final FilterOption filter;
  final Function(FilterOption) onSelected;

  const FilterChips({
    super.key,
    required this.filter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // `ChipTheme.of(context).copyWith` yerine yeni bir `ChipThemeData`
    // oluşturarak, butonların görünümünün tema değişikliklerinden
    // etkilenmemesini sağlıyoruz.
    return ChipTheme(
      data: ChipThemeData(
        backgroundColor: drawerColor,
        selectedColor: editButtonColor,
        labelStyle: TextStyle(color: menuColor, fontFamily: 'Oswald'),
        secondaryLabelStyle: TextStyle(color: menuColor, fontFamily: 'Oswald'),
        shape: const StadiumBorder(),
        showCheckmark: false, // Onay (tick) işaretini kaldırır.
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Wrap(
          spacing: 8,
          children: [
            _filterChip("Tümü", FilterOption.all),
            _filterChip("Filmler", FilterOption.movies),
            _filterChip("Diziler", FilterOption.series),
            _filterChip("Son 30 Gün", FilterOption.last30days),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, FilterOption option) {
    final selected = filter == option;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(option),
    );
  }
}
