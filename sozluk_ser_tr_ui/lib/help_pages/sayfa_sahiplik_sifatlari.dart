/// <----- sayfa_sahiplik_sifatlari.drt ----->
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/drawer_constants.dart';
import '../constants/grammar_constants/const_sahiplik_sifatlari.dart';
import '../constants/app_constants/constants.dart';
import '../screens/home_page_parts/drawer_items.dart';
import '../utils/text_header.dart';
import '../utils/text_rule.dart';
import 'help_parts/build_table.dart';
import 'help_parts/custom_appbar.dart';

class SayfaSahiplikSifatlari extends StatefulWidget {
  const SayfaSahiplikSifatlari({super.key});

  @override
  State<SayfaSahiplikSifatlari> createState() => _SayfaSahiplikSifatlariState();
}

class _SayfaSahiplikSifatlariState extends State<SayfaSahiplikSifatlari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarSahiplikSifatlariTitle,
      ),
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextHeader(
                "Sahiplik sıfatları",
                context,
                style: detailTextBlue,
              ),
              const Divider(),
              buildTextRule(
                "Burada önemli olan insanın da cinsiyetinin belirtilmesidir. "
                "İsmin cinsiyeti ve insanın cinsiyeti birlikte kullanılıyor. "
                "Benim ve senin sözcükleri, söyleyenin cinsiyetine göre "
                "değişmez. Kullanıldığı isme göre değişir. Benim arabam "
                "denilince arabanın cinsiyeti önemlidir. Söyleyenin "
                "cinsiyeti önemli değildir. ",
                context,
              ),
              buildTable(
                sahiplikSifatlariSampleA,
                "Sahiplik sıfatları",
                [
                  (user) => user['şahıs']!,
                  (user) => user['erkek']!,
                  (user) => user['dişi']!,
                  (user) => user['nötr']!,
                ],
              ),
              const Divider(),
              buildTable(
                sahiplikSifatlariSampleB,
                "Örnek - 1 - Život (hayat) Erkek cins isim",
                [
                  (user) => user['sırpça']!,
                  (user) => user['türkçe']!,
                ],
              ),
              const Divider(),
              buildTable(
                sahiplikSifatlariSampleC,
                "Örnek - 2 - Škola (okul) Dişi cins isim",
                [
                  (user) => user['sırpça']!,
                  (user) => user['türkçe']!,
                ],
              ),
              const Divider(),
              buildTable(
                sahiplikSifatlariSampleD,
                "Örnek - 3 - Selo (köy) Nötr cins isim",
                [
                  (user) => user['sırpça']!,
                  (user) => user['türkçe']!,
                ],
              ),
              const Divider(),
              buildTable(
                sahiplikSifatlariSampleE,
                "Örnek - 4 - Škola (okul) Dişi cins isim (çoğul)",
                [
                  (user) => user['sırpça']!,
                  (user) => user['türkçe']!,
                ],
              ),
              const Divider(),
              buildTable(
                sahiplikSifatlariSampleF,
                "Sahiplik sıfatları - Çoğul",
                [
                  (user) => user['şahıs']!,
                  (user) => user['erkek']!,
                  (user) => user['dişi']!,
                  (user) => user['nötr']!,
                ],
              ),
              const Divider(),
              buildTable(
                sahiplikSifatlariSampleG,
                "Sestra (kız kardeş) Çoğul",
                [
                  (user) => user['tekil']!,
                  (user) => user['çoğul']!,
                  (user) => user['türkçe (çoğul)']!,
                ],
              ),
              const Divider(),
              buildTable(
                sahiplikSifatlariSampleH,
                "Örnekler",
                [
                  (user) => user['türkçe']!,
                  (user) => user['sırpça']!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
