/// <----- sayfa_cinsiyet.dart ----->

import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils/text_rule.dart';

/// Cinsiyet kurallarının maddeleri burada yazdırılır.
class SayfaCinsiyet extends StatelessWidget {
  const SayfaCinsiyet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İsimlerde Cinsiyet"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextRule(
                "İsimlerde cinsiyette dört kural var",
                style: detailTextBlue,
              ),
              const Divider(),
              buildTextRule(
                "1. Kelime sessiz harf ile bitiyorsa erkek,",
              ),
              buildTextRule(
                "2. -a harfi ile bitiyorsa dişi,",
              ),
              buildTextRule(
                "3. -o veya -e harfi ile bitiyorsa nötr,",
              ),
              const Divider(),
              const Text(
                "Örnekler",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
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
                    children: cinsiyetSample.map((user) {
                      return TableRow(children: [
                        Container(
                          color: cinsiyetSample.indexOf(user) % 2 == 0
                              ? Colors.blue[50]
                              : Colors.amber[50],
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            user['erkek'],
                            style: cinsiyetSample.indexOf(user) == 0
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
                          color: cinsiyetSample.indexOf(user) % 2 == 0
                              ? Colors.blue[50]
                              : Colors.amber[50],
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            user['dişi'],
                            style: cinsiyetSample.indexOf(user) == 0
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
                            color: cinsiyetSample.indexOf(user) % 2 == 0
                                ? Colors.blue[50]
                                : Colors.amber[50],
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              user['nötr'],
                              style: cinsiyetSample.indexOf(user) == 0
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
              const Text(
                "İstisnalar",
                style: baslikTextBlack,
              ),
              const Text("- Sto – stol (Hırvatça) (masa) – erkek"),
              const Text("- Krv (kan) – Dişi"),
              const Text("- Kolega (meslekdaş) – erkek"),
            ],
          ),
        ),
      ),
    );
  }
}