// 📃 widgets/drawer_widgets/alphabet_expansion_tile.dart
import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../help_page_widgets/drawer_list_tile.dart';

class AlphabetExpansionTile extends StatelessWidget {
  const AlphabetExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.sort_by_alpha, color: menuColor),
      title: const Text('Alfabe', style: drawerMenuText),
      childrenPadding: const EdgeInsets.only(left: 24),
      collapsedIconColor: menuColor,
      children: [
        DrawerListTile(
          icon: Icons.wc,
          title: 'Latin',
          routeName: '/sayfaLatin',
          iconColor: menuColor,
        ),
        DrawerListTile(
          icon: Icons.wc,
          title: 'Kiril',
          routeName: '/sayfaKiril',
          iconColor: menuColor,
        ),
      ],
    );
  }
}
