// 📜 <----- sayfa_sahiplik_sifatlari.drt ----->

import 'package:flutter/material.dart';

import '../../../widgets/help_page_widgets/build_table.dart';
import '../../../widgets/help_page_widgets/help_custom_app_bar.dart';
import '../../../widgets/help_page_widgets/help_custom_drawer.dart';
import '../../text_constants.dart';
import '../constants/const_sahiplik_sifatlari.dart';

class SayfaSahiplikSifatlari extends StatefulWidget {
  const SayfaSahiplikSifatlari({super.key});

  @override
  State<SayfaSahiplikSifatlari> createState() => _SayfaSahiplikSifatlariState();
}

/// 📌 Ana kod
class _SayfaSahiplikSifatlariState extends State<SayfaSahiplikSifatlari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHelpAppBar(),
      drawer: buildHelpDrawer(),
      body: buildBody(context),
    );
  }

  /// 📌 Body bloğu
  SingleChildScrollView buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sahiplik sıfatları", style: detailTextBlue),
            const Divider(),
            const Text(
              "Burada önemli olan insanın da cinsiyetinin belirtilmesidir. "
              "İsmin cinsiyeti ve insanın cinsiyeti birlikte kullanılıyor. "
              "Benim ve senin sözcükleri, söyleyenin cinsiyetine göre "
              "değişmez. Kullanıldığı isme göre değişir. Benim arabam "
              "denilince arabanın cinsiyeti önemlidir. Söyleyenin "
              "cinsiyeti önemli değildir. ",
            ),
            buildTable(sahiplikSifatlariSampleA, "Sahiplik sıfatları", [
              (user) => user['şahıs']!,
              (user) => user['erkek']!,
              (user) => user['dişi']!,
              (user) => user['nötr']!,
            ]),
            const Divider(),
            buildTable(
              sahiplikSifatlariSampleB,
              "Örnek - 1 - Život (hayat) Erkek cins isim",
              [(user) => user['sırpça']!, (user) => user['türkçe']!],
            ),
            const Divider(),
            buildTable(
              sahiplikSifatlariSampleC,
              "Örnek - 2 - Škola (okul) Dişi cins isim",
              [(user) => user['sırpça']!, (user) => user['türkçe']!],
            ),
            const Divider(),
            buildTable(
              sahiplikSifatlariSampleD,
              "Örnek - 3 - Selo (köy) Nötr cins isim",
              [(user) => user['sırpça']!, (user) => user['türkçe']!],
            ),
            const Divider(),
            buildTable(
              sahiplikSifatlariSampleE,
              "Örnek - 4 - Škola (okul) Dişi cins isim (çoğul)",
              [(user) => user['sırpça']!, (user) => user['türkçe']!],
            ),
            const Divider(),
            buildTable(sahiplikSifatlariSampleF, "Sahiplik sıfatları - Çoğul", [
              (user) => user['şahıs']!,
              (user) => user['erkek']!,
              (user) => user['dişi']!,
              (user) => user['nötr']!,
            ]),
            const Divider(),
            buildTable(sahiplikSifatlariSampleG, "Sestra (kız kardeş) Çoğul", [
              (user) => user['tekil']!,
              (user) => user['çoğul']!,
              (user) => user['türkçe (çoğul)']!,
            ]),
            const Divider(),
            buildTable(sahiplikSifatlariSampleH, "Örnekler", [
              (user) => user['türkçe']!,
              (user) => user['sırpça']!,
            ]),
          ],
        ),
      ),
    );
  }
}
