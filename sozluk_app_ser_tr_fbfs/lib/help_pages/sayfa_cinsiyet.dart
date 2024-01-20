/// <----- sayfa_cinsiyet.dart ----->

import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/rich_text_rule.dart';
import '../utils/text_header.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';
import 'help_parts/custom_appbar.dart';

class SayfaCinsiyet extends StatefulWidget {
  const SayfaCinsiyet({Key? key}) : super(key: key);

  @override
  State<SayfaCinsiyet> createState() => _SayfaCinsiyetState();
}

class _SayfaCinsiyetState extends State<SayfaCinsiyet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarCinsiyetTitle,
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
                "İsimlerde cinsiyette dört kural var",
                context,
                style: detailTextBlue,
              ),
              const Divider(),
              buildRichTextRule(
                "1. Kelime sessiz harf ile bitiyorsa erkek",
                dashTextA: "sessiz harf",
                dashTextB: "erkek",
                context,
              ),
              buildRichTextRule(
                "2. -a harfi ile bitiyorsa dişi,",
                dashTextA: "-a",
                dashTextB: "dişi",
                context,
              ),
              buildRichTextRule(
                "3. -o veya -e harfi ile bitiyorsa nötr,",
                dashTextA: "-o",
                dashTextB: "-e",
                dashTextC: "nötr,",
                context,
              ),
              const Divider(),
              buildTextRule(
                "Örnekler",
                context,
                style: baslikTextBlack,
              ),

              /// Kelimelerde Cinsiyet
              buildTable(
                context,
                cinsiyetSample,
                "- 'o' veya 'e' ile Bitenler",
                [
                  (user) => user['erkek']!,
                  (user) => user['dişi']!,
                  (user) => user['nötr']!,
                ],
              ),
              buildTextRule(
                "İstisnalar",
                context,
                style: baslikTextBlack,
              ),
              buildTextRule(
                "- Sto – stol (Hırvatça) (masa) – erkek",
                context,
              ),
              buildTextRule(
                "- Krv (kan) – Dişi",
                context,
              ),
              buildTextRule(
                "- Kolega (meslekdaş) – erkek",
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
