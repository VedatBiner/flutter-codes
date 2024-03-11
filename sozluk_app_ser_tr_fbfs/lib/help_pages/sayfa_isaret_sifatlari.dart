/// <----- sayfa_isaret_sifatlari.drt ----->
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/const_isaret_sifatlari.dart';
import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/rich_text_rule.dart';
import '../utils/text_header.dart';
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
              const Divider(),
              buildRichTextRule(
                "Soru ? Cevap + nesne şeklinde cevap dönülüyor. Bu örnekte "
                "cinsiyetini bilmediğimiz nötr sorular var.",
                dashTextA: 'Soru',
                dashTextB: 'Cevap + nesne',
                context,
              ),
              buildTable(
                isaretSifatlariSampleC,
                "Bu, Şu, o nedir? Soruları ve Cevapları",
                [
                  (user) => user['soru']!,
                  (user) => user['cevap']!,
                ],
              ),
              buildRichTextRule(
                "Nesneyi kullanarak soru soralım. Soru + bu/şu/o + nesne",
                dashTextA: 'Soru + bu/şu/o + nesne',
                context,
              ),
              buildTable(
                isaretSifatlariSampleD,
                "Bu, Şu, o nedir? Sorular (nesne kullanarak)",
                [
                  (user) => user['soru']!,
                  (user) => user['anlamı']!,
                ],
              ),
              buildRichTextRule(
                "Soru + bu /şu /o + isim/nesne kalıbı kullanılır.",
                dashTextA: 'Soru + bu /şu /o + isim/nesne',
                context,
              ),
              buildTable(
                isaretSifatlariSampleE,
                "Bu, Şu, o nedir? Olumsuz Sorular (nesne kullanarak)",
                [
                  (user) => user['soru']!,
                  (user) => user['anlamı']!,
                ],
              ),
              buildRichTextRule(
                "Burada nije li veya zar nije kullanarak olumsuz soru sorabiliriz.",
                dashTextA: 'nije li',
                dashTextB: 'zar nije',
                context,
              ),
              const Divider(),
              buildRichTextRule(
                "Aşağıdaki kalıplar kullanılır.",
                context,
              ),
              buildRichTextRule(
                "Gdje / gde + (olmak fiili) + (isim/nesne) ?",
                dashTextA: 'Gdje / gde',
                context,
              ),
              buildRichTextRule(
                "(isim/nesne) + (olmak fiili) + (burada/şurada)",
                context,
              ),
              buildRichTextRule(
                "Ovde / ovdje + je / su + (isim/nesne)",
                dashTextA: 'Ovde / ovdje',
                dashTextB: 'je / su',
                context,
              ),
              buildRichTextRule(
                "Tamo + je / su + (isim/nesne)",
                dashTextA: 'Tamo',
                dashTextB: 'je / su',
                context,
              ),
              buildRichTextRule(
                "Onamo + je / su + (isim/nesne)",
                dashTextA: 'Onamo',
                dashTextB: 'je / su',
                context,
              ),
              buildRichTextRule(
                "je tekiller için, su çoğullar için kullanılır.",
                dashTextA: 'je',
                dashTextB: 'su',
                context,
              ),
              buildRichTextRule(
                "Olumsuz yapmak için je yerine nije, "
                "su yerine nisu kullanılır. ",
                dashTextA: 'je',
                dashTextB: 'nije',
                dashTextC: 'su',
                dashTextD: 'nisu',
                context,
              ),
              buildTable(
                isaretSifatlariSampleF,
                "Burada, şurada, orada Örnekler - 1",
                [
                  (user) => user['soru']!,
                  (user) => user['cevap']!,
                ],
              ),
              buildTable(
                isaretSifatlariSampleG,
                "Burada, şurada, orada Örnekler - 2",
                [
                  (user) => user['ifade']!,
                  (user) => user['anlam']!,
                ],
              ),
              buildTable(
                isaretSifatlariSampleH,
                "Burada, şurada, orada Cevapları",
                [
                  (user) => user['ifade']!,
                  (user) => user['anlam']!,
                ],
              ),
              buildTable(
                isaretSifatlariSampleI,
                "Burada, şurada, orada Konum belirten sorular",
                [
                      (user) => user['ifade']!,
                      (user) => user['anlam']!,
                ],
              ),
              buildRichTextRule(
                "(*) Eğer ovdje başa gelirse varlık yokluk anlamı katar.",
                dashTextA: 'ovdje',
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
