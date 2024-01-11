/// <----- sayfa_latin.dart ----->
import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../theme/theme_manager.dart';
import 'help_parts/build_table.dart';
import 'help_parts/custom_appbar.dart';

class SayfaLatin extends StatefulWidget {
  const SayfaLatin({Key? key}) : super(key: key);

  @override
  State<SayfaLatin> createState() => _SayfaLatinState();
}

class _SayfaLatinState extends State<SayfaLatin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarLatinTitle,
      ),
      drawer: buildDrawer(
        context,
         // ThemeManager örneği oluşturuldu
        themeChangeCallback: () {
          setState(
                () {
              // AppConst.listener.themeNotifier.changeTheme();
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
