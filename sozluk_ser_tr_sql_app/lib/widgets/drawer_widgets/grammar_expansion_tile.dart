// 📃 widgets/grammar_expansion_tile.dart
// Drawer içinde kullanılan "Gramer" alt menüsünü bağımsız bir widget’a
// taşıdık. Böylece custom_drawer.dart sadeleşti.
//
// Kullanım:
//   import '../widgets/grammar_expansion_tile.dart';
//   ...
//   children: [
//     GrammarExpansionTile(), // ⬅️ eski buildGrammarExpansionTile() yerine
//   ]
//
import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../help_page_widgets/drawer_list_tile.dart';

class GrammarExpansionTile extends StatelessWidget {
  const GrammarExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.menu_book, color: menuColor),
      title: const Text('Gramer', style: drawerMenuText),
      childrenPadding: const EdgeInsets.only(left: 24),
      collapsedIconColor: menuColor,
      children: [
        // 📌 Kelimelerde cinsiyet
        DrawerListTile(
          icon: Icons.wc,
          title: 'Kelimelerde Cinsiyet',
          routeName: '/sayfaCinsiyet',
          iconColor: menuColor,
        ),
        // 📌 Kelimelerde çoğul kullanımı
        DrawerListTile(
          icon: Icons.wc,
          title: 'Çoğul Kullanımı',
          routeName: '/sayfaCogul',
          iconColor: menuColor,
        ),
        // 📌 Şahıs zamirleri kullanımı
        DrawerListTile(
          icon: Icons.question_mark,
          title: 'Şahıs Zamirleri Kullanımı',
          routeName: '/sayfaZamir',
          iconColor: menuColor,
        ),
        // 📌 Soru cümleleri kullanımı
        DrawerListTile(
          icon: Icons.question_mark,
          title: 'Soru Cümleleri Kullanımı',
          routeName: '/sayfaSoru',
          iconColor: menuColor,
        ),
        // 📌 Fiiller
        ExpansionTile(
          leading: Icon(Icons.menu, color: menuColor),
          title: const Text('Fiiler', style: drawerMenuText),
          childrenPadding: const EdgeInsets.only(left: 24),
          collapsedIconColor: menuColor,
          children: [
            DrawerListTile(
              icon: Icons.question_mark,
              title: 'Şimdiki Zaman Kullanımı',
              routeName: '/sayfaSimdikiGenisZaman',
              iconColor: menuColor,
            ),
            DrawerListTile(
              icon: Icons.question_mark,
              title: 'Geçişli ve Dönüşlü Fiiler',
              routeName: '/sayfaGecisliDonusluFiiller',
              iconColor: menuColor,
            ),
            DrawerListTile(
              icon: Icons.question_mark,
              title: 'Gelecek Zaman Kullanımı',
              routeName: '/sayfaGelecekZaman',
              iconColor: menuColor,
            ),
            DrawerListTile(
              icon: Icons.question_mark,
              title: 'Sık Kullanılan Fiiler',
              routeName: '/sayfaFiiller',
              iconColor: menuColor,
            ),
          ],
        ),
        // 📌 Sıfatlar
        ExpansionTile(
          leading: Icon(Icons.menu, color: menuColor),
          title: const Text('Sıfatlar', style: drawerMenuText),
          childrenPadding: const EdgeInsets.only(left: 24),
          collapsedIconColor: menuColor,
          children: [
            DrawerListTile(
              icon: Icons.question_mark,
              title: 'İşaret Sıfatları Kullanımı',
              routeName: '/sayfaIsaretSifatlari',
              iconColor: menuColor,
            ),
            DrawerListTile(
              icon: Icons.question_mark,
              title: 'Sahiplik Sıfatları Kullanımı',
              routeName: '/sayfaSahiplikSifatlari',
              iconColor: menuColor,
            ),
          ],
        ),
        // 📌 Uzun kısa kelime kullanımı
        DrawerListTile(
          icon: Icons.question_mark,
          title: 'Uzun Kısa Kelime Kullanımı',
          routeName: '/sayfaUzunKisa',
          iconColor: menuColor,
        ),

        /// 📌 Yardımcı Kavramlar
        ExpansionTile(
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
      ],
    );
  }
}
