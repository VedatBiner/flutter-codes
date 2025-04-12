// 📃 <----- sayfa_latin.dart ----->
//

import 'package:flutter/material.dart';

import '../../widgets/build_table.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import 'alphabet_constants.dart';

class SayfaLatin extends StatefulWidget {
  const SayfaLatin({super.key});

  @override
  State<SayfaLatin> createState() => _SayfaLatinState();
}

class _SayfaLatinState extends State<SayfaLatin> {
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: buildTable(latinAlphabet, "Sırpça 'da  Latin Harfleri", [
          (user) => user['turkce']!,
          (user) => user['sirpca']!,
        ]),
      ),
    );
  }
}
