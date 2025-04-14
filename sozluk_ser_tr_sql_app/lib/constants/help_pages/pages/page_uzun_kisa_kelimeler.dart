// 📜 <----- uzun_kisa_kelimeler.drt ----->

import 'package:flutter/material.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_app_bar.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../../widgets/help_page_widgets/rich_text_rule.dart';
import '../../text_constants.dart';
import '../constants/const_uzun_kisa_kelimeler.dart';

class SayfaUzunKisaKelimeler extends StatefulWidget {
  const SayfaUzunKisaKelimeler({super.key});

  @override
  State<SayfaUzunKisaKelimeler> createState() => _SayfaUzunKisaKelimelerState();
}

/// 📌 Ana kod
class _SayfaUzunKisaKelimelerState extends State<SayfaUzunKisaKelimeler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHelpAppBar(),
      drawer: buildHelpDrawer(),
      body: buildBody(context),
    );
  }

  /// 📌 Body bloğu
  SingleChildScrollView buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Uzun / Kısa Halli Kelimeler", style: detailTextBlue),
            const Divider(),
            const Text(
              "1. Kısa / uzun ayrımı olan kelimelerde, kısa kelimler "
              "cümle başını sevmez."
              "2. Olumsuz kelimler uzun kabul edilir.",
            ),
            const Divider(),
            buildRichTextRule(
              "Soru sorarken 'Da li' kalıbında kısa fiil, 'fiil + li' "
              "kalıbında uzun fiil tercih edilir.",
              context,
              dashTextA: "'Da li'",
              dashTextB: "'fiil + li'",
            ),
            buildTable(uzunKisaSampleA, "Örnek - biti (Olmak) fiili", [
              (user) => user['şahıs']!,
              (user) => user['kısa']!,
              (user) => user['uzun']!,
              (user) => user['olumsuz']!,
            ]),
            buildTable(uzunKisaSampleB, "Şahıs zamirli ve zamirsiz kullanım", [
              (user) => user['zamirli']!,
              (user) => user['zamirsiz']!,
              (user) => user['turkce']!,
            ]),
            buildTable(uzunKisaSampleC, "da li ve fiil + li kullanım", [
              (user) => user['da li']!,
              (user) => user['fiil + li']!,
              (user) => user['turkce']!,
            ]),
            buildTable(
              uzunKisaSampleD,
              "Olumsuz hallerde uzun fiil gibi kullanılacağı için fiil + li "
              "kalıbı tercih edilir.",
              [(user) => user['fiil + li']!, (user) => user['turkce']!],
            ),
            buildTable(uzunKisaSampleE, "-", [
              (user) => user['şahıs']!,
              (user) => user['kısa']!,
              (user) => user['uzun']!,
              (user) => user['olumsuz']!,
            ]),
          ],
        ),
      ),
    );
  }
}
