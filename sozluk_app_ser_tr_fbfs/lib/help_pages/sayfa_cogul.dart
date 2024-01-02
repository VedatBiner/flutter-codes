// sayfa_cogul.dart
import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/text_rule.dart'; // text_rule.dart dosyasını içe aktarın

class SayfaCogul extends StatelessWidget {
  const SayfaCogul({Key? key}) : super(key: key);

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
            mainAxisAlignment: MainAxisAlignment.start,
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
              const Text(
                "- Sessiz Harfle Bitenler",
                style: baslikTextBlack87,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: IntrinsicColumnWidth(),
                    },
                    children: cogulSampleA.map((user) {
                      return TableRow(
                        children: [
                          Container(
                            color: cogulSampleA.indexOf(user) % 2 == 0
                                ? Colors.blue[50]
                                : Colors.amber[50],
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              user['tekil'],
                              style: cogulSampleA.indexOf(user) == 0
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
                            color: cogulSampleA.indexOf(user) % 2 == 0
                                ? Colors.blue[50]
                                : Colors.amber[50],
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              user['çoğul'],
                              style: cogulSampleA.indexOf(user) == 0
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
                ),
              ),

              /// "a" ile bitenler
              const Text(
                "- 'a' ile Bitenler",
                style: baslikTextBlack87,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: IntrinsicColumnWidth(),
                    },
                    children: cogulSampleB.map((user) {
                      return TableRow(
                        children: [
                          Container(
                            color: cogulSampleB.indexOf(user) % 2 == 0
                                ? Colors.blue[50]
                                : Colors.amber[50],
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              user['tekil'],
                              style: cogulSampleB.indexOf(user) == 0
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
                            color: cogulSampleB.indexOf(user) % 2 == 0
                                ? Colors.blue[50]
                                : Colors.amber[50],
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              user['çoğul'],
                              style: cogulSampleB.indexOf(user) == 0
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
                ),
              ),

              /// 'o' veya 'e' ile Bitenler
              const Text(
                "- 'o' veya 'e' ile Bitenler",
                style: baslikTextBlack87,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: IntrinsicColumnWidth(),
                    },
                    children: cogulSampleC.map((user) {
                      return TableRow(
                        children: [
                          Container(
                            color: cogulSampleC.indexOf(user) % 2 == 0
                                ? Colors.blue[50]
                                : Colors.amber[50],
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              user['tekil'],
                              style: cogulSampleC.indexOf(user) == 0
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
                            color: cogulSampleC.indexOf(user) % 2 == 0
                                ? Colors.blue[50]
                                : Colors.amber[50],
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              user['çoğul'],
                              style: cogulSampleC.indexOf(user) == 0
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
                ),
              ),

              /// 'ac' ile Bitip, 'a' düşen 'i' eklenenler
              const Text(
                "- 'ac' ile bitip, 'a' düşen 'i' eklenenler",
                style: baslikTextBlack87,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: IntrinsicColumnWidth(),
                    },
                    children: cogulSampleD.map((user) {
                      return TableRow(
                        children: [
                          Container(
                            color: cogulSampleD.indexOf(user) % 2 == 0
                                ? Colors.blue[50]
                                : Colors.amber[50],
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              user['tekil'],
                              style: cogulSampleD.indexOf(user) == 0
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
                            color: cogulSampleD.indexOf(user) % 2 == 0
                                ? Colors.blue[50]
                                : Colors.amber[50],
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              user['çoğul'],
                              style: cogulSampleD.indexOf(user) == 0
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
