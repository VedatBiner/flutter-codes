/// <----- sayfa_kiril.dart ----->
import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';
import 'help_parts/custom_appbar.dart';
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
      appBar: const CustomAppBar(
        appBarTitle: appBarKirilTitle,
      ),
      drawer: buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(10),
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
