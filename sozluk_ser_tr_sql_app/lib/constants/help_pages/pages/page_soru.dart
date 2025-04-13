// 📜 <----- sayfa_soru.dart ----->

import 'package:flutter/material.dart';
import 'package:sozluk_ser_tr_sql_app/widgets/help_page_widgets/help_custom_app_bar.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../text_constants.dart';
import '../constants/const_soru.dart';

class SayfaSoru extends StatefulWidget {
  const SayfaSoru({super.key});

  @override
  State<SayfaSoru> createState() => _SayfaSoruState();
}

/// 📌 Ana kod
class _SayfaSoruState extends State<SayfaSoru> {
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
            const Text("Soru Cümleleri", style: detailTextBlue),
            const Divider(),
            const Text(
              "Türkçe ‘deki soru yapıları – evet hayır şeklinde "
              "cevap verilemeyenler",
              style: normalBlackText,
            ),
            const Text("- Ne zaman geleceksin ?"),
            const Text("- Nasıl gidiyor ?"),
            const Text(
              "Evet – hayır cevabı verilebilenler.",
              style: normalBlackText,
            ),
            const Text("- Geldin mi?"),
            const Text("- Düşünüyor musun?"),
            const Text("- Öğrenci misin?"),
            const Divider(),
            const Text("İki kural var.", style: normalBlackText),
            const Text("1. Da li + fiil + cümle"),
            const Text("2.	Uzun fiil + li + cümle"),
            const Text("Genellikle 1. kural uygulanır."),
            const Divider(),
            const Text("Örneğin student için yapalım."),

            /// soru cümleleri
            buildTable(sorularSample, "Soru cümleleri", [
              (user) => user['cümle']!,
              (user) => user['soru (li)']!,
              (user) => user['soru (da li)']!,
            ]),
            const Text(
              "(*) Burada parantez içindekilerin kullanımı zorunlu değildir",
            ),
          ],
        ),
      ),
    );
  }
}
