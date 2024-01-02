// sayfa_cogul.dart
import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/text_rule.dart'; // text_rule.dart dosyasını içe aktarın

class SayfaCogul extends StatelessWidget {
  const SayfaCogul({Key? key}) : super(key: key);

  // Yeni metot
  Widget buildCogulTable(List<Map<String, String>> cogulSample, String baslik) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              baslik,
              style: baslikTextBlack87,
              textAlign: TextAlign.left,
            ),
            Table(
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
              },
              children: cogulSample.map((user) {
                return TableRow(
                  children: [
                    Container(
                      color: cogulSample.indexOf(user) % 2 == 0
                          ? Colors.blue[50]
                          : Colors.amber[50],
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        user['tekil']!,
                        style: cogulSample.indexOf(user) == 0
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
                      color: cogulSample.indexOf(user) % 2 == 0
                          ? Colors.blue[50]
                          : Colors.amber[50],
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        user['çoğul']!,
                        style: cogulSample.indexOf(user) == 0
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
                  ],
                );
              }).toList(),
              border: TableBorder.all(width: 1, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İsimlerin Çoğul Halleri"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextRule(
                "İsimlerin Çoğul Hallerinde Kurallar",
                style: detailTextBlue,
              ),
              const Divider(),
              buildTextRule(
                "1. Sessiz harf ile bitenler 'i' eklenince çoğul olurlar",
              ),
              buildTextRule(
                "2. İstisna olarak 'k' ile bitenler 'ci', 'g' ile bitenler "
                "'zi', 'h' ile bitenler 'si' ile çoğul yapılırlar. ",
              ),
              buildTextRule(
                "3. 'a' ile bitenler 'e' ile bitince çoğul olur.",
              ),
              buildTextRule(
                "4. 'o' veya 'e' harfi ile bitenler 'a' ile bitince çoğul olur.",
              ),
              buildTextRule(
                "5. 'ac' ile biten kelimelerde 'a' düşer, 'i' eklenir.",
              ),
              buildTextRule(
                "6. Genellikle tek heceli erkek cins isimlerde son harfe "
                "göre -ovi / -evi eklerinden biri eklenir.",
              ),
              const Divider(),
              const Text(
                "Örnekler",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// sessiz harfle bitenler
              buildCogulTable(
                cogulSampleA,
                "Sessiz Harf ile Bitenler",
              ),

              /// "a" ile bitenler
              buildCogulTable(
                cogulSampleB,
                "-a ile Bitenler",
              ),

              /// 'o' veya 'e' ile Bitenler
              buildCogulTable(
                cogulSampleC,
                "- 'o' veya 'e' ile Bitenler",
              ),

              /// 'ac' ile Bitip, 'a' düşen 'i' eklenenler
              buildCogulTable(
                cogulSampleD,
                "- 'ac' ile bitip, 'a' düşen 'i' eklenenler",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
