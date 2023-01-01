import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yasam_beklentisi/result_page.dart';
import 'package:yasam_beklentisi/user_data.dart';
import './icon_cinsiyet.dart';
import './my_container.dart';
import 'constant.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String seciliCinsiyet = "";
  double icilenSigara = 15.0;
  double sporGunu = 3;
  int boy = 170;
  int kilo = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YAŞAM BEKLENTİSİ',
          style: TextStyle(color: Colors.black54),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: MyContainer(
                    child: buildRowOutlineButton("BOY"),
                    onPress: () {},
                  ),
                ),
                Expanded(
                  child: MyContainer(
                    child: buildRowOutlineButton("KİLO"),
                    onPress: () {},
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: MyContainer(
              onPress: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Haftada kaç gün spor yapıyorsunuz ?",
                    style: kMetinStili,
                  ),
                  Text("${sporGunu.round()}", style: kSayiStili),
                  Slider(
                    min: 0,
                    max: 7,
                    divisions: 7,
                    value: sporGunu,
                    onChanged: (double newValue) {
                      setState(() {
                        sporGunu = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: MyContainer(
              onPress: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Günde kaç sigara içiyorsunuz ? ",
                    style: kMetinStili,
                  ),
                  Text("${icilenSigara.round()}", style: kSayiStili),
                  Slider(
                    min: 0,
                    max: 30,
                    value: icilenSigara,
                    onChanged: (double newValue) {
                      setState(() {
                        icilenSigara = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: MyContainer(
                    onPress: () {
                      setState(() {
                        seciliCinsiyet = "KADIN";
                      });
                    },
                    renk: seciliCinsiyet == "KADIN"
                        ? Colors.lightBlue.shade100
                        : Colors.white,
                    child: const IconCinsiyet(
                      cinsiyet: "KADIN",
                      icon: FontAwesomeIcons.venus,
                    ),
                  ),
                ),
                Expanded(
                  child: MyContainer(
                    onPress: () {
                      setState(() {
                        seciliCinsiyet = "ERKEK";
                      });
                    },
                    renk: seciliCinsiyet == "ERKEK"
                        ? Colors.lightBlue.shade100
                        : Colors.white,
                    child: const IconCinsiyet(
                      icon: FontAwesomeIcons.mars,
                      cinsiyet: "ERKEK",
                    ),
                  ),
                ),
              ],
            ),
          ),
          ButtonTheme(
            // Hesapla butonu
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      UserData(
                        kilo: kilo,
                        boy: boy,
                        seciliCinsiyet: seciliCinsiyet,
                        sporGunu: sporGunu,
                        icilenSigara: icilenSigara,
                      ),
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                textStyle: kMetinStili,
                backgroundColor: Colors.white,
                primary: Colors.black54,
              ),
              child: const Text("HESAPLA"),
            ),
          ),
        ],
      ),
    );
  }

  Row buildRowOutlineButton(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotatedBox(
          quarterTurns: -1, // saat yönü tersinde dönüş
          child: Text(
            label,
            style: kMetinStili,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        RotatedBox(
          quarterTurns: -1,
          child: Text(
            label == "BOY" ? boy.toString() : kilo.toString(),
            style: kSayiStili,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonTheme(
              minWidth: 36,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    label == "BOY" ? boy++ : kilo++;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.lightBlue,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  FontAwesomeIcons.plus,
                  size: 15,
                ),
              ),
            ),
            ButtonTheme(
              minWidth: 36,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    label == "BOY" ? boy-- : kilo--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.lightBlue,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  FontAwesomeIcons.minus,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
