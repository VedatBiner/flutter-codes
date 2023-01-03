import 'package:flutter/material.dart';
import 'constants.dart';

void main() => runApp(const BilgiTesti());

class BilgiTesti extends StatelessWidget {
  const BilgiTesti({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.indigo[700],
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: SoruSayfasi(),
          ),
        ),
      ),
    );
  }
}

class SoruSayfasi extends StatefulWidget {
  const SoruSayfasi({Key? key}) : super(key: key);

  @override
  _SoruSayfasiState createState() => _SoruSayfasiState();
}

class _SoruSayfasiState extends State<SoruSayfasi> {
  List<Widget> secimler = [];

  List<Soru> soruBankasi = [
    Soru(soruMetni: "Titanic gelmiş geçmiş en büyük gemidir.", soruYaniti: false),
    Soru(soruMetni: "Dünyadaki tavuk sayısı insan sayısından fazladır.", soruYaniti: true),
    Soru(soruMetni: "Kelebeklerin ömrü bir gündür.", soruYaniti: false),
    Soru(soruMetni: "Dünya Düzdür.", soruYaniti: false),
    Soru(soruMetni: "Kaju fıstığı aslında bir meyvenin sapıdır.", soruYaniti: true),
    Soru(soruMetni: "Fatih Sultan Mehmet hiç patates yememiştir.", soruYaniti: true)
  ];

  int soruIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                soruBankasi[soruIndex].soruMetni,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Wrap(
          spacing: 3,
          runSpacing: 3,
          children: secimler,
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.red,
                        ),
                      ),
                      child: const Icon(
                        Icons.thumb_down,
                        size: 30.0,
                      ),
                      onPressed: () {
                        setState(() {
                          soruBankasi[soruIndex].soruYaniti == false
                              ? secimler.add(kDogruIkonu)
                              : secimler.add(kYanlisIkonu);
                          soruIndex++;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.green,
                        ),
                      ),
                      child: const Icon(
                        Icons.thumb_up,
                        size: 30.0,
                      ),
                      onPressed: () {
                        setState(() {
                          soruBankasi[soruIndex].soruYaniti == true
                              ? secimler.add(kDogruIkonu)
                              : secimler.add(kYanlisIkonu);
                          soruIndex++;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ]),
          ),
        )
      ],
    );
  }
}

class Soru{
  String soruMetni;
  bool soruYaniti;

  Soru({required this.soruMetni, required this.soruYaniti});
}
