/// <----- expanded_word.dart ----->

import 'package:flutter/material.dart';

class ExpandedWord extends StatelessWidget {
  const ExpandedWord({
    super.key,
    required this.word,
    required this.color,
  });

  final Color color;
  final String word;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          word,
          textAlign: TextAlign.left,
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
