/// <----- sayfa_soru.dart ----->

import 'package:flutter/material.dart';

import '../constants/app_constants/const_soru.dart';
import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';

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
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextRule(
                "Soru Cümleleri",
                context,
                style: detailTextBlue,
              ),
              const Divider(),
              const Text(
                "Türkçe ‘deki soru yapıları – evet hayır şeklinde "
                "cevap verilemeyenler",
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
              const Text(
                "Evet – hayır cevabı verilebilenler.",
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
              const Text(
                "İki kural var.",
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
                context,
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
