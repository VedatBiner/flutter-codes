import 'package:flutter/material.dart';
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
                    Image.asset("assets/images/logo.png"),
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









