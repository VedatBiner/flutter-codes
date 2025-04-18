/// <----- sayfa_saatler.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:sozluk_ser_tr_sql_app/widgets/help_page_widgets/help_custom_app_bar.dart';

import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../../widgets/help_page_widgets/rich_text_rule.dart';
import '../../text_constants.dart';

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
              const Text("Saatler", style: detailTextBlue),
              const Divider(),

              buildRichTextRule(
                "Koliko je sati ?  - saat kaç?",
                dashTextA: "Koliko je sati ?",
                context,
              ),
              const Text("saat bu şekilde soruluyor.", style: normalBlackText),
              const SizedBox(height: 10),
              buildRichTextRule(
                "1 sat - Jedan (čas)  - 1 saat için kullanılır.",
                dashTextA: "1 sat - Jedan (čas)",
                context,
              ),
              buildRichTextRule(
                "2, 3, 4,  - Eğer saat değeri bu aralıkta ise sata kullanılır.",
                dashTextA: "2, 3, 4,",
                dashTextB: 'sata',
                context,
              ),
              buildRichTextRule(
                "5, 6, ... sati veya časova - çoğunlukla sati kullanılır. ",
                dashTextA: "5, 6, ...",
                dashTextB: 'sati',
                dashTextC: 'časova',
                dashTextD: 'sati',
                context,
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
