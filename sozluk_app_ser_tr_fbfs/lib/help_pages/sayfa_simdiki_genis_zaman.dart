/// <----- sayfa_soru.dart ----->

import 'package:flutter/material.dart';

import '../constants/app_constants/const_simdiki_genis_zaman.dart';
import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';

import '../utils/text_header.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';
import 'help_parts/custom_appbar.dart';

class SimdikiGenisZaman extends StatefulWidget {
  const SimdikiGenisZaman({super.key});

  @override
  State<SimdikiGenisZaman> createState() => _SimdikiGenisZamanState();
}

class _SimdikiGenisZamanState extends State<SimdikiGenisZaman> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarSimdikiGenisZamantitle,
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
                "Şimdiki Geniş Zaman",
                context,
                style: detailTextBlue,
              ),
              const Divider(),

              /// Şimdiki Geniş Zaman
              buildTable(
                context,
                simdikiGenisZamanSampleA,
                "Şimdiki Geniş Zaman Yapısı",
                [
                  (user) => user['Türkçe Fiiller']!,
                  (user) => user['B/H/S Fiiller']!,
                ],
              ),
              buildTextRule(
                "Fiil çekimleme Kuralı :  ti / ći atılır. Çekim "
                "grubuna göre ekler eklenir. ",
                context,
              ),
              const Divider(),

              /// Çekim Grupları - 1
              buildTable(
                context,
                simdikiGenisZamanSampleB,
                "Şimdiki Geniş Zaman Çekim Grupları",
                [
                  (user) => user['zamir']!,
                  (user) => user['-ati']!,
                  (user) => user['-eti']!,
                  (user) => user['-iti']!,
                ],
              ),

              /// Çekim Grupları - 2
              buildTable(
                context,
                simdikiGenisZamanSampleC,
                "Şimdiki Geniş Zaman Çekim Grupları - Örnek",
                [
                  (user) => user['-ati']!,
                  (user) => user['-eti']!,
                  (user) => user['-iti']!,
                ],
              ),
              buildTextRule(
                "Çoğunlukla kullanılan yapı :  -ati, -eti, -iti ile biter. "
                "Ancak istisnai olarak, -uti, -sti, -ći ile biten filler de bulunur.",
                context,
              ),

              /// Çekim Grupları - 3
              buildTable(
                context,
                simdikiGenisZamanSampleD,
                "İstisnai fiiler",
                [
                  (user) => user['-uti']!,
                  (user) => user['-sti']!,
                  (user) => user['-ći']!,
                ],
              ),

              buildTextRule(
                "Olumsuz durumlarda fiilden önce 'ne' eklenir. Soruları ise"
                " 'da li + fiil + cümle' veya 'fiil + li + cümle'",
                context,
              ),
              buildTextRule(
                "bu kuralı znati (bilmek) fiiline uygulayalım.",
                context,
              ),

              /// Çekim Grupları - 4
              buildTable(
                context,
                simdikiGenisZamanSampleE,
                "Olumsuz yapma",
                [
                  (user) => user['fiil']!,
                  (user) => user['da li']!,
                  (user) => user['li']!,
                ],
              ),
              const Divider(),

              /// Geniş zaman örnekleri
              buildTable(
                context,
                simdikiGenisZamanSampleF,
                "Čekati : Beklemek",
                [
                      (user) => user['cümle']!,
                ],
              ),

              /// Geniş zaman örnekleri
              buildTable(
                context,
                simdikiGenisZamanSampleG,
                "Živjeti / Živeti : Yaşamak",
                [
                      (user) => user['cümle']!,
                ],
              ),

              /// Geniş zaman örnekleri
              buildTable(
                context,
                simdikiGenisZamanSampleH,
                "Ličiti : Benzemek",
                [
                      (user) => user['cümle']!,
                ],
              ),
              const Divider(),

              /// Geniş zaman örnek sorular
              buildTable(
                context,
                simdikiGenisZamanSampleI,
                "Čekati : Beklemek",
                [
                      (user) => user['cümle']!,
                ],
              ),

              /// Geniş zaman örnek sorular
              buildTable(
                context,
                simdikiGenisZamanSampleJ,
                "Živjeti / Živeti : Yaşamak",
                [
                      (user) => user['cümle']!,
                ],
              ),

              /// Geniş zaman örnek sorular
              buildTable(
                context,
                simdikiGenisZamanSampleK,
                "Ličiti : Benzemek",
                [
                      (user) => user['cümle']!,
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
