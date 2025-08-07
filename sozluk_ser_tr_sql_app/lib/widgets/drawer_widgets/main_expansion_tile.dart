import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import 'alphabet_expansion_tile.dart';
import 'grammar_expansion_tile.dart';
import 'help_pages_tile.dart';

class MainExpansionTile extends StatelessWidget {
  const MainExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.info_outline_rounded, color: menuColor, size: 32),
      title: const Text('Yardımcı Bilgiler', style: drawerMenuText),
      childrenPadding: const EdgeInsets.only(left: 24),
      collapsedIconColor: menuColor,

      children: [
        /// 📌 Alfabe - İçinde Latin ve Kiril seçenekleri
        const AlphabetExpansionTile(),

        /// 📌 Gramer
        const GrammarExpansionTile(),

        /// 📌 Yardımcı Kavramlar
        const HelpExpansionTile(),
      ],
    );
  }
}
