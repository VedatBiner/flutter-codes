/// <----- sayfa_zamir.dart ----->
library;

import 'package:flutter/material.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_app_bar.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../../widgets/help_page_widgets/rich_text_rule.dart';
import '../../text_constants.dart';
import '../constants/const_zamirler.dart';

class SayfaZamir extends StatefulWidget {
  const SayfaZamir({super.key});

  @override
  State<SayfaZamir> createState() => _SayfaZamirState();
}

/// 📌 Ana kod
class _SayfaZamirState extends State<SayfaZamir> {
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
              const Text("Şahıs Zamirleri", style: detailTextBlue),
              const Divider(),
              buildRichTextRule(
                "- Eğer 'onlar' demek istediğimiz grupta hem erkek "
                "hem de dişi  cins varsa 'erkek' için kullanılan "
                "'oni' kullanılır.",
                dashTextA: "'onlar'",
                dashTextB: "'erkek'",
                dashTextC: "'oni'",
                context,
              ),
              const Divider(),
              buildTable(zamirlerSample, "Şahıs Zamirleri", [
                (user) => user['tekil']!,
                (user) => user['çoğul']!,
              ]),
              const Divider(),
              buildRichTextRule(
                "Türkçede olmak fiili",
                dashTextA: "olmak",
                context,
              ),
              const Text("- Ben – (y) + ım/im/um/üm "),
              const Text("- Sen - -sın/sin/sun/sün "),
              const Text("- O - ek yok"),
              const Text("- Biz – (y)ız/iz/uz/üz"),
              const Text("- Siz – sınız/siniz/sunuz/sünüz"),
              const Text("- Onlar – lar/ler"),
              const Text(
                "- Örneğin : Ben öğretmenim, sen uzunsun, "
                "o gül, biz üzgünüz, siz kısasınız, onlar hızlılar.",
              ),
              const Text(
                "- Eğer olumsuz olursa değil eklenir. "
                "Değilim/değilsin/değil/değiliz/değilsiniz/değiller",
              ),
              const Text(
                "- Örneğin : Ben öğretmen değilim, sen uzun değilsin, "
                "o güzel değil, biz üzgün değiliz, siz kısa değilsiniz, "
                "onlar hızlı değiller.",
              ),
              const Divider(),
              const Text(
                "Biti (olmak) fiili Olumlu / olumsuz ve soru kalıpları",
                style: normalBlackText,
              ),
              const Text("- Örneğin : Öğrenci kelimesi için örnek yapalım."),
              buildTable(
                olmakSampleTr,
                "Türkçede olmak fiili : Olumlu / Olumsuz / Soru ",
                [
                  (user) => user['olumlu']!,
                  (user) => user['olumsuz']!,
                  (user) => user['soru']!,
                ],
              ),
              const Text(
                "- Sırpça, Boşnakça, Hırvatça dilleri Aşağıdaki cümle "
                "yapısına uymaktadır.",
              ),
              const Text("özne + fiil + isim / nesne"),
              const Text("Ben öğrenciyim : ben + olmak(çekimli) + öğrenci"),
              const Divider(),
              const Text("Biti (olmak) Fiili Sırpça", style: normalBlackText),
              const Text("- Boşnakça / Sırpça : jeste Hırvatça : jest"),
              const Text(
                "- Vurgulu haller genellikle soru kalıplarında kullanılıyor."
                "Düz cümlelerde ise vurgusuz haller kullanılır.",
              ),
              buildTable(olmakSampleSer, "Vurgulu / Vurgusuz Zamirler", [
                (user) => user['zamir']!,
                (user) => user['vurgulu']!,
                (user) => user['vurgusuz']!,
              ]),
              const Divider(),
              const Text(
                "- Vurgusuz (kısa) olmak fiilinin başına olumsuz olması "
                "durumunda 'ni' eklenir ",
              ),

              /// Şahıs zamirleri
              buildTable(zamirlerSampleA, "Şahıs Zamirleri (olumlu / olumsuz", [
                (user) => user['olumlu']!,
                (user) => user['olumsuz']!,
              ]),
              const Divider(),

              /// Örnek : Student (Erkek öğrenci)
              buildTable(zamirlerSampleB, "Örnek : Student (Erkek Öğrenci)", [
                (user) => user['özne']!,
                (user) => user['fiil']!,
                (user) => user['isim / nesne']!,
              ]),
              const Divider(),

              /// Örnek : Student (kız öğrenci)
              buildTable(zamirlerSampleC, "Örnek : Studentica (kız Öğrenci)", [
                (user) => user['özne']!,
                (user) => user['fiil']!,
                (user) => user['isim / nesne']!,
              ]),
              const Divider(),

              /// Örnek : kako si?  (olumlu)
              buildTable(zamirlerSampleD, "Örnek : kako si (olumlu cevap)", [
                (user) => user['özne']!,
                (user) => user['fiil']!,
                (user) => user['isim / nesne']!,
              ]),
              const Divider(),

              /// Örnek : kako si?  (olumsuz)
              buildTable(zamirlerSampleE, "Örnek : kako si (olumsuz cevap)", [
                (user) => user['özne']!,
                (user) => user['fiil']!,
                (user) => user['isim / nesne']!,
              ]),
              const Divider(),

              /// zar ne Yapısı
              buildTable(zamirlerSampleF, "Örnek", [
                (user) => user['da li']!,
                (user) => user['şahıs zamiri']!,
                (user) => user['normal fiil']!,
                (user) => user['info']!,
              ]),
              const Text(
                "Şahıs zamiri Türkçe 'de olduğu gibi cümle içinde "
                "kullanılmasa da oluyor. Örneğin ben yemek yiyorum "
                "yerine yemek yiyorum kullanmak gibi. Şahıs zamiri "
                "normal fiilden önce gelir. Olmak fiilinden ise sonra "
                "gelir böyle bir ayrım var. ",
              ),
              buildTable(zamirlerSampleG, "Örnek", [
                (user) => user['sırpça']!,
                (user) => user['türkçe']!,
              ]),
              const Divider(),
              const Text("Zar ne yapısında ise,"),
              const Text("cümle + zar ne : cümle + değil mi?"),
              const Text("zar ne + olumlu cümle : olumsuz soru olur"),
              const Divider(),
              buildTable(zamirlerSampleH, "Örnek", [
                (user) => user['sırpça']!,
                (user) => user['türkçe']!,
              ]),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
