/// <----- sayfa_kiril.dart ----->
import 'package:flutter/material.dart';

import '../constants.dart';
import 'help_parts/build_table.dart';

class SayfaKiril extends StatelessWidget {
  const SayfaKiril({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sırpça 'da Kiril Harfleri"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: buildTable(
          kirilAlphabet,
          "- Sırpça 'da Kiril Harfleri",
          (user) => user['turkce']!,
          (user) => user['sirpca']!,
        ),
      ),
    );
  }
}
