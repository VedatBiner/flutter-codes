/// <----- expanded_word.dart ----->
library;

import 'package:flutter/material.dart';

class ExpandedWord extends StatelessWidget {
  const ExpandedWord({
    super.key,
    required this.word,
    required this.color,
    required this.align,
  });

  final Color color;
  final String word;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          word,
          textAlign: align,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
