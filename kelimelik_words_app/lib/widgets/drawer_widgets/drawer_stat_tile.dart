import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/text_constants.dart';

import '../../constants/color_constants.dart';
import '../../screens/words_stats_page.dart';

class DrawerStatTile extends StatelessWidget {
  const DrawerStatTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.pie_chart_outline,
        size: 28,
        color: downLoadButtonColor,
      ),
      title: const Text('Kelime İstatistikleri', style: drawerMenuText),
      subtitle: Text(
        'Harf sayısı analizi ve \nGrafik analiz',
        style: drawerMenuSubtitleText,
      ),
      onTap: () {
        // Drawer 'ı kapat
        Navigator.of(context).pop();

        // İstatistik sayfasına git
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const WordsStatsPage()));
      },
    );
  }
}
