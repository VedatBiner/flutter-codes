/// <----- sayfa_soru.dart ----->
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/drawer_constants.dart';
import '../constants/grammar_constants/const_simdiki_genis_zaman.dart';
import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/text_header.dart';
import '../utils/text_rule.dart';
import '../utils/rich_text_rule.dart';
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
        appBarTitle: appBarSimdikiGenisZamanTitle,
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
                "Şimdiki Geniş Zaman",
                context,
                style: detailTextBlue,
              ),
              const Divider(),

              /// Şimdiki Geniş Zaman
              buildTable(
                simdikiGenisZamanSampleA,
                "Şimdiki Geniş Zaman Yapısı",
                [
                  (user) => user['Türkçe Fiiller']!,
                  (user) => user['B/H/S Fiiller']!,
                ],
              ),
              buildRichTextRule(
                "Fiil çekimleme Kuralı :  'ti / ći' atılır. "
                "Çekim grubuna göre ekler eklenir. ",
                dashTextA: "'ti / ći'",
                context,
              ),
              buildRichTextRule(
                "-ati, -eti, -iti (son üç harfine göre) olarak fiilleri üç "
                    "gruba ayırıyoruz. -ati ile biten fiiller bazen -eti "
                    "ile biten fiil kurallarına da uyabilir.",
                dashTextA: "-ati, -eti, -iti",
                dashTextB: "-ati",
                dashTextC: "-eti",
                context,
              ),
              const Divider(),

              /// Çekim Grupları - 1
              buildTable(
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
                simdikiGenisZamanSampleC,
                "Şimdiki Geniş Zaman Çekim Grupları - Örnek",
                [
                  (user) => user['-ati']!,
                  (user) => user['-eti']!,
                  (user) => user['-iti']!,
                ],
              ),
              buildRichTextRule(
                "Çoğunlukla kullanılan yapı :  '-ati, -eti, -iti' ile biter. "
                "Ancak istisnai olarak, '-uti, -sti, -ći' ile "
                "biten filler de bulunur.",
                dashTextA: "'-ati, -eti, -iti'",
                dashTextB: "istisnai ",
                dashTextC: "'-uti, -sti, -ći'",
                context,
              ),

              buildTable(
                simdikiGenisZamanSampleCA,
                "Şimdiki Geniş Zaman Çekim Grupları - Örnek Spavati (uyumak) ve "
                    "mrziti (nefret etmek) fiileri",
                [
                      (user) => user['şahıs']!,
                      (user) => user['spavati']!,
                      (user) => user['mrziti']!,
                ],
              ),


              /// Çekim Grupları - 3
              buildTable(
                simdikiGenisZamanSampleD,
                "İstisnai fiiler",
                [
                  (user) => user['-uti']!,
                  (user) => user['-sti']!,
                  (user) => user['-ći']!,
                ],
              ),
              buildRichTextRule(
                "Olumsuz durumlarda fiilden önce 'ne' eklenir. Soruları ise  "
                "'da li + fiil + cümle' veya 'fiil + li + cümle'",
                dashTextA: "'ne'",
                dashTextB: "'da li + fiil + cümle'",
                dashTextC: "'fiil + li + cümle'",
                context,
              ),
              buildTextRule(
                "bu kuralı znati (bilmek) fiiline uygulayalım.",
                context,
              ),

              /// Çekim Grupları - 4
              buildTable(
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
                simdikiGenisZamanSampleF,
                "Čekati : Beklemek",
                [
                  (user) => user['cümle']!,
                ],
              ),

              /// Geniş zaman örnekleri
              buildTable(
                simdikiGenisZamanSampleG,
                "Živjeti / Živeti : Yaşamak",
                [
                  (user) => user['cümle']!,
                ],
              ),

              /// Geniş zaman örnekleri
              buildTable(
                simdikiGenisZamanSampleH,
                "Ličiti : Benzemek",
                [
                  (user) => user['cümle']!,
                ],
              ),
              const Divider(),

              /// Geniş zaman örnek sorular
              buildTable(
                simdikiGenisZamanSampleI,
                "Čekati : Beklemek",
                [
                  (user) => user['cümle']!,
                ],
              ),

              /// Geniş zaman örnek sorular
              buildTable(
                simdikiGenisZamanSampleJ,
                "Živjeti / Živeti : Yaşamak",
                [
                  (user) => user['cümle']!,
                ],
              ),

              /// Geniş zaman örnek sorular
              buildTable(
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
