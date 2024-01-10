/// <----- sayfa_kiril.dart ----->
import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../constants/base_constants/app_const.dart';
import '../screens/home_page_parts/drawer_items.dart';
import 'help_parts/build_table.dart';

class SayfaKiril extends StatefulWidget {
  const SayfaKiril({Key? key}) : super(key: key);

  @override
  State<SayfaKiril> createState() => _SayfaKirilState();
}

class _SayfaKirilState extends State<SayfaKiril> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sırpça 'da Kiril Harfleri"),
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
          kirilAlphabet,
          "Sırpça 'da Kiril Harfleri",
          [
            (user) => user['turkce']!,
            (user) => user['sirpca']!,
          ],
        ),
      ),
    );
  }
}
