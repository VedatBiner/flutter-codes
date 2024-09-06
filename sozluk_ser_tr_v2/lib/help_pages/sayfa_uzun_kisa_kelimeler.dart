/// <----- uzun_kisa_kelimeler.drt ----->
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../constants/app_constants/drawer_constants.dart';
import '../constants/grammar_constants/const_uzun_kisa_kelimeler.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/rich_text_rule.dart';
import '../utils/text_header.dart';
import 'help_parts/build_table.dart';
import 'help_parts/custom_appbar.dart';

class SayfaUzunKisaKelimeler extends StatefulWidget {
  const SayfaUzunKisaKelimeler({super.key});

  @override
  State<SayfaUzunKisaKelimeler> createState() => _SayfaUzunKisaKelimelerState();
}

class _SayfaUzunKisaKelimelerState extends State<SayfaUzunKisaKelimeler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarUzunKisaKelimelerTitle,
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
                "Uzun / Kısa Halli Kelimeler",
                context,
                style: detailTextBlue,
              ),
              const Divider(),
              buildRichTextRule(
                "1. Kısa / uzun ayrımı olan kelimelerde, kısa kelimler "
                "cümle başını sevmez."
                "2. Olumsuz kelimler uzun kabul edilir.",
                context,
              ),
              const Divider(),
              buildRichTextRule(
                "Soru sorarken 'Da li' kalıbında kısa fiil, 'fiil + li' "
                "kalıbında uzun fiil tercih edilir.",
                context,
                dashTextA: "'Da li'",
                dashTextB: "'fiil + li'",
              ),
              buildTable(
                uzunKisaSampleA,
                "Örnek - biti (Olmak) fiili",
                [
                  (user) => user['şahıs']!,
                  (user) => user['kısa']!,
                  (user) => user['uzun']!,
                  (user) => user['olumsuz']!,
                ],
              ),
              buildTable(
                uzunKisaSampleB,
                "Şahıs zamirli ve zamirsiz kullanım",
                [
                  (user) => user['zamirli']!,
                  (user) => user['zamirsiz']!,
                  (user) => user['turkce']!,
                ],
              ),
              buildTable(
                uzunKisaSampleC,
                "da li ve fiil + li kullanım",
                [
                  (user) => user['da li']!,
                  (user) => user['fiil + li']!,
                  (user) => user['turkce']!,
                ],
              ),
              buildTable(
                uzunKisaSampleD,
                "Olumsuz hallerde uzun fiil gibi kullanılacağı için fiil + li "
                "kalıbı tercih edilir.",
                [
                  (user) => user['fiil + li']!,
                  (user) => user['turkce']!,
                ],
              ),
              buildTable(
                uzunKisaSampleE,
                "-",
                [
                  (user) => user['şahıs']!,
                  (user) => user['kısa']!,
                  (user) => user['uzun']!,
                  (user) => user['olumsuz']!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
