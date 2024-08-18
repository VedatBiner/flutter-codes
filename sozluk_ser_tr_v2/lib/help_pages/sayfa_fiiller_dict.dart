

import 'package:flutter/material.dart';

import '../constants/app_constants/drawer_constants.dart';
import '../constants/grammar_constants/const_fiiler.dart';
import '../screens/home_page_parts/drawer_items.dart';
import 'help_parts/build_table.dart';
import 'help_parts/custom_appbar.dart';

class SayfaFiillerDict extends StatefulWidget {
  const SayfaFiillerDict({super.key});

  @override
  State<SayfaFiillerDict> createState() => _SayfaFiillerDictState();
}

class _SayfaFiillerDictState extends State<SayfaFiillerDict> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarFiilTitle,
      ),
      drawer: buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTable(
                  fiilListA,
                  "Sırpça Fiiller Sözlüğü (A)",
                  [
                        (user) => user['turkce']!,
                        (user) => user['sirpca']!,
                  ],
                ),
                buildTable(
                  fiilListB,
                  "Sırpça Fiiller Sözlüğü (B)",
                  [
                        (user) => user['turkce']!,
                        (user) => user['sirpca']!,
                  ],
                ),
                buildTable(
                  fiilListC,
                  "Sırpça Fiiller Sözlüğü (C-Ç)",
                  [
                        (user) => user['turkce']!,
                        (user) => user['sirpca']!,
                  ],
                ),
                buildTable(
                  fiilListD,
                  "Sırpça Fiiller Sözlüğü (D)",
                  [
                        (user) => user['turkce']!,
                        (user) => user['sirpca']!,
                  ],
                ),
                buildTable(
                  fiilListE,
                  "Sırpça Fiiller Sözlüğü (E-F)",
                  [
                        (user) => user['turkce']!,
                        (user) => user['sirpca']!,
                  ],
                ),
                buildTable(
                  fiilListG,
                  "Sırpça Fiiller Sözlüğü (G)",
                  [
                        (user) => user['turkce']!,
                        (user) => user['sirpca']!,
                  ],
                ),
                buildTable(
                  fiilListH,
                  "Sırpça Fiiller Sözlüğü (H-İ)",
                  [
                        (user) => user['turkce']!,
                        (user) => user['sirpca']!,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
