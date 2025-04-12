/// <----- sayfa_cinsiyet.dart ----->
library;

import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/help_page_widgets/build_table.dart';
import '../../widgets/help_page_widgets/rich_text_rule.dart';
import '../text_constants.dart';
import 'const_cinsiyet.dart';

class SayfaCinsiyet extends StatefulWidget {
  const SayfaCinsiyet({super.key});

  @override
  State<SayfaCinsiyet> createState() => _SayfaCinsiyetState();
}

class _SayfaCinsiyetState extends State<SayfaCinsiyet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isSearching: false,
        searchController: TextEditingController(),
        onSearchChanged: (value) {},
        onClearSearch: () {},
        onStartSearch: () {},
        itemCount: 0,
      ),
      drawer: CustomDrawer(
        onDatabaseUpdated: () {},
        appVersion: '',
        isFihristMode: true,
        onToggleViewMode: () {},
        onLoadJsonData: ({required BuildContext context}) async {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "İsimlerde cinsiyette dört kural var",
                style: detailTextBlue,
              ),
              const Divider(),
              buildRichTextRule(
                "1. Kelime sessiz harf ile bitiyorsa erkek",
                dashTextA: "sessiz harf",
                dashTextB: "erkek",
                context,
              ),
              buildRichTextRule(
                "2. -a harfi ile bitiyorsa dişi,",
                dashTextA: "-a",
                dashTextB: "dişi",
                context,
              ),
              buildRichTextRule(
                "3. -o veya -e harfi ile bitiyorsa nötr,",
                dashTextA: "-o",
                dashTextB: "-e",
                dashTextC: "nötr,",
                context,
              ),
              const Divider(),
              const Text("Örnekler", style: normalBlackText),
              //  buildTextRule("Örnekler", context, style: baslikTextBlack),

              /// 📜 Kelimelerde Cinsiyet
              buildTable(cinsiyetSample, "- 'o' veya 'e' ile Bitenler", [
                (user) => user['erkek']!,
                (user) => user['dişi']!,
                (user) => user['nötr']!,
              ]),

              const Text("İstisnalar", style: normalBlackText),
              const Text(
                "- Sto – stol (Hırvatça) (masa) – erkek",
                style: normalBlackText,
              ),
              const Text("- Krv (kan) – Dişi", style: normalBlackText),
              const Text(
                "- Kolega (meslekdaş) – erkek",
                style: normalBlackText,
              ),
              // buildTextRule("İstisnalar", context, style: baslikTextBlack),
              // buildTextRule("- Sto – stol (Hırvatça) (masa) – erkek", context),
              // buildTextRule("- Krv (kan) – Dişi", context),
              // buildTextRule("- Kolega (meslekdaş) – erkek", context),
            ],
          ),
        ),
      ),
    );
  }
}
