/// <----- sayfa_soru.dart ----->

import 'package:flutter/material.dart';

import '../constants/const_simdiki_genis_zaman.dart';
import '../constants/constants.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';

class SimdikiGenisZaman extends StatelessWidget {
  const SimdikiGenisZaman({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Şimdiki Geniş Zaman"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextRule(
                "Şimdiki Geniş Zaman",
                style: detailTextBlue,
              ),
              const Divider(),

              /// Şimdiki Geniş Zaman
              buildTable(
                simdikiGenisZamanSample,
                "Şimdiki Geniş Zaman Yapısı",
                [
                  (user) => user['Türkçe Fiiler']!,
                  (user) => user['B/H/S Fiiler']!,
                ],
              ),
              buildTextRule(
                "Fiil çekimleme Kuralı :  ti / ći atılır. Çekim "
                "grubuna göre ekler eklenir. ",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
