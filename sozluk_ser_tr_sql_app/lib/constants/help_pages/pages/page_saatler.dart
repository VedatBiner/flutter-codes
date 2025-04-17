/// <----- sayfa_saatler.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:sozluk_ser_tr_sql_app/widgets/help_page_widgets/help_custom_app_bar.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../text_constants.dart';
import '../constants/const_sayilar.dart';

class SayfaSaatler extends StatefulWidget {
  const SayfaSaatler({super.key});

  @override
  State<SayfaSaatler> createState() => _SayfaSaatlerState();
}

/// 📌 Ana kod
class _SayfaSaatlerState extends State<SayfaSaatler> {
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

              buildTable(sayilarSampleA, "Sayılar", [
                (user) => user['sayı']!,
                (user) => user['sırpça']!,
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
