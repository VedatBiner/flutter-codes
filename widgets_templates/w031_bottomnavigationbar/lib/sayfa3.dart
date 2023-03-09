import 'package:flutter/material.dart';

class SayfaUc extends StatefulWidget {
  const SayfaUc({Key? key}) : super(key: key);

  @override
  State<SayfaUc> createState() => _SayfaUcState();
}

class _SayfaUcState extends State<SayfaUc> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Sayfa Üç",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 30,
        ),
      ),
    );
  }
}
