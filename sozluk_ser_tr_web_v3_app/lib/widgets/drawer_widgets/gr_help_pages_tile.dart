// 📃 widgets/help_pages_tile.dart

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import 'drawer_list_tile.dart';

/// 📌 Yardımcı Kavramlar
class HelpExpansionTile extends StatelessWidget {
  const HelpExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Yardımcı Kavramlar',
      child: ExpansionTile(
        leading: Icon(Icons.menu, color: menuColor),
        title: const Text('Yardımcı Kavramlar', style: drawerMenuText),
        childrenPadding: const EdgeInsets.only(left: 24),
        collapsedIconColor: menuColor,
        children: [
          /// 📌 Sayılar
          DrawerListTile(
            icon: Icons.numbers,
            title: 'Sayılar',
            routeName: '/sayfaSayilar',
            iconColor: menuColor,
          ),

          /// 📌 Günler
          DrawerListTile(
            icon: Icons.calendar_month_sharp,
            title: 'Günler',
            routeName: '/sayfaGunler',
            iconColor: menuColor,
          ),

          /// 📌 Saatler
          DrawerListTile(
            icon: Icons.watch_later_outlined,
            title: 'Saatler',
            routeName: '/sayfaSaatler',
            iconColor: menuColor,
          ),
        ],
      ),
    );
  }
}
