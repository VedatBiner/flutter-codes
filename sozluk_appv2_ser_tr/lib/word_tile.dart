/// <----- word_tile.dart ----->
library;

import 'package:flutter/material.dart';

import 'model/word_model.dart';

class WordTile extends StatelessWidget {
  final Words word;

  const WordTile({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
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
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  word.userEmail,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
