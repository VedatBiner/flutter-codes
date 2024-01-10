/// <----- sayfa_cogul.dart ----->

import 'package:flutter/material.dart';

import '../constants/app_constants/const_cogul.dart';
import '../constants/app_constants/constants.dart';
import '../constants/base_constants/app_const.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/text_rule.dart';
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
      drawer: buildDrawer(
        context,
        themeChangeCallback: () {
          setState(
            () {
              AppConst.listener.themeNotifier.changeTheme();
            },
          );
        },
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
                context,
                style: detailTextBlue,
              ),
              const Divider(),
              buildTextRule(
                "1. Sessiz harf ile bitenler 'i' eklenince çoğul olurlar",
                context,
              ),
              buildTextRule(
                "2. İstisna olarak 'k' ile bitenler 'ci', 'g' ile bitenler "
                "'zi', 'h' ile bitenler 'si' ile çoğul yapılırlar. ",
                context,
              ),
              buildTextRule(
                "3. 'a' ile bitenler 'e' ile bitince çoğul olur.",
                context,
              ),
              buildTextRule(
                "4. 'o' veya 'e' harfi ile bitenler 'a' ile bitince çoğul olur.",
                context,
              ),
              buildTextRule(
                "5. 'ac' ile biten kelimelerde 'a' düşer, 'i' eklenir.",
                context,
              ),
              buildTextRule(
                "6. Genellikle tek heceli erkek cins isimlerde son harfe "
                "göre -ovi / -evi (-	C / Č / Ć / Đ / Ž / Š / J / LJ / NJ ile "
                "bitenlere) eklerinden biri eklenir.",
                context,
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
