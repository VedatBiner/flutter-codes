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
    return Padding(
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
    );
  }

  Widget _filterChip(String label, FilterOption option) {
    final selected = filter == option;

    if (option == FilterOption.all) {
      return ChoiceChip(
        label: Text(label, style: TextStyle(color: menuColor)),
        selected: selected,
        onSelected: (_) => onSelected(option),
        backgroundColor: Colors.indigo,
        selectedColor: Colors.indigoAccent[800],
      );
    }

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(option),
    );
  }
}
