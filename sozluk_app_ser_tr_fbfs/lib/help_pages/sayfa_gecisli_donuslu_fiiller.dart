/// <----- sayfa_gecisli_donuslu_fiiller.drt ----->

import 'package:flutter/material.dart';
import 'package:sozluk_app_ser_tr_fbfs/utils/rich_text_rule.dart';

import '../constants/app_constants/const_gecisli_donuslu_fiiller.dart';
import '../help_pages/help_parts/custom_appbar.dart';
import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';
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
          padding: const EdgeInsets.all(25),
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
                context,
                gecisliDonusluFiilerTRSample,
                "Türkçe Geçişli ve Dönüşlü Fiiller",
                [
                  (user) => user['geçişli fiil']!,
                  (user) => user['dönüşlü fiil']!,
                ],
              ),

              buildTable(
                context,
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
                "'se'",
                "'se'",
                "'se'",
                "",
                context,
              ),
              buildTable(
                context,
                gecisliDonusluFiilerSampleA,
                "Zvati (çağırmak) => zvati se (çağrılmak)",
                [
                      (user) => user['şahıs']!,
                      (user) => user['fiil']!,
                      (user) => user['dönüşlü fiil']!,
                      (user) => user['Türkçe karşılığı']!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
