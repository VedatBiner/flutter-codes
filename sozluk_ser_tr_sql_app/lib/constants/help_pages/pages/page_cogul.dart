// 📜 <----- sayfa_cogul.dart ----->

import 'package:flutter/material.dart';
import 'package:sozluk_ser_tr_sql_app/widgets/help_page_widgets/help_custom_app_bar.dart';
import 'package:sozluk_ser_tr_sql_app/widgets/help_page_widgets/help_custom_drawer.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/rich_text_rule.dart';
import '../../text_constants.dart';
import '../constants/const_cogul.dart';

class SayfaCogul extends StatefulWidget {
  const SayfaCogul({super.key});

  @override
  State<SayfaCogul> createState() => _SayfaCogulState();
}

/// 📌 Ana kod
class _SayfaCogulState extends State<SayfaCogul> {
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
              const Text(
                "İsimlerin Çoğul Hallerinde Kurallar",
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
                context,
              ),
              buildRichTextRule(
                "6. 'o' veya 'e' harfi ile bitenler 'a' ile bitince çoğul olur.",
                dashTextA: "'o' veya 'e'",
                dashTextB: "'a'",
                dashTextC: "çoğul",
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
              const Text("Örnekler", style: normalBlackText),

              /// sessiz harfle bitenler
              buildTable(cogulSampleA, "Sessiz Harf ile Bitenler", [
                (user) => user['tekil']!,
                (user) => user['çoğul']!,
              ]),

              /// "a" ile bitenler
              buildTable(cogulSampleB, "-a ile Bitenler", [
                (user) => user['tekil']!,
                (user) => user['çoğul']!,
              ]),

              /// 'o' veya 'e' ile Bitenler
              buildTable(cogulSampleC, "- 'o' veya 'e' ile Bitenler", [
                (user) => user['tekil']!,
                (user) => user['çoğul']!,
              ]),

              /// 'ac' ile Bitip, 'a' düşen 'i' eklenenler
              buildTable(
                cogulSampleD,
                "- 'ac' ile bitip, 'a' düşen 'i' eklenenler",
                [(user) => user['tekil']!, (user) => user['çoğul']!],
              ),

              /// 'ovi'  'evi' eklenenler
              buildTable(
                cogulSampleE,
                "- Tek heceli erkek isimlerde 'ovi', 'evi' eklenenler",
                [(user) => user['tekil']!, (user) => user['çoğul']!],
              ),

              /// Alıştırmalar
              buildTable(cogulSampleF, "- Alıştırma Kelimeleri", [
                (user) => user['tekil']!,
                (user) => user['çoğul']!,
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
