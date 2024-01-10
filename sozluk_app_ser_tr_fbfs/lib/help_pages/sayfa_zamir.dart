/// <----- sayfa_zamir.dart ----->

import 'package:flutter/material.dart';

import '../constants/app_constants/const_zamirler.dart';
import '../constants/app_constants/constants.dart';
import '../constants/base_constants/app_const.dart';
import '../routes/app_routes.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';

class SayfaZamir extends StatefulWidget {
  const SayfaZamir({super.key});

  @override
  State<SayfaZamir> createState() => _SayfaZamirState();
}

class _SayfaZamirState extends State<SayfaZamir> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarZamirTitle,
          style: TextStyle(
            color: menuColor,
          ),
        ),
        iconTheme: IconThemeData(color: menuColor),
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: menuColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AppRoute.routes[AppRoute.home]!(context),
                ),
              );
            },
          )
        ],
      ),
      drawer: buildDrawer(
        context,
        themeChangeCallback: () {
          setState(
            () {
              AppConst.listener.themeNotifier.changeTheme();
            },
          );
        },
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
                context,
                style: detailTextBlue,
              ),
              const Divider(),
              buildTextRule(
                "- Eğer onlar demek istediğimiz grupta hem erkek hem de dişi"
                " cins varsa erkek için kullanılan oni kullanılır.",
                context,
              ),
              const Divider(),
              buildTable(
                context,
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
              buildTextRule(
                "- Ben – (y) + ım/im/um/üm ",
                context,
              ),
              buildTextRule(
                "- Sen - -sın/sin/sun/sün ",
                context,
              ),
              buildTextRule(
                "- O - ek yok",
                context,
              ),
              buildTextRule(
                "- Biz – (y)ız/iz/uz/üz",
                context,
              ),
              buildTextRule(
                "- Siz – sınız/siniz/sunuz/sünüz",
                context,
              ),
              buildTextRule(
                "- Onlar – lar/ler",
                context,
              ),
              buildTextRule(
                "- Örneğin : Ben öğretmenim, sen uzunsun, "
                "o gül, biz üzgünüz, siz kısasınız, onlar hızlılar.",
                context,
              ),
              buildTextRule(
                "- Eğer olumsuz olursa değil eklenir. "
                "Değilim/değilsin/değil/değiliz/değilsiniz/değiller",
                context,
              ),
              buildTextRule(
                "- Örneğin : Ben öğretmen değilim, sen uzun değilsin, "
                "o güzel değil, biz üzgün değiliz, siz kısa değilsiniz, "
                "onlar hızlı değiller.",
                context,
              ),
              const Divider(),
              const Text(
                "Biti (olmak) fiili Olumlu / olumsuz ve soru kalıpları",
                style: baslikTextBlack,
              ),
              buildTextRule(
                "- Örneğin : Öğrenci kelimesi için örnek yapalım.",
                context,
              ),
              buildTable(
                context,
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
                context,
              ),
              buildTextRule(
                "özne + fiil + isim / nesne",
                context,
              ),
              buildTextRule(
                "Ben öğrenciyim : ben + olmak(çekimli) + öğrenci",
                context,
              ),
              const Divider(),
              const Text(
                "Biti (olmak) Fiili Sırpça",
                style: baslikTextBlack,
              ),
              buildTextRule(
                "- Boşnakça / Sırpça : jeste Hırvatça : jest",
                context,
              ),
              buildTextRule(
                "- Vurgulu haller genellikle soru kalıplarında kullanılıyor."
                "Düz cümlelerde ise vurgusuz haller kullanılır.",
                context,
              ),
              buildTable(
                context,
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
                context,
              ),

              /// Şahıs zamirleri
              buildTable(
                context,
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
                context,
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
                context,
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
                context,
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
                context,
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
