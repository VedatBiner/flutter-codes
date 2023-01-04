import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DrumMachine());
}

class DrumMachine extends StatelessWidget {
  DrumMachine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: DrumPage(),
      ),
    );
  }
}

class DrumPage extends StatelessWidget {
  DrumPage({Key? key}) : super(key: key);

  final oynatici = AudioPlayer();

  void sesiCal(String ses) async {
    // await oynatici.play(UrlSource("$ses.wav"));
    await oynatici.play(AssetSource("$ses.wav"));
    //
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: buildDrumPad("bongo", Colors.blueAccent),
                  ),
                  Expanded(
                    child: buildDrumPad("bip", Colors.redAccent),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: buildDrumPad("clap1", Colors.greenAccent),
                  ),
                  Expanded(
                    child: buildDrumPad("clap2", Colors.amberAccent),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: buildDrumPad("clap3", Colors.indigoAccent),
                  ),
                  Expanded(
                    child: buildDrumPad("crash", Colors.cyanAccent),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: buildDrumPad("how", Colors.orangeAccent),
                  ),
                  Expanded(
                    child: buildDrumPad("oobah", Colors.purpleAccent),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: buildDrumPad("ridebel", Colors.limeAccent),
                  ),
                  Expanded(
                    child: buildDrumPad("woo", Colors.indigoAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextButton buildDrumPad(String ses, Color renk) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
      ),
      onPressed: () {
        sesiCal(ses);
      },
      child: Container(
        color: renk,
      ),
    );
  }
}
