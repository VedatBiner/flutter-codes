import 'package:flutter/material.dart';
import 'package:alphabet_list_view/alphabet_list_view.dart';

import '../repository.dart';

class ExampleDefault extends StatelessWidget {
  const ExampleDefault({super.key});

  @override
  Widget build(BuildContext context) {
    return AlphabetListView(
      items: _animals,
    );
  }

  List<AlphabetListViewItemGroup> get _animals => Repository.animals.entries
      .map(
        (animalLetter) => AlphabetListViewItemGroup(
      tag: animalLetter.key,
      children: animalLetter.value.map(Text.new),
    ),
  )
      .toList();
}