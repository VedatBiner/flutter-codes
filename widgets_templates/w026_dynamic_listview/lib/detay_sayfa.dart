import 'package:flutter/material.dart';

class DetaySayfa extends StatefulWidget {
  String ulkeAdi;
  DetaySayfa({super.key, required this.ulkeAdi});

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detay"),
      ),
      body: Center(
        child: Text(
          widget.ulkeAdi,
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
