// 📜 <----- page_fiiller.dart ----->

import 'package:flutter/material.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_app_bar.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../constants/const_fiiller.dart';

class SayfaFiillerDict extends StatefulWidget {
  const SayfaFiillerDict({super.key});

  @override
  State<SayfaFiillerDict> createState() => _SayfaFiillerDictState();
}

/// 📌 Ana kod
class _SayfaFiillerDictState extends State<SayfaFiillerDict> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHelpAppBar(context),
      drawer: buildHelpDrawer(),
      body: buildBody(),
    );
  }

  /// 📌 Body bloğu
  SafeArea buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTable(fiilListA, "Sırpça Fiiller Sözlüğü (A)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
                buildTable(fiilListB, "Sırpça Fiiller Sözlüğü (B)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
                buildTable(fiilListC, "Sırpça Fiiller Sözlüğü (C-Ç)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
                buildTable(fiilListD, "Sırpça Fiiller Sözlüğü (D)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
                buildTable(fiilListE, "Sırpça Fiiller Sözlüğü (E-F)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
                buildTable(fiilListG, "Sırpça Fiiller Sözlüğü (G)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
                buildTable(fiilListH, "Sırpça Fiiller Sözlüğü (H-İ)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
                buildTable(fiilListK, "Sırpça Fiiller Sözlüğü (K)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
                buildTable(fiilListO, "Sırpça Fiiller Sözlüğü (O-Ö-P)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
                buildTable(fiilListS, "Sırpça Fiiller Sözlüğü (S)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
                buildTable(fiilListT, "Sırpça Fiiller Sözlüğü (T-U)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
                buildTable(fiilListV, "Sırpça Fiiller Sözlüğü (V-Y)", [
                  (user) => user['turkce']!,
                  (user) => user['sirpca']!,
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
