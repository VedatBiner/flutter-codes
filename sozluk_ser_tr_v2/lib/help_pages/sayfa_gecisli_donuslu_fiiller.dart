/// <----- sayfa_gecisli_donuslu_fiiller.drt ----->
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/drawer_constants.dart';
import '../constants/grammar_constants/const_gecisli_donuslu_fiiller.dart';
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
                "Bu yüzden 'dönüşlü fiil' başta olup, 'li' ve sonra 'se' "
                "ile cümle devam ediyor.",
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

              /// htjeti / hteti (istemek) Fiili
              buildTable(
                gecisliDonusluFiilerSampleG,
                "htjeti / hteti (istemek) Fiili",
                [
                  (user) => user['şahıs']!,
                  (user) => user['istemek']!,
                  (user) => user['istememek']!,
                ],
              ),
              buildRichTextRule(
                "Düzensiz bir fiildir. Olumsuz yapma kuralına da uymaz. Olumsuz "
                "yapılınca istisna olarak baştaki ‘ho’ atılıp ‘ne’ eklenir. "
                "İngilizcedeki will gelecek zamanı ile benzer kullanımı vardır."
                "Bu fiil daha çok arzu etmek / arzulamak anlamında kullanılır.",
                dashTextA: "‘ho’ ",
                dashTextB: "‘ne’",
                context,
              ),

              /// voljeti / voleti (sevmek) ve željeti / želeti (istemek) fiili
              buildTable(
                gecisliDonusluFiilerSampleH,
                "voljeti / voleti (sevmek) ve željeti / želeti (istemek) fiili",
                [
                  (user) => user['şahıs']!,
                  (user) => user['sevmek']!,
                  (user) => user['istemek']!,
                ],
              ),
              buildRichTextRule(
                "'Özneleri aynı olan Yardımcı Filler:' Konuşmayı seviyorum, "
                "Yürümek istiyorum, Yemek yemek istiyor ...",
                dashTextA: "'Özneleri aynı olan Yardımcı Filler:'",
                context,
              ),
              buildRichTextRule(
                "'Özneleri farklı olan Yardımcı Filler:' Konuşmanı seviyorum, "
                "Yürümelerini istiyorum, Yemek yememi istiyorsun ...",
                dashTextA: "'Özneleri farklı olan Yardımcı Filler:'",
                context,
              ),
              const Divider(),
              buildRichTextRule(
                "Bir cümlede birden fazla fiil olursa bir tanesi diğer fiile "
                "yardımcı oluyor bu durumda yardımcı fiil olarak adlandırılıyor. "
                "'Örneğin' konuşmayı seviyorum cümlesinde 'sevmek' fiili yardımcı "
                "fiildir. 'Konuşmayı sevmeyi' işaret ediyor.",
                dashTextA: 'Örneğin',
                dashTextB: 'sevmek',
                dashTextC: 'Konuşmayı sevmeyi',
                context,
              ),
              const Divider(),

              buildTextRule(
                "Sırpça ‘da İki kural var:",
                style: baslikTextBlack,
                context,
              ),
              buildRichTextRule(
                "'1.	Kural' Özneler aynı Yardımcı fiil (şimdiki / geniş zaman) "
                "+ -ti/-ći bitimli mastar fiil",
                dashTextA: '1.	Kural',
                context,
              ),
              buildRichTextRule(
                "'2.	Kural' Özneler aynı Yardımcı fiil (şimdiki / geniş zaman) "
                "+ -ti/-ći bitimli mastar fiil",
                dashTextA: '2.	Kural',
                context,
              ),
              const Divider(),

              buildTextRule(
                "Örnek - Özneler Aynı ise:",
                style: baslikTextBlack,
                context,
              ),
              buildRichTextRule(
                "düşünmek istiyorum – željeti (istemek) misliti (düşünmek) >> "
                "'(ja) želim misliti'",
                dashTextA: '(ja) želim misliti',
                context,
              ),
              buildTextRule(
                "Örnek - Özneler farklı veya aynı ise:",
                style: baslikTextBlack,
                context,
              ),
              buildRichTextRule(
                "Mislim / Misliš / Misli / Mislimo / misliti / Mislite / Misle"
                "(ja) želim da mislim '(Sırpça)' - ja želim misliti '(Boşnakça / Hırvatça)'",
                dashTextA: '(Sırpça)',
                dashTextB: '(Boşnakça / Hırvatça)',
                context,
              ),
              buildRichTextRule(
                "Özneler aynı olunca 'kural 1' Boşnakça Hırvatça ’da tercih ediliyor."
                "'kural 2' ise Sırpça ’da tercih ediliyor.",
                dashTextA: 'kural 1',
                dashTextB: 'kural 2',
                context,
              ),
              buildTextRule(
                "Örnek - Özneler farklı ise:",
                style: baslikTextBlack,
                context,
              ),
              buildRichTextRule(
                "Mislim / Misliš / Misli / Mislimo / misliti / Mislite / Misle"
                "ja želim da misliš (Boşnakça / Hırvatça / Sırpça)",
                dashTextA: '(Boşnakça / Hırvatça / Sırpça)',
                context,
              ),
              buildRichTextRule(
                "Boşnak, Hırvat ve Sırp dillerinde mecburen kural 2 uygulanıyor.",
                dashTextA: 'kural 2',
                context,
              ),
              const Divider(),

              /// Yardımcı fiil örnekleri
              buildTable(
                gecisliDonusluFiilerSampleI,
                "Yardımcı Fiil Örnekleri",
                [
                  (user) => user['fiil']!,
                  (user) => user['çekim']!,
                ],
              ),
              buildRichTextRule(
                "Ići fiili gibi bazı filler de ći eki alırlar- Ići fiilinde "
                "düzensiz çekim var. Çekim yaparken ći atılıyor.",
                dashTextA: 'Ići',
                dashTextB: 'ći',
                dashTextC: 'Ići',
                dashTextD: 'ći',
                context,
              ),
              buildTable(
                gecisliDonusluFiilerSampleJ,
                "Yardımcı Fiil Örnekleri",
                [
                  (user) => user['fiil']!,
                  (user) => user['anlam']!,
                ],
              ),
              const Divider(),
              buildRichTextRule(
                "Da eki gelince, özne farklılıkları oluyor. Yani birinin bir "
                "eylem yapmasını istemek gibi.  Želim / hocu da ideš "
                "(gitmeni istiyorum) ",
                dashTextA: 'Da',
                dashTextB: 'Želim / hocu da ideš',
                dashTextC: '(gitmeni istiyorum)',
                context,
              ),
              const Divider(),
              buildRichTextRule(
                "Kullanım kalıbı: (kişi zamiri) + fiil + nesne + diğer sözcükler",
                dashTextA: 'Kullanım kalıbı:',
                context,
              ),
              buildTable(
                gecisliDonusluFiilerSampleK,
                "Yardımcı Fiil Örnekleri",
                [
                      (user) => user['kalıp']!,
                      (user) => user['anlam']!,
                ],
              ),
              /// Aşağıdakileri Sırpçaya çeviriniz
              buildTable(
                gecisliDonusluFiilerSampleL,
                "Türkçe > Sırpça Çeviri - 1",
                [
                      (user) => user['türkçe']!,
                      (user) => user['sırpça']!,
                ],
              ),
              buildTable(
                gecisliDonusluFiilerSampleM,
                "Türkçe > Sırpça Çeviri - 2",
                [
                      (user) => user['türkçe']!,
                      (user) => user['sırpça']!,
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
