// 📃 <----- page_kiril.dart ----->
//

import 'package:flutter/material.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_app_bar.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../constants/alphabet_constants.dart';

class SayfaKiril extends StatefulWidget {
  const SayfaKiril({super.key});

  @override
  State<SayfaKiril> createState() => _SayfaKirilState();
}

/// 📌 Ana kod
class _SayfaKirilState extends State<SayfaKiril> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHelpAppBar(context),
      drawer: buildHelpDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: buildTable(kirilAlphabet, "Sırpça 'da Kiril Harfleri", [
            (user) => user['turkce']!,
            (user) => user['sirpca']!,
          ]),
        ),
      ),
    );
  }
}
