/// <----- sayfa_cogul.dart ----->

import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';

class SayfaCogul extends StatelessWidget {
  const SayfaCogul({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İsimlerin Çoğul Halleri"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextRule(
                "İsimlerin Çoğul Hallerinde Kurallar",
                style: detailTextBlue,
              ),
              const Divider(),
              buildTextRule(
                "1. Sessiz harf ile bitenler 'i' eklenince çoğul olurlar",
              ),
              buildTextRule(
                "2. İstisna olarak 'k' ile bitenler 'ci', 'g' ile bitenler "
                "'zi', 'h' ile bitenler 'si' ile çoğul yapılırlar. ",
              ),
              buildTextRule(
                "3. 'a' ile bitenler 'e' ile bitince çoğul olur.",
              ),
              buildTextRule(
                "4. 'o' veya 'e' harfi ile bitenler 'a' ile bitince çoğul olur.",
              ),
              buildTextRule(
                "5. 'ac' ile biten kelimelerde 'a' düşer, 'i' eklenir.",
              ),
              buildTextRule(
                "6. Genellikle tek heceli erkek cins isimlerde son harfe "
                "göre -ovi / -evi (-	C / Č / Ć / Đ / Ž / Š / J / LJ / NJ ile "
                "bitenlere) eklerinden biri eklenir.",
              ),
              const Divider(),
              const Text(
                "Örnekler",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// sessiz harfle bitenler
              buildTable(
                cogulSampleA,
                "Sessiz Harf ile Bitenler",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),

              /// "a" ile bitenler
              buildTable(
                cogulSampleB,
                "-a ile Bitenler",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),

              /// 'o' veya 'e' ile Bitenler
              buildTable(
                cogulSampleC,
                "- 'o' veya 'e' ile Bitenler",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),

              /// 'ac' ile Bitip, 'a' düşen 'i' eklenenler
              buildTable(
                cogulSampleD,
                "- 'ac' ile bitip, 'a' düşen 'i' eklenenler",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),

              /// 'ovi'  'evi' eklenenler
              buildTable(
                cogulSampleE,
                "- Tek heceli erkek isimlerde 'ovi', 'evi' eklenenler",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),

              /// Alıştırmalar
              buildTable(
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
