import 'package:flutter/material.dart';

class Sayfa2 extends StatefulWidget {
  const Sayfa2({Key? key}) : super(key: key);

  @override
  State<Sayfa2> createState() => _Sayfa2State();
}

class _Sayfa2State extends State<Sayfa2> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Sayfa İki",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 30,
        ),
      ),
    );
  }
}
