// 📃 <----- page_kiril.dart ----->
//

import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/help_page_widgets/build_table.dart';
import 'alphabet_constants.dart';

class SayfaKiril extends StatefulWidget {
  const SayfaKiril({super.key});

  @override
  State<SayfaKiril> createState() => _SayfaKirilState();
}

class _SayfaKirilState extends State<SayfaKiril> {
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
        child: buildTable(kirilAlphabet, "Sırpça 'da Kiril Harfleri", [
          (user) => user['turkce']!,
          (user) => user['sirpca']!,
        ]),
      ),
    );
  }
}
