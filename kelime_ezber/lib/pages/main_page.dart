import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kelime_ezber/methods.dart';
import 'package:kelime_ezber/pages/lists.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

enum Lang { eng, tr }

class _MainPageState extends State<MainPage> {
  Lang _chooseLang = Lang.eng;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                    onTap: (){},
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
                  "v0.9\nvb@gmail.com",
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.20,
                child: InkWell(
                  onTap: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.bars,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset("assets/images/logo_text.png"),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                langRadioButton(
                  text: "İngilizce - Türkçe",
                  group: _chooseLang,
                  value: Lang.tr,
                ),
                langRadioButton(
                  text: "Türkçe - İngilizce",
                  group: _chooseLang,
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
                      buildContainer(
                        context,
                        startColor: "#1DACC9",
                        endColor: "#0C33B2",
                        title: "Kelime\nKartları",
                        iconWidget: const Icon(
                          Icons.file_copy,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      buildContainer(
                        context,
                        startColor: "#FF3348",
                        endColor: "#B029B9",
                        title: "Çoktan\nSeçmeli",
                        iconWidget: const Icon(
                          Icons.check_circle_outline,
                          size: 32,
                          color: Colors.white,
                        ),
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

  Container buildContainer(
    BuildContext context, {
    required String startColor,
    required String endColor,
    required String title,
    required Widget iconWidget,
  }) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width * 0.37,
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
              fontSize: 28,
              fontFamily: "Carter",
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          iconWidget,
        ],
      ),
    );
  }

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
