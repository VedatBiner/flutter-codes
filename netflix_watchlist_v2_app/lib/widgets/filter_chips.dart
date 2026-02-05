// 📁 lib/widgets/filter_chips.dart
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

  @override
  Widget build(BuildContext context) {
    return ChipTheme(
      data: ChipThemeData(
        backgroundColor: drawerColor,
        selectedColor: editButtonColor,
        labelStyle: const TextStyle(fontFamily: 'Oswald').copyWith(color: menuColor),
        secondaryLabelStyle: const TextStyle(fontFamily: 'Oswald').copyWith(color: menuColor),
        shape: const StadiumBorder(),
        showCheckmark: false,
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
