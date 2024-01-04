/// <----- sayfa_zamir.dart ----->

import 'package:flutter/material.dart';

import '../constants.dart';
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

              /// Şahıs zamirleri
              buildTable(
                zamirlerSample,
                "Şahıs Zamirleri",
                (user) => user['tekil']!,
                (user) => user['çoğul']!,
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
              buildTextRule("- Örneğin : Ben öğretmenim, sen uzunsun, "
                  "o gül, biz üzgünüz, siz kısasınız, onlar hızlılar."),
              buildTextRule("- Eğer olumsuz olursa değil eklenir. "
                  "Değilim/değilsin/değil/değiliz/değilsiniz/değiller"),
              buildTextRule(
                  "- Örneğin : Ben öğretmen değilim, sen uzun değilsin, "
                  "o güzel değil, biz üzgün değiliz, siz kısa değilsiniz, "
                  "onlar hızlı değiller."),
              const Divider(),
              const Text(
                "Biti (olmak) fiili Olumlu / olumsuz ve soru kalıpları",
                style: baslikTextBlack,
              ),
              buildTextRule("- Örneğin : Öğrenci kelimesi için örnek yapalım."),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: IntrinsicColumnWidth(),
                      2: IntrinsicColumnWidth(),
                    },
                    children: olmakSampleTr.map((user) {
                      return TableRow(children: [
                        Container(
                          color: olmakSampleTr.indexOf(user) % 2 == 0
                              ? Colors.blue[50]
                              : Colors.amber[50],
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            user['olumlu']!,
                            style: olmakSampleTr.indexOf(user) == 0
                                ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                                : const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                          ),
                        ),
                        Container(
                          color: olmakSampleTr.indexOf(user) % 2 == 0
                              ? Colors.blue[50]
                              : Colors.amber[50],
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            user['olumsuz']!,
                            style: olmakSampleTr.indexOf(user) == 0
                                ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                                : const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                          ),
                        ),
                        Container(
                            color: olmakSampleTr.indexOf(user) % 2 == 0
                                ? Colors.blue[50]
                                : Colors.amber[50],
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              user['soru']!,
                              style: olmakSampleTr.indexOf(user) == 0
                                  ? const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )
                                  : const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                            ))
                      ]);
                    }).toList(),
                    border: TableBorder.all(width: 1, color: Colors.black),
                  ),
                ),
              ),
              buildTextRule(
                  "- Sırpça, Boşnakça, Hırvatça dilleri Aşağıdaki cümle yapısına uymaktadır."),
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: IntrinsicColumnWidth(),
                      2: IntrinsicColumnWidth(),
                    },
                    children: olmakSampleSer.map((user) {
                      return TableRow(children: [
                        Container(
                          color: user['zamir'] != null
                              ? olmakSampleSer.indexOf(user) % 2 == 0
                                  ? Colors.blue[50]
                                  : Colors.amber[50]
                              : Colors.transparent,
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            user['zamir'] ?? '',
                            style: olmakSampleSer.indexOf(user) == 0
                                ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                                : const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                          ),
                        ),
                        Container(
                          color: user['vurgulu'] != null
                              ? olmakSampleSer.indexOf(user) % 2 == 0
                                  ? Colors.blue[50]
                                  : Colors.amber[50]
                              : Colors.transparent,
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            user['vurgulu'] ?? '',
                            style: olmakSampleSer.indexOf(user) == 0
                                ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                                : const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                          ),
                        ),
                        Container(
                          color: user['vurgusuz'] != null
                              ? olmakSampleSer.indexOf(user) % 2 == 0
                                  ? Colors.blue[50]
                                  : Colors.amber[50]
                              : Colors.transparent,
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            user['vurgusuz'] ?? '',
                            style: olmakSampleSer.indexOf(user) == 0
                                ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                                : const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                          ),
                        ),
                      ]);
                    }).toList(),
                    border: TableBorder.all(width: 1, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
