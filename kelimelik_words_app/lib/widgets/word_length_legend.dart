import 'package:flutter/material.dart';

import '../constants/chart_colors.dart';

class WordLengthLegend extends StatelessWidget {
  final Map<int, int> data;
  final int? selected;

  const WordLengthLegend({
    super.key,
    required this.data,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final keys = data.keys.toList()..sort();

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: keys.map((len) {
        final index = len - 1;
        final color = ChartColors.wordLengthColors[index];
        final count = data[len]!;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: selected == len
                    ? Border.all(color: Colors.black, width: 2)
                    : null,
              ),
            ),
            const SizedBox(width: 6),
            Text('$len harf ($count)'),
          ],
        );
      }).toList(),
    );
  }
}
