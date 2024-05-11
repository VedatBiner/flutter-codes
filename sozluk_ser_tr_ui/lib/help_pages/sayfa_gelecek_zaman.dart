/// <----- sayfa_gelecek_zaman.drt ----->
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/const_gelecek_zaman.dart';
import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/rich_text_rule.dart';
import '../utils/text_header.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';
import 'help_parts/custom_appbar.dart';

class SayfaGelecekZaman extends StatefulWidget {
  const SayfaGelecekZaman({super.key});

  @override
  State<SayfaGelecekZaman> createState() => _SayfaGelecekZamanState();
}

class _SayfaGelecekZamanState extends State<SayfaGelecekZaman> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarGelecekZamanTitle,
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
                "Gelecek Zaman",
                context,
                style: detailTextBlue,
              ),
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
              buildTable(
                gelecekZamanSampleA,
                "Gelecek Zaman - Genel Yapı",
                [
                  (user) => user['şahıs']!,
                  (user) => user['çekim']!,
                  (user) => user['kısa çekim']!,
                  (user) => user['olumsuz']!,
                ],
              ),
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
                [
                  (user) => user['türkçe']!,
                  (user) => user['sırpça']!,
                ],
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
              buildTable(
                gelecekZamanSampleD,
                "Örnek - biti (olmak) fiili",
                [
                  (user) => user['uzun']!,
                  (user) => user['boşnakça-hırvatça']!,
                  (user) => user['sırpça']!,
                ],
              ),
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
              buildTable(
                gelecekZamanSampleG,
                "Örnek - Reći (demek) fiili",
                [
                  (user) => user['uzun']!,
                  (user) => user['kısa']!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
