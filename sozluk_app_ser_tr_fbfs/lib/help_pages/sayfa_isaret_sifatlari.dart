/// <----- sayfa_isaret_sifatlari.drt ----->
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/const_isaret_sifatlari.dart';
import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/rich_text_rule.dart';
import '../utils/text_header.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';
import 'help_parts/custom_appbar.dart';

class SayfaIsaretSifatlari extends StatefulWidget {
  const SayfaIsaretSifatlari({super.key});

  @override
  State<SayfaIsaretSifatlari> createState() => _SayfaIsaretSifatlariState();
}

class _SayfaIsaretSifatlariState extends State<SayfaIsaretSifatlari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarIsaretSifatlariTitle,
      ),
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextHeader(
                  "İşaret sıfatları",
                  context,
                  style: detailTextBlue,
                ),
                const Divider(),
                buildRichTextRule(
                  "Bir nesneyi tarif etme veya göstermek için kullanılan "
                  "sıfatlardır. Bu yakındaki nesne, şu uzaktaki nesne, "
                  "o daha uzaktaki nesne için kullanılıyor.",
                  dashTextA: 'Bu',
                  dashTextB: 'şu',
                  dashTextC: 'o',
                  context,
                ),
                buildTable(
                  isaretSifatlariSampleA,
                  "Onaj, Taj, Ovaj İşaret sıfatları",
                  [
                    (user) => user['işaret']!,
                    (user) => user['eril']!,
                    (user) => user['dişil']!,
                    (user) => user['nötr']!,
                  ],
                ),
                buildTable(
                  isaretSifatlariSampleB,
                  "Onaj, Taj, Ovaj İşaret sıfatları- Örnek",
                  [
                    (user) => user['kelime1']!,
                    (user) => user['kelime2']!,
                    (user) => user['kelime3']!,
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
