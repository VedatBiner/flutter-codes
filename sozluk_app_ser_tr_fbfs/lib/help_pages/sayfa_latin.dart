/// <----- sayfa_latin.dart ----->
import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../constants/base_constants/app_const.dart';
import '../screens/home_page_parts/drawer_items.dart';
import 'help_parts/build_table.dart';

class SayfaLatin extends StatefulWidget {
  const SayfaLatin({Key? key}) : super(key: key);

  @override
  State<SayfaLatin> createState() => _SayfaLatinState();
}

class _SayfaLatinState extends State<SayfaLatin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sırpça 'da Latin Harfleri"),
      ),
      drawer: buildDrawer(
        context,
        themeChangeCallback: () {
          setState(
            () {
              AppConst.listener.themeNotifier.changeTheme();
            },
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: buildTable(
          context,
          latinAlphabet,
          "Sırpça 'da  Latin Harfleri",
          [
            (user) => user['turkce']!,
            (user) => user['sirpca']!,
          ],
        ),
      ),
    );
  }
}
