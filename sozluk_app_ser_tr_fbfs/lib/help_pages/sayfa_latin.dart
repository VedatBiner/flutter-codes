/// <----- sayfa_latin.dart ----->
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/alphabet_table.dart';

class SayfaLatin extends StatelessWidget {
  const SayfaLatin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sırpça 'da Latin Harfleri"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: AlphabetTable(alphabet: latinAlphabet),
      ),
    );
  }
}