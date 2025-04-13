// 📃 <----- sayfa_latin.dart ----->
//

import 'package:flutter/material.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_app_bar.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../constants/alphabet_constants.dart';

class SayfaLatin extends StatefulWidget {
  const SayfaLatin({super.key});

  @override
  State<SayfaLatin> createState() => _SayfaLatinState();
}

/// 📌 Ana kod
class _SayfaLatinState extends State<SayfaLatin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHelpAppBar(),
      drawer: buildHelpDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: buildTable(latinAlphabet, "Sırpça 'da  Latin Harfleri", [
          (user) => user['turkce']!,
          (user) => user['sirpca']!,
        ]),
      ),
    );
  }
}
