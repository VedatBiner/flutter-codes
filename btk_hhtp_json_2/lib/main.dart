import 'package:btk_hhtp_json_2/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const HttpApp());
}

class HttpApp extends StatelessWidget{
  const HttpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }

}
