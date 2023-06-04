import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kelime_ezber/pages/words_card.dart';
import 'package:kelime_ezber/widgets/appbar_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../methods.dart';
import 'lists.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

enum Lang { eng, tr }

Uri _url = Uri.parse("https://www.udemy.com/");

class _MainPageState extends State<MainPage> {
  Lang? _chooseLang = Lang.eng;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PackageInfo? packageInfo;
  String version = "";

  @override
  void initState() {
    super.initState();
    packageInfoInit();
  }

  // versiyon bilgisini alıyoruz
  void packageInfoInit() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 80,
                  ),
                  const Text(
                    "QUEZY",
                    style: TextStyle(
                      fontFamily: "RobotoLight",
                      fontSize: 26,
                    ),
                  ),
                  const Text(
                    "İstediğini öğren",
                    style: TextStyle(
                      fontFamily: "RobotoLight",
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: const Divider(
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50, left: 8, right: 8),
                    child: const Text(
                      "Bir uygulamanın nasıl yapıldığını, aşama aşama öğrenmek için",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "RobotoLight",
                        fontSize: 14,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await launchUrl(_url)
                          ? await launchUrl(_url)
                          : throw Exception('Could not launch $_url');
                    },
                    child: Text(
                      "Tıkla",
                      style: TextStyle(
                        fontFamily: "RobotoLight",
                        fontSize: 16,
                        color: Color(
                          RenkMetod.HexaColorConverter("#0A588D"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "v$version \nvb@gmail.com",
                  style: TextStyle(
                    fontFamily: "RobotoLight",
                    fontSize: 14,
                    color: Color(
                      RenkMetod.HexaColorConverter("#0A588D"),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: appBar(context,
          left: const FaIcon(
            FontAwesomeIcons.bars,
            color: Colors.black,
            size: 22,
          ),
          center: Image.asset("assets/images/logo_text.png"),
          leftWidgetOnClick: () => {_scaffoldKey.currentState!.openDrawer()}),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                langRadioButton(
                  text: "İngilizce - Türkçe",
                  group: _chooseLang!,
                  value: Lang.tr,
                ),
                langRadioButton(
                  text: "Türkçe - İngilizce",
                  group: _chooseLang!,
                  value: Lang.eng,
                ),
                const SizedBox(height: 25),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListsPage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Color(RenkMetod.HexaColorConverter("#7d20a6")),
                            Color(RenkMetod.HexaColorConverter("#481183")),
                          ]),
                    ),
                    child: const Text(
                      "Listelerim",
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: "Carter",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildCard(
                        context,
                        startColor: "#1DACC9",
                        endColor: "#0C33B2",
                        title: "Kelime\nKartları",
                        click: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WordsCardPage(),
                            ),
                          );
                        },
                      ),
                      buildCard(
                        context,
                        startColor: "#FF3348",
                        endColor: "#B029B9",
                        title: "Çoktan\nSeçmeli",
                        click: () {

                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // orijinal kod da card olarak metod adı verilmiş
  InkWell buildCard(
    BuildContext context, {
    required String startColor,
    required String endColor,
    required String title,
    required Function click,
  }) {
    return InkWell(
      onTap: () => click(),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width * 0.37,
        margin: const EdgeInsets.only(bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(RenkMetod.HexaColorConverter(startColor)),
                Color(RenkMetod.HexaColorConverter(endColor)),
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontFamily: "Carter",
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const Icon(
              Icons.file_copy,
              size: 32,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // radio butonlar
  SizedBox langRadioButton({
    required String text,
    required Lang value,
    required Lang group,
  }) {
    return SizedBox(
      width: 250,
      height: 30,
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(
            fontFamily: "Carter",
            fontSize: 16,
          ),
        ),
        leading: Radio<Lang>(
          value: value,
          groupValue: group,
          onChanged: (Lang? value) {
            setState(() {
              _chooseLang = value!;
            });
          },
        ),
      ),
    );
  }
}
