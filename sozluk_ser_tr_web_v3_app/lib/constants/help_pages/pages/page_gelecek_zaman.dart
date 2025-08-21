// 📜 <----- sayfa_gelecek_zaman.dart ----->

import 'package:flutter/material.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_app_bar.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../../widgets/help_page_widgets/rich_text_rule.dart';
import '../../text_constants.dart';
import '../constants/const_gelecek_zaman.dart';

class SayfaGelecekZaman extends StatefulWidget {
  const SayfaGelecekZaman({super.key});

  @override
  State<SayfaGelecekZaman> createState() => _SayfaGelecekZamanState();
}

/// 📌 Ana kod
class _SayfaGelecekZamanState extends State<SayfaGelecekZaman> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHelpAppBar(context),
      drawer: buildHelpDrawer(),
      body: buildBody(context),
    );
  }

  /// 📌 Body bloğu
  SafeArea buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Gelecek Zaman", style: detailTextBlue),
              const Divider(),
              buildRichTextRule(
                "'Htjeti (istemek fiili)' gelecek zamanda kullanılması "
                "zorunludur. 'Hjeti (çekimle)' + 'mastar fiil' şeklinde "
                "kullanılır. ",
                dashTextA: "'Htjeti (istemek fiili)'",
                dashTextB: "'Hjeti (çekimle)'",
                dashTextC: "'mastar fiil'",
                context,
              ),
              buildTable(gelecekZamanSampleA, "Gelecek Zaman - Genel Yapı", [
                (user) => user['şahıs']!,
                (user) => user['çekim']!,
                (user) => user['kısa çekim']!,
                (user) => user['olumsuz']!,
              ]),
              const Divider(),
              buildTable(
                gelecekZamanSampleB,
                "Örnek - razumjeti (anlamak) fiili",
                [
                  (user) => user['şahıs']!,
                  (user) => user['kısa çekim']!,
                  (user) => user['fiil']!,
                  (user) => user['türkçe']!,
                ],
              ),
              const Divider(),
              buildTable(
                gelecekZamanSampleC,
                "Örnek - razumjeti (anlamak) fiili",
                [(user) => user['türkçe']!, (user) => user['sırpça']!],
              ),
              const Divider(),
              buildRichTextRule(
                "'-ti' bitimli fiillerde, şahıs zamiri atılır. 'Htjeti/hteti' "
                "çekimini bir ileri kaydırıp, fiilden '-i' veya '-ti' düşürülür "
                "ve 'htjeti/hteti' çekimi birleştirilir.",
                dashTextA: "'-ti'",
                dashTextB: "'Htjeti/hteti'",
                dashTextC: "'-i'",
                dashTextD: "'-ti'",
                dashTextE: "'htjeti/hteti'",
                context,
              ),
              const Divider(),
              buildTable(gelecekZamanSampleD, "Örnek - biti (olmak) fiili", [
                (user) => user['uzun']!,
                (user) => user['boşnakça-hırvatça']!,
                (user) => user['sırpça']!,
              ]),
              const Divider(),
              buildTable(
                gelecekZamanSampleE,
                "Örnek - govoriti (konuşmak) fiili",
                [
                  (user) => user['uzun']!,
                  (user) => user['boşnakça-hırvatça']!,
                  (user) => user['sırpça']!,
                ],
              ),
              const Divider(),
              buildTable(
                gelecekZamanSampleF,
                "Örnek - hodati (yürümek) fiili",
                [
                  (user) => user['uzun']!,
                  (user) => user['boşnakça-hırvatça']!,
                  (user) => user['sırpça']!,
                ],
              ),
              buildRichTextRule(
                "'-ći' bitimli fiilerde, şahıs düşüyor. Fiil öne kayıyor.",
                dashTextA: "'-ći'",
                context,
              ),
              const Divider(),
              buildTable(gelecekZamanSampleG, "Örnek - Reći (demek) fiili", [
                (user) => user['uzun']!,
                (user) => user['kısa']!,
              ]),
              const Divider(),
              buildRichTextRule(
                "Burada bazı fiilerde özne düşmesi uygulandı. Örneğin "
                "'govoriti' fiilinde olduğu gibi",
                dashTextA: "'govoriti'",
                context,
              ),
              const Divider(),
              buildTable(
                gelecekZamanSampleH,
                "Özne düşürmeden kullanım aşağıdaki gibi",
                [
                  (user) => user['özne']!,
                  (user) => user['çekim']!,
                  (user) => user['isim']!,
                ],
              ),
              buildTable(
                gelecekZamanSampleI,
                "Özne düşürerek kullanım aşağıdaki gibi",
                [(user) => user['isim']!, (user) => user['çekim']!],
              ),
              const Divider(),
              buildTable(
                gelecekZamanSampleJ,
                "Özne düşürerek kullanım Örnekleri",
                [
                  (user) => user['normal']!,
                  (user) => user['turkce']!,
                  (user) => user['oznesiz']!,
                ],
              ),
              buildRichTextRule(
                "Özne düşünce fiilin çekimini sona atıp, fiil ile "
                "birleştiriyoruz. Sırpça 'da fiilden 'ti' ekini atıp, "
                "çekim ile birleştiriyoruz. Örneğin 'pripremati' de "
                "'ti' eki atılıyor.",
                dashTextA: "'ti'",
                dashTextB: "'pripremati'",
                dashTextC: "'ti'",
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
