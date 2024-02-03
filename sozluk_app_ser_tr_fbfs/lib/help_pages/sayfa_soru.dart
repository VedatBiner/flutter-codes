/// <----- sayfa_soru.dart ----->
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/const_soru.dart';
import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';

import '../utils/text_header.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';
import 'help_parts/custom_appbar.dart';

class SayfaSoru extends StatefulWidget {
  const SayfaSoru({super.key});

  @override
  State<SayfaSoru> createState() => _SayfaSoruState();
}

class _SayfaSoruState extends State<SayfaSoru> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appbarSoruTitle,
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
                "Soru Cümleleri",
                context,
                style: detailTextBlue,
              ),
              const Divider(),
              buildTextRule(
                "Türkçe ‘deki soru yapıları – evet hayır şeklinde "
                "cevap verilemeyenler",
                context,
                style: baslikTextBlack,
              ),
              buildTextRule(
                "- Ne zaman geleceksin ?",
                context,
              ),
              buildTextRule(
                "- Nasıl gidiyor ?",
                context,
              ),
              buildTextRule(
                "Evet – hayır cevabı verilebilenler.",
                context,
                style: baslikTextBlack,
              ),
              buildTextRule(
                "- Geldin mi?",
                context,
              ),
              buildTextRule(
                "- Düşünüyor musun?",
                context,
              ),
              buildTextRule(
                "- Öğrenci misin?",
                context,
              ),
              const Divider(),
              buildTextRule(
                "İki kural var.",
                context,
                style: baslikTextBlack,
              ),
              buildTextRule(
                "1. Da li + fiil + cümle",
                context,
              ),
              buildTextRule(
                "2.	Uzun fiil + li + cümle",
                context,
              ),
              buildTextRule(
                "Genellikle 1. kural uygulanır.",
                context,
              ),
              const Divider(),
              buildTextRule(
                "Örneğin student için yapalım.",
                context,
              ),

              /// soru cümleleri
              buildTable(
                sorularSample,
                "Soru cümleleri",
                [
                  (user) => user['cümle']!,
                  (user) => user['soru (li)']!,
                  (user) => user['soru (da li)']!,
                ],
              ),
              buildTextRule(
                "(*) Burada parantez içindekilerin kullanımı zorunlu değildir",
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
