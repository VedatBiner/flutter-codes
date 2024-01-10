/// <----- sayfa_cinsiyet.dart ----->

import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../constants/base_constants/app_const.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';

/// Cinsiyet kurallarının maddeleri burada yazdırılır.
class SayfaCinsiyet extends StatefulWidget {
  const SayfaCinsiyet({Key? key}) : super(key: key);

  @override
  State<SayfaCinsiyet> createState() => _SayfaCinsiyetState();
}

class _SayfaCinsiyetState extends State<SayfaCinsiyet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarCinsiyetTitle,
          style: TextStyle(
            color: menuColor,
          ),
        ),
        iconTheme: IconThemeData(color: menuColor),
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: menuColor,
            ),
            onPressed: () {},
          )
        ],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextRule(
                "İsimlerde cinsiyette dört kural var",
                context,
                style: detailTextBlue,
              ),
              const Divider(),
              buildTextRule(
                "1. Kelime sessiz harf ile bitiyorsa erkek,",
                context,
              ),
              buildTextRule(
                "2. -a harfi ile bitiyorsa dişi,",
                context,
              ),
              buildTextRule(
                "3. -o veya -e harfi ile bitiyorsa nötr,",
                context,
              ),
              const Divider(),
              const Text(
                "Örnekler",
                style: baslikTextBlack,
              ),

              /// Kelimlerde Cinsiyet
              buildTable(
                context,
                cinsiyetSample,
                "- 'o' veya 'e' ile Bitenler",
                [
                  (user) => user['erkek']!,
                  (user) => user['dişi']!,
                  (user) => user['nötr']!,
                ],
              ),
              const Text(
                "İstisnalar",
                style: baslikTextBlack,
              ),
              const Text("- Sto – stol (Hırvatça) (masa) – erkek"),
              const Text("- Krv (kan) – Dişi"),
              const Text("- Kolega (meslekdaş) – erkek"),
            ],
          ),
        ),
      ),
    );
  }
}
