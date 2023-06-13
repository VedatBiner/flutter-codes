import 'package:flutter/material.dart';
import 'package:kelime_ezber/database/db/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../global_variables.dart';
import 'main_page.dart';

class TemporaryPage extends StatefulWidget {
  const TemporaryPage({Key? key}) : super(key: key);

  @override
  State<TemporaryPage> createState() => _TemporaryPageState();
}

class _TemporaryPageState extends State<TemporaryPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      },
    );
    spRead();
    setFirebase();
  }

  /// Firebase messaging
  void setFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void spRead() async {
    if (await SP.read("lang") == true) {
      chooseLang = Lang.eng;
    } else {
      chooseLang = Lang.tr;
    }
    switch (await SP.read("which")) {
      case 0:
        chooseQuestionType = Which.learned;
        break;
      case 1:
        chooseQuestionType = Which.unlearned;
        break;
      case 2:
        chooseQuestionType = Which.all;
        break;
    }
    if (await SP.read("mix") == false) {
      listMixed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 130,
                      width: 110,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "QUEAZY",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Luck",
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "İstediğini Öğren",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Carter",
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
