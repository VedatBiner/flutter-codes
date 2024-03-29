import 'package:flutter/material.dart';

import '../model/word_model.dart';

class WordTile extends StatelessWidget {
  final Word word;
  const WordTile({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                word.sirpca,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                word.turkce,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
