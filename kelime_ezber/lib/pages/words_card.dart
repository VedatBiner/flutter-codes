import 'package:flutter/material.dart';
import 'package:kelime_ezber/methods.dart';
import 'package:kelime_ezber/widgets/appbar_page.dart';

class WordsCardPage extends StatefulWidget {
  const WordsCardPage({Key? key}) : super(key: key);

  @override
  State<WordsCardPage> createState() => _WordsCardPageState();
}

enum Which { learn, unlearned, all }

class _WordsCardPageState extends State<WordsCardPage> {
  Which? _chooseQuestionType = Which.learn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        left: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 22,
        ),
        center: const Text(
          "Kelime Kartları",
          style: TextStyle(
            fontFamily: "Carter",
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        leftWidgetOnClick: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 0,
            bottom: 16,
          ),
          padding: const EdgeInsets.only(left: 4, top: 4, right: 4),
          decoration: BoxDecoration(
            color: Color(RenkMetod.HexaColorConverter("#DCDEFF")),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whichRadiobutton(
                  text: "Öğrenmediklerimi sor", value: Which.unlearned),
              whichRadiobutton(text: "Öğrendiklerimi sor", value: Which.learn),
              whichRadiobutton(text: "Hepsini sor", value: Which.all),
              checkBox("Listeyi karıştır"),
              const SizedBox(height: 20),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "Listeler",
                  style: TextStyle(
                    fontFamily: "RobotoRegular",
                    fontSize: 18,
                    color: Colors.black
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox whichRadiobutton({required String text, required Which value}) {
    return SizedBox(
      width: 275,
      height: 32,
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(
            fontFamily: "RobotoRegular",
            fontSize: 18,
          ),
        ),
        leading: Radio<Which>(
          value: value,
          groupValue: _chooseQuestionType,
          onChanged: (Which? value) {
            setState(() {
              _chooseQuestionType = value;
            });
          },
        ),
      ),
    );
  }

  SizedBox checkBox(String text) {
    return SizedBox(
      width: 270,
      height: 35,
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(
            fontFamily: "RobotoRegular",
            fontSize: 18,
          ),
        ),
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.deepPurpleAccent,
          hoverColor: Colors.blueAccent,
          value: true,
          onChanged: (bool? value) {},
        ),
      ),
    );
  }
}
