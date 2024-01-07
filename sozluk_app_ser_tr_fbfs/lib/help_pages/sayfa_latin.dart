/// <----- sayfa_latin.dart ----->
import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import 'help_parts/build_table.dart';

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
        child: buildTable(
          latinAlphabet,
          "- Sırpça 'da  Latin Harfleri",
          [
                (user) => user['turkce']!,
                (user) => user['sirpca']!,
          ]

        ),
      ),
    );
  }
}
