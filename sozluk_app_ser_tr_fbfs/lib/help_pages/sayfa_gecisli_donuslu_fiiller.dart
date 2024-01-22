/// <----- sayfa_gecisli_donuslu_fiiller.drt ----->

import 'package:flutter/material.dart';

import '../constants/app_constants/const_gecisli_donuslu_fiiller.dart';
import '../help_pages/help_parts/custom_appbar.dart';
import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/rich_text_rule.dart';
import '../utils/text_header.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';

class SayfaGecisliDonusluFiiller extends StatefulWidget {
  const SayfaGecisliDonusluFiiller({super.key});

  @override
  State<SayfaGecisliDonusluFiiller> createState() =>
      _SayfaGecisliDonusluFiillerState();
}

class _SayfaGecisliDonusluFiillerState
    extends State<SayfaGecisliDonusluFiiller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarGecisliDonusluFillerTitle,
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
                "Geçişli ve Dönüşlü Fiiller",
                context,
                style: detailTextBlue,
              ),
              const Divider(),
              buildTextRule(
                "Geçişli fiiller nesne alabilen fiillerdir. "
                "Yani yaptığımız iş bir şeyi etkiler. Eylem "
                "kendimize geri dönüyorsa dönüşlü fiil olur. "
                "Latin ve Slav dillerinde dönüşlü fiiller "
                "önemli yer tutar. ",
                context,
              ),

              /// Türkçe geçişli ve dönüşlü fiiller
              buildTable(
                gecisliDonusluFiilerTRSample,
                "Türkçe Geçişli ve Dönüşlü Fiiller",
                [
                  (user) => user['geçişli fiil']!,
                  (user) => user['dönüşlü fiil']!,
                ],
              ),

              buildTable(
                gecisliDonusluFiilerSample,
                "Buditi (uyandırmak) => buditi se (uyanmak)",
                [
                  (user) => user['şahıs']!,
                  (user) => user['fiil']!,
                  (user) => user['dönüşlü fiil']!,
                  (user) => user['Türkçe karşılığı']!,
                ],
              ),
              buildRichTextRule(
                "'se' eklemesi ile geçişli fiil dönüşlü fiile çevriliyor. "
                "Şahıs zamiri ile birlikte kullanıyorsak 'se' fiilden "
                "önce olmalıdır. Şahıs zamiri kullanılmayınca ise 'se' "
                "eklemesi fiilden sonra olacaktır.",
                dashTextA: "'se'",
                dashTextB: "'se'",
                dashTextC: "'se'",
                context,
              ),
              buildTable(
                gecisliDonusluFiilerSampleA,
                "Zvati (çağırmak) => zvati se (çağrılmak)",
                [
                  (user) => user['şahıs']!,
                  (user) => user['fiil']!,
                  (user) => user['dönüşlü fiil']!,
                  (user) => user['Türkçe karşılığı']!,
                ],
              ),
              buildRichTextRule(
                "'zvati' kelimesi, 'adım ...' şeklinde kullanılıyor.",
                dashTextA: "'zvati'",
                dashTextB: "'adım ...'",
                context,
              ),
              const Divider(),

              /// Evet hayır soruları
              buildTextRule(
                "Evet Hayır Soruları ",
                style: baslikTextBlack,
                context,
              ),
              buildTable(
                gecisliDonusluFiilerSampleB,
                "Evet / Hayır soru kalıpları",
                [
                  (user) => user['kalıp1']!,
                  (user) => user['kalıp2']!,
                ],
              ),
              buildRichTextRule(
                "'Da li' kalıbında 'se' dönüşlü fiilden önce gelirse sorun olmaz.",
                dashTextA: "'Da li'",
                dashTextB: "'se'",
                context,
              ),
              buildRichTextRule(
                "'(fiil) + li' kalıbında ise, fiilin başına 'se' gelemez.",
                dashTextA: "'(fiil) + li'",
                dashTextB: "'se'",
                context,
              ),
              buildRichTextRule(
                "Bu yüzden 'dönüşlü fiil' başta olup, 'li' ve sonra 'se' ile cümle devam ediyor.",
                dashTextA: "'dönüşlü fiil'",
                dashTextB: "'li'",
                dashTextC: "'se'",
                context,
              ),
              buildTextRule(
                "Örnek :  ",
                style: baslikTextBlack,
                context,
              ),
              buildTable(
                gecisliDonusluFiilerSampleC,
                "Evet / Hayır soru kalıpları - Örnek",
                [
                  (user) => user['sırpça']!,
                  (user) => user['türkçe']!,
                ],
              ),
              const Divider(),

              /// sık kullanılan 7 fiil - 1
              buildTable(
                gecisliDonusluFiilerSampleD,
                "sık kullanılan 7 fiil - 1",
                [
                  (user) => user['şahıs']!,
                  (user) => user['fiil1']!,
                  (user) => user['fiil2']!,
                  (user) => user['fiil3']!,
                ],
              ),

              /// sık kullanılan 7 fiil - 2
              buildTable(
                gecisliDonusluFiilerSampleE,
                "sık kullanılan 7 fiil - 2",
                [
                  (user) => user['şahıs']!,
                  (user) => user['fiil4']!,
                  (user) => user['fiil5']!,
                  (user) => user['fiil6']!,
                ],
              ),

              /// sık kullanılan 7 fiil - 3
              buildTable(
                gecisliDonusluFiilerSampleF,
                "sık kullanılan 7 fiil - 3",
                [
                      (user) => user['şahıs']!,
                      (user) => user['fiil7']!,
                ],
              ),
              buildRichTextRule(
                "(*) 'Razumeti' de lehçe farkı var. Sağdakiler Boşnakça ve Hırvatça kalıbı",
                dashTextA: "'Razumeti'",
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
