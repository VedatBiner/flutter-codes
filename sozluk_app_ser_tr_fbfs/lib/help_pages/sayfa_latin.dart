/// <----- sayfa_latin.dart ----->
/// https://www.kindacode.com/article/working-with-table-in-flutter/
/// table example
import 'package:flutter/material.dart';

import '../constants.dart';

class SayfaLatin extends StatelessWidget {
  const SayfaLatin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sırpça 'da Latin Harfleri",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sırpça 'da Latin Harfleri"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(20),
                1: FlexColumnWidth(50),
              },
              children: latinAlphabet.map((latin) {
                return TableRow(children: [
                  Container(
                    color: latinAlphabet.indexOf(latin) % 2 == 0
                        ? Colors.blue[50]
                        : Colors.amber[50],
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      latin['turkce'].toString(),
                      style: latinAlphabet.indexOf(latin) == 0
                          ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)
                          : const TextStyle(fontWeight: FontWeight.normal, fontSize: 14,),
                    ),
                  ),
                  Container(
                    color: latinAlphabet.indexOf(latin) % 2 == 0
                        ? Colors.blue[50]
                        : Colors.amber[50],
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      latin['sirpca'],
                      style: latinAlphabet.indexOf(latin) == 0
                          ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)
                          : const TextStyle(fontWeight: FontWeight.normal, fontSize: 14,),
                    ),
                  )
                ]);
              }).toList(),
              border: TableBorder.all(width: 1, color: Colors.black),
            ),
          ),
        ));
  }
}
