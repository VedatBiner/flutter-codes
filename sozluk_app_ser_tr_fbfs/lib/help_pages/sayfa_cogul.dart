/// <----- sayfa_cogul.dart ----->

import 'package:flutter/material.dart';

import '../constants/app_constants/const_cogul.dart';
import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/text_header.dart';
import '../utils/text_rule.dart';
import '../utils/rich_text_rule.dart';
import 'help_parts/build_table.dart';
import 'help_parts/custom_appbar.dart';

class SayfaCogul extends StatefulWidget {
  const SayfaCogul({Key? key}) : super(key: key);

  @override
  State<SayfaCogul> createState() => _SayfaCogulState();
}

class _SayfaCogulState extends State<SayfaCogul> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarCogulTitle,
      ),
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextHeader(
                "İsimlerin Çoğul Hallerinde Kurallar",
                context,
                style: detailTextBlue,
              ),
              const Divider(),
              buildRichTextRule(
                "1. Sessiz harf ile bitenler 'i' eklenince çoğul olurlar",
                dashTextA: "Sessiz harf",
                dashTextB: "'i'",
                dashTextC: "çoğul",
                context,
              ),
              buildRichTextRule(
                "2. İstisna olarak 'k' ile bitenler 'ci',",
                dashTextA: "'k'",
                dashTextB: "'ci'",
                context,
              ),
              buildRichTextRule(
                "3. 'g' ile bitenler, 'zi',",
                dashTextA: "'g'",
                dashTextC: "'zi'",
                context,
              ),
              buildRichTextRule(
                "4. 'h' ile bitenler 'si' ile çoğul yapılırlar.",
                dashTextA: "'h'",
                dashTextB: "'si'",
                dashTextC: "çoğul",
                context,
              ),
              buildRichTextRule(
                "5. 'a' ile bitenler 'e' ile bitince çoğul olur.",
                dashTextA: "'a'",
                dashTextB: "'e'",
                dashTextC: "çoğul",
                // "",
                context,
              ),
              buildRichTextRule(
                "6. 'o' veya 'e' harfi ile bitenler 'a' ile bitince çoğul olur.",
                dashTextA: "'o' veya 'e'",
                dashTextB: "'a'",
                dashTextC: "çoğul",
                // "",
                context,
              ),
              buildRichTextRule(
                "7. 'ac' ile biten kelimelerde 'a' düşer, 'i' eklenir ve çoğul olur.",
                dashTextA: "'ac'",
                dashTextB: "'a'",
                dashTextC: "'i'",
                dashTextD: "çoğul",
                context,
              ),
              buildRichTextRule(
                "8. Genellikle tek heceli erkek cins isimlerde son harfe göre "
                "'-ovi' / '-evi' (C / Č / Ć / Đ / Ž / Š / J / LJ / NJ ile "
                "bitenlere) eklerinden biri eklenir.",
                dashTextA: "tek heceli erkek",
                dashTextB: "son harfe",
                dashTextC: "'-ovi'",
                dashTextD:
                    "'-evi' (C / Č / Ć / Đ / Ž / Š / J / LJ / NJ ile bitenlere)",
                context,
              ),
              const Divider(),
              buildTextRule(
                "Örnekler",
                context,
                style: baslikTextBlack,
              ),

              /// sessiz harfle bitenler
              buildTable(
                context,
                cogulSampleA,
                "Sessiz Harf ile Bitenler",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),

              /// "a" ile bitenler
              buildTable(
                context,
                cogulSampleB,
                "-a ile Bitenler",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),

              /// 'o' veya 'e' ile Bitenler
              buildTable(
                context,
                cogulSampleC,
                "- 'o' veya 'e' ile Bitenler",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),

              /// 'ac' ile Bitip, 'a' düşen 'i' eklenenler
              buildTable(
                context,
                cogulSampleD,
                "- 'ac' ile bitip, 'a' düşen 'i' eklenenler",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),

              /// 'ovi'  'evi' eklenenler
              buildTable(
                context,
                cogulSampleE,
                "- Tek heceli erkek isimlerde 'ovi', 'evi' eklenenler",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),

              /// Alıştırmalar
              buildTable(
                context,
                cogulSampleF,
                "- Alıştırma Kelimeleri",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
