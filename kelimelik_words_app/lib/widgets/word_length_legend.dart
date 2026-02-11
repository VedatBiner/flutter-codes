import 'package:flutter/material.dart';

import '../constants/chart_colors.dart';
import '../constants/text_constants.dart';

class WordLengthLegend extends StatelessWidget {
  final Map<int, int> data; // length -> count
  final int? selected;
  final ValueChanged<int?> onTap;

  const WordLengthLegend({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final keys = data.keys.toList()..sort();

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: keys.map((len) {
        final isSelected = selected == len;
        final colorIndex = (len - 1).clamp(
          0,
          ChartColors.wordLengthColors.length - 1,
        );
        final chipColor = ChartColors.wordLengthColors[colorIndex];

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Aynı elemana tekrar dokun -> filtre kalksın
            onTap(isSelected ? null : len);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? chipColor : Colors.transparent,
              border: Border.all(color: chipColor, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Renk noktası
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: chipColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),

                // Yazı
                Text(
                  '$len h (${data[len]})',
                  style: legendText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : null,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
























