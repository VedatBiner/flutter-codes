/// <----- sayfa_sayilar.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:sozluk_ser_tr_sql_app/widgets/help_page_widgets/help_custom_app_bar.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../text_constants.dart';
import '../constants/const_sayilar.dart';

class SayfaSayilar extends StatefulWidget {
  const SayfaSayilar({super.key});

  @override
  State<SayfaSayilar> createState() => _SayfaSayilarState();
}

/// 📌 Ana kod
class _SayfaSayilarState extends State<SayfaSayilar> {
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
              const Text("Sayılar", style: detailTextBlue),
              const Divider(),

              /// 📌 0-10 Arası sayılar
              buildTable(sayilarSampleA, "Sayılar 0-10", [
                (user) => user['sayı']!,
                (user) => user['sırpça']!,
              ]),

              /// 📌 11-20 Arası sayılar
              buildTable(sayilarSampleB, "Sayılar 11-20", [
                (user) => user['sayı']!,
                (user) => user['sırpça']!,
              ]),

              /// 📌 30-100 Arası sayılar
              buildTable(sayilarSampleC, "Sayılar 30-100", [
                (user) => user['sayı']!,
                (user) => user['sırpça']!,
              ]),

              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
