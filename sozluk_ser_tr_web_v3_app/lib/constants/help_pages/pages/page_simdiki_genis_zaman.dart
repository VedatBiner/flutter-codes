// 📜 <----- sayfa_soru.dart ----->

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_app_bar.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../../widgets/help_page_widgets/rich_text_rule.dart';
import '../../text_constants.dart';
import '../constants/const_simdiki_genis_zaman.dart';

class SayfaSimdikiGenisZaman extends StatefulWidget {
  const SayfaSimdikiGenisZaman({super.key});

  @override
  State<SayfaSimdikiGenisZaman> createState() => _SayfaSimdikiGenisZamanState();
}

/// 📌 Ana kod
class _SayfaSimdikiGenisZamanState extends State<SayfaSimdikiGenisZaman> {
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
              const Text("Şimdiki Geniş Zaman", style: detailTextBlue),
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
              buildTable(simdikiGenisZamanSampleD, "İstisnai fiiler", [
                (user) => user['-uti']!,
                (user) => user['-sti']!,
                (user) => user['-ći']!,
              ]),
              buildRichTextRule(
                "Olumsuz durumlarda fiilden önce 'ne' eklenir. Soruları ise  "
                "'da li + fiil + cümle' veya 'fiil + li + cümle'",
                dashTextA: "'ne'",
                dashTextB: "'da li + fiil + cümle'",
                dashTextC: "'fiil + li + cümle'",
                context,
              ),
              const Text("bu kuralı znati (bilmek) fiiline uygulayalım."),

              /// Çekim Grupları - 4
              buildTable(simdikiGenisZamanSampleE, "Olumsuz yapma", [
                (user) => user['fiil']!,
                (user) => user['da li']!,
                (user) => user['li']!,
              ]),
              const Divider(),

              /// Geniş zaman örnekleri
              buildTable(simdikiGenisZamanSampleF, "Čekati : Beklemek", [
                (user) => user['cümle']!,
              ]),

              /// Geniş zaman örnekleri
              buildTable(
                simdikiGenisZamanSampleG,
                "Živjeti / Živeti : Yaşamak",
                [(user) => user['cümle']!],
              ),

              /// Geniş zaman örnekleri
              buildTable(simdikiGenisZamanSampleH, "Ličiti : Benzemek", [
                (user) => user['cümle']!,
              ]),
              const Divider(),

              /// Geniş zaman örnek sorular
              buildTable(simdikiGenisZamanSampleI, "Čekati : Beklemek", [
                (user) => user['cümle']!,
              ]),

              /// Geniş zaman örnek sorular
              buildTable(
                simdikiGenisZamanSampleJ,
                "Živjeti / Živeti : Yaşamak",
                [(user) => user['cümle']!],
              ),

              /// Geniş zaman örnek sorular
              buildTable(simdikiGenisZamanSampleK, "Ličiti : Benzemek", [
                (user) => user['cümle']!,
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
