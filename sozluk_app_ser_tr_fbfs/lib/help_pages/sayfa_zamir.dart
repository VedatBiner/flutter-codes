/// <----- sayfa_zamir.dart ----->

import 'package:flutter/material.dart';

import '../constants/const_zamirler.dart';
import '../constants/constants.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';

class SayfaZamir extends StatelessWidget {
  const SayfaZamir({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Şahıs Zamirleri"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextRule(
                "Şahıs Zamirleri",
                style: detailTextBlue,
              ),
              const Divider(),
              buildTextRule(
                "- Eğer onlar demek istediğimiz grupta hem erkek hem de dişi"
                " cins varsa erkek için kullanılan oni kullanılır.",
              ),
              const Divider(),
              buildTable(
                zamirlerSample,
                "Şahıs Zamirleri",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                ],
              ),
              const Divider(),
              const Text(
                "Türkçede olmak fiili",
                style: baslikTextBlack,
              ),
              buildTextRule("- Ben – (y) + ım/im/um/üm "),
              buildTextRule("- Sen - -sın/sin/sun/sün "),
              buildTextRule("- O - ek yok"),
              buildTextRule("- Biz – (y)ız/iz/uz/üz"),
              buildTextRule("- Siz – sınız/siniz/sunuz/sünüz"),
              buildTextRule("- Onlar – lar/ler"),
              buildTextRule(
                "- Örneğin : Ben öğretmenim, sen uzunsun, "
                "o gül, biz üzgünüz, siz kısasınız, onlar hızlılar.",
              ),
              buildTextRule(
                "- Eğer olumsuz olursa değil eklenir. "
                "Değilim/değilsin/değil/değiliz/değilsiniz/değiller",
              ),
              buildTextRule(
                "- Örneğin : Ben öğretmen değilim, sen uzun değilsin, "
                "o güzel değil, biz üzgün değiliz, siz kısa değilsiniz, "
                "onlar hızlı değiller.",
              ),
              const Divider(),
              const Text(
                "Biti (olmak) fiili Olumlu / olumsuz ve soru kalıpları",
                style: baslikTextBlack,
              ),
              buildTextRule(
                "- Örneğin : Öğrenci kelimesi için örnek yapalım.",
              ),
              buildTable(
                olmakSampleTr,
                "Türkçede olmak fiili : Olumlu / Olumsuz / Soru ",
                [
                  (user) => user['olumlu']!,
                  (user) => user['olumsuz']!,
                  (user) => user['soru']!,
                ],
              ),
              buildTextRule(
                "- Sırpça, Boşnakça, Hırvatça dilleri Aşağıdaki cümle "
                "yapısına uymaktadır.",
              ),
              buildTextRule("özne + fiil + isim / nesne"),
              buildTextRule("Ben öğrenciyim : ben + olmak(çekimli) + öğrenci"),
              const Divider(),
              const Text(
                "Biti (olmak) Fiili Sırpça",
                style: baslikTextBlack,
              ),
              buildTextRule(
                "- Boşnakça / Sırpça : jeste Hırvatça : jest",
              ),
              buildTextRule(
                "- Vurgulu haller genellikle soru kalıplarında kullanılıyor."
                "Düz cümlelerde ise vurgusuz haller kullanılır.",
              ),
              buildTable(
                olmakSampleSer,
                "Vurgulu / Vurgusuz Zamirler",
                [
                  (user) => user['zamir']!,
                  (user) => user['vurgulu']!,
                  (user) => user['vurgusuz']!,
                ],
              ),
              const Divider(),
              buildTextRule(
                "- Vurgusuz (kısa) olmak fiilinin başına olumsuz olması "
                "durumunda 'ni' eklenir ",
              ),

              /// Şahıs zamirleri
              buildTable(
                zamirlerSampleA,
                "Şahıs Zamirleri (olumlu / olumsuz",
                [
                  (user) => user['olumlu']!,
                  (user) => user['olumsuz']!,
                ],
              ),
              const Divider(),

              /// Örnek : Student (Erkek öğrenci)
              buildTable(
                zamirlerSampleB,
                "Örnek : Student (Erkek Öğrenci)",
                [
                  (user) => user['özne']!,
                  (user) => user['fiil']!,
                  (user) => user['isim / nesne']!,
                ],
              ),
              const Divider(),

              /// Örnek : Student (kız öğrenci)
              buildTable(
                zamirlerSampleC,
                "Örnek : Studentica (kız Öğrenci)",
                [
                  (user) => user['özne']!,
                  (user) => user['fiil']!,
                  (user) => user['isim / nesne']!,
                ],
              ),
              const Divider(),

              /// Örnek : kako si?  (olumlu)
              buildTable(
                zamirlerSampleD,
                "Örnek : kako si (olumlu cevap)",
                [
                  (user) => user['özne']!,
                  (user) => user['fiil']!,
                  (user) => user['isim / nesne']!,
                ],
              ),
              const Divider(),

              /// Örnek : kako si?  (olumsuz)
              buildTable(
                zamirlerSampleE,
                "Örnek : kako si (olumsuz cevap)",
                [
                  (user) => user['özne']!,
                  (user) => user['fiil']!,
                  (user) => user['isim / nesne']!,
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
