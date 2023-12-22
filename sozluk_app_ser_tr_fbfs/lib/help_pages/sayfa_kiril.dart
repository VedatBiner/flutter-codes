/// <----- sayfa_kiril.dart ----->
import 'package:flutter/material.dart';

import '../constants.dart';

class SayfaKiril extends StatefulWidget {
  const SayfaKiril({Key? key}) : super(key: key);

  @override
  State<SayfaKiril> createState() => _SayfaKirilState();
}

class _SayfaKirilState extends State<SayfaKiril> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sırpça 'da Кiril Harfleri",
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
          title: const Text("Sırpça 'da Kiril Harfleri"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(20),
                1: FlexColumnWidth(50),
              },
              children: kirilAlphabet.map((latin) {
                return TableRow(children: [
                  Container(
                    color: kirilAlphabet.indexOf(latin) % 2 == 0
                        ? Colors.blue[50]
                        : Colors.amber[50],
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      latin['turkce'].toString(),
                      style: kirilAlphabet.indexOf(latin) == 0
                          ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)
                          : const TextStyle(fontWeight: FontWeight.normal, fontSize: 14,),
                    ),
                  ),
                  Container(
                    color: kirilAlphabet.indexOf(latin) % 2 == 0
                        ? Colors.blue[50]
                        : Colors.amber[50],
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      latin['sirpca'],
                      style: kirilAlphabet.indexOf(latin) == 0
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
