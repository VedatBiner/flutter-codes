/// <----- sayfa_saatler.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:sozluk_ser_tr_sql_app/widgets/help_page_widgets/help_custom_app_bar.dart';

import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../../widgets/help_page_widgets/rich_text_rule.dart';
import '../../text_constants.dart';

class SayfaSaatler extends StatefulWidget {
  const SayfaSaatler({super.key});

  @override
  State<SayfaSaatler> createState() => _SayfaSaatlerState();
}

/// 📌 Ana kod
class _SayfaSaatlerState extends State<SayfaSaatler> {
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
              const Text("Saatler", style: detailTextBlue),
              const Divider(),

              buildRichTextRule(
                "Koliko je sati ?  - saat kaç?",
                dashTextA: "Koliko je sati ?",
                context,
              ),
              const Text("saat bu şekilde soruluyor.", style: normalBlackText),
              const SizedBox(height: 10),
              buildRichTextRule(
                "1 sat - Jedan (čas)  - 1 saat için kullanılır.",
                dashTextA: "1 sat - Jedan (čas)",
                context,
              ),
              buildRichTextRule(
                "2, 3, 4,  - Eğer saat değeri bu aralıkta ise sata kullanılır.",
                dashTextA: "2, 3, 4,",
                dashTextB: 'sata',
                context,
              ),
              buildRichTextRule(
                "5, 6, ... sati veya časova - çoğunlukla sati kullanılır. ",
                dashTextA: "5, 6, ...",
                dashTextB: 'sati',
                dashTextC: 'časova',
                dashTextD: 'sati',
                context,
              ),
              const SizedBox(height: 10),
              buildRichTextRule(
                "saat bu şekilde sorulduğunda tam saat ise,\nÖrneğin saat 1 "
                "ise tačno je jedan sat olarak cevap verilebilir.\nAncak "
                "çoğunlukla kısa cevap olarak jedan sat gibi cevap verilir.",
                dashTextA: "tačno je jedan sat",
                dashTextB: 'jedan sat ',
                context,
              ),
              const SizedBox(height: 10),
              buildRichTextRule(
                "13:25 – trinaest i dvadesetpet / jedan i dvadeset pet - "
                "\n13:25 anlamına gelir. Resmi ortamlarda tercih edilir. "
                "\n1:25 anlamına gelir. Günlük konuşmalarda tercih edilir.",
                dashTextA: "trinaest i dvadesetpet",
                dashTextB: 'jedan i dvadeset pet ',
                dashTextC: '13:25 anlamına gelir',
                dashTextD: '1:25 anlamına gelir',
                context,
              ),
              const SizedBox(height: 10),
              buildRichTextRule(
                "Saatlerde i kullanılınca geçiyor anlamı verir. \nÖrneğin "
                "tri i deset  (tri sata i deset minuta) – üçü yirmi geçiyor gibi.",
                dashTextA: "i",
                dashTextB: 'geçiyor',
                dashTextC: 'tri i deset  (tri sata i deset minuta)',
                context,
              ),
              const SizedBox(height: 10),
              buildRichTextRule(
                "Saatlerde do kullanılırsa kala anlamı veriyor. "
                "\nÖrneğin petnaest do tri, üçe çeyrek kala, şeklinde söyleniyor.",
                dashTextA: "do",
                dashTextB: 'kala',
                dashTextC: 'petnaest do tri',
                context,
              ),
              const SizedBox(height: 10),
              const Text("Örnekler - 1", style: normalBlackText),

              buildRichTextRule(
                "14:20 – četirinaest i dvadest / dva i dvadeset - İkiyi yirmi geçiyor",
                dashTextA: "14:20",
                dashTextB: 'İkiyi yirmi geçiyor',
                context,
              ),

              buildRichTextRule(
                "19:05 – devetnaest i pet / sedam i pet - Yediyi beş geçiyor",
                dashTextA: "19:05",
                dashTextB: 'Yediyi beş geçiyor',
                context,
              ),

              buildRichTextRule(
                "18:30 – osamnaest i trideset / osam i trideset - \nAltıyı otuz geçiyor (altı buçuk)",
                dashTextA: "18:30",
                dashTextB: '\nAltıyı otuz geçiyor (altı buçuk)',
                context,
              ),

              buildRichTextRule(
                "22:15 – dvadeset dva i petnaest / deset i petnaest - \nOnu çeyrek geçiyor",
                dashTextA: "22:15",
                dashTextB: '\nOnu çeyrek geçiyor',
                context,
              ),

              buildRichTextRule(
                "18:35 – dvadeset pet do sedam je - yediye yirmi beş var",
                dashTextA: "18:35",
                dashTextB: 'yediye yirmi beş var',
                context,
              ),

              buildRichTextRule(
                "12:00 – dvanaest sati u podne - öğlen oniki",
                dashTextA: "12:00",
                dashTextB: 'öğlen oniki',
                context,
              ),

              buildRichTextRule(
                "24:00 – dvanaest u ponoć ( ya da sadece ponoć) - gece on iki",
                dashTextA: "24:00",
                dashTextB: 'gece on iki',
                context,
              ),

              buildRichTextRule(
                "20:50 – deset do devet - dokuza on var",
                dashTextA: "20:50",
                dashTextB: 'dokuza on var',
                context,
              ),

              buildRichTextRule(
                "19:30 – pola osam ( sedam i trideset) - yedi buçuk",
                dashTextA: "19:30",
                dashTextB: 'yedi buçuk',
                context,
              ),

              const SizedBox(height: 10),
              const Text("Örnekler - 2", style: normalBlackText),

              buildRichTextRule(
                "u Podgorici je 12 sati   - Podgorica 'da saat 12.",
                dashTextA: "u Podgorici je 12 sati",
                context,
              ),

              buildRichTextRule(
                "u Njujorku je 7 sati ujutro - New York 'ta saat sabah 7",
                dashTextA: "u Njujorku je 7 sati ujutro",
                context,
              ),

              buildRichTextRule(
                "u moskvi je 2 sata poslije podna - Moskova 'da saat öğleden sonra 2",
                dashTextA: "u moskvi je 2 sata poslije podna",
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
