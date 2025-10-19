/// <----- sayfa_gunler.dart ----->
library;

import 'package:flutter/material.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_app_bar.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../../widgets/help_page_widgets/rich_text_rule.dart';
import '../../text_constants.dart';
import '../constants/const_gunler.dart';

class SayfaGunler extends StatefulWidget {
  const SayfaGunler({super.key});

  @override
  State<SayfaGunler> createState() => _SayfaGunlerState();
}

/// 📌 Ana kod
class _SayfaGunlerState extends State<SayfaGunler> {
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
              const Text("Günler", style: detailTextBlue),
              const Divider(),

              buildTable(gunlerSampleA, "Günler", [
                (user) => user['sırpça']!,
                (user) => user['türkçe']!,
              ]),

              buildTable(gunlerSampleB, "Günler", [
                (user) => user['sırpça']!,
                (user) => user['türkçe']!,
              ]),

              buildTable(gunlerSampleC, "Günler", [
                (user) => user['sırpça']!,
                (user) => user['türkçe']!,
              ]),

              buildRichTextRule(
                "Neđeljom = svake nedelje = Her pazar - Bu iki kullanımda aynı "
                "anlama sahiptir. Sürekli tekrarlayan günler için kullanılır.",
                dashTextA: 'Neđeljom',
                dashTextB: 'svake nedelje',
                context,
              ),

              buildRichTextRule(
                "u neđelju = samo jedne nedelje - Pazar günü - Bu iki kullanımda"
                " aynı anlama sahiptir. Sadece tek seferlik kullanımlar içindir.",
                dashTextA: 'u neđelju',
                dashTextB: 'samo jedne nedelje',
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
