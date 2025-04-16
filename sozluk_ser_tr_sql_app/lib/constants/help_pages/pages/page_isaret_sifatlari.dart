// 📜 <----- sayfa_isaret_sifatlari.dart ----->

import 'package:flutter/material.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_app_bar.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../../widgets/help_page_widgets/rich_text_rule.dart';
import '../../text_constants.dart';
import '../constants/const_isaret_sifatlari.dart';

class SayfaIsaretSifatlari extends StatefulWidget {
  const SayfaIsaretSifatlari({super.key});

  @override
  State<SayfaIsaretSifatlari> createState() => _SayfaIsaretSifatlariState();
}

/// 📌 Ana kod
class _SayfaIsaretSifatlariState extends State<SayfaIsaretSifatlari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHelpAppBar(context),
      drawer: buildHelpDrawer(),
      body: buildBody(context),
    );
  }

  SafeArea buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("İşaret sıfatları", style: detailTextBlue),
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
                [(user) => user['soru']!, (user) => user['cevap']!],
              ),
              buildRichTextRule(
                "Nesneyi kullanarak soru soralım. Soru + bu/şu/o + nesne",
                dashTextA: 'Soru + bu/şu/o + nesne',
                context,
              ),
              buildTable(
                isaretSifatlariSampleD,
                "Bu, Şu, o nedir? Sorular (nesne kullanarak)",
                [(user) => user['soru']!, (user) => user['anlamı']!],
              ),
              buildRichTextRule(
                "Soru + bu /şu /o + isim/nesne kalıbı kullanılır.",
                dashTextA: 'Soru + bu /şu /o + isim/nesne',
                context,
              ),
              buildTable(
                isaretSifatlariSampleE,
                "Bu, Şu, o nedir? Olumsuz Sorular (nesne kullanarak)",
                [(user) => user['soru']!, (user) => user['anlamı']!],
              ),
              buildRichTextRule(
                "Burada nije li veya zar nije kullanarak olumsuz soru sorabiliriz.",
                dashTextA: 'nije li',
                dashTextB: 'zar nije',
                context,
              ),
              const Divider(),
              buildRichTextRule("Aşağıdaki kalıplar kullanılır.", context),
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
                [(user) => user['soru']!, (user) => user['cevap']!],
              ),
              buildTable(
                isaretSifatlariSampleG,
                "Burada, şurada, orada Örnekler - 2",
                [(user) => user['ifade']!, (user) => user['anlam']!],
              ),
              buildTable(
                isaretSifatlariSampleH,
                "Burada, şurada, orada Cevapları",
                [(user) => user['ifade']!, (user) => user['anlam']!],
              ),
              buildTable(
                isaretSifatlariSampleI,
                "Burada, şurada, orada Konum belirten sorular",
                [(user) => user['ifade']!, (user) => user['anlam']!],
              ),
              buildRichTextRule(
                "(*) Eğer ovdje başa gelirse varlık yokluk anlamı katar.",
                dashTextA: 'ovdje',
                context,
              ),
              const Divider(),
              buildTable(isaretSifatlariSampleJ, "Bunlar, Şunlar, Onlar", [
                (user) => user['işaret']!,
                (user) => user['erkek']!,
                (user) => user['dişi']!,
                (user) => user['nötr']!,
              ]),
              buildTable(
                isaretSifatlariSampleK,
                "Bunlar, Şunlar, Onlar Örnek",
                [
                  (user) => user['most']!,
                  (user) => user['jabuka']!,
                  (user) => user['selo']!,
                ],
              ),
              buildTable(isaretSifatlariSampleL, "Kim ? / Ne?", [
                (user) => user['Boşnakça/Sırpça']!,
                (user) => user['Hırvatça']!,
                (user) => user['Türkçe']!,
              ]),
              buildTable(
                isaretSifatlariSampleM,
                "Kim ? / Ne? - Örnek: raditi (yapmak) ve "
                "dolaziti (gelmek) fiileri",
                [
                  (user) => user['Boşnakça/Sırpça']!,
                  (user) => user['Hırvatça']!,
                  (user) => user['Türkçe']!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
