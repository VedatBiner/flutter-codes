import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true, // başlığı ortaya aldık
          title: const Text("Mutlu Bayramlar"),
        ),
        body: Center(
          child: Image.asset(
            "assets/images/bayram.jpg",
          ),
        ),
      ),
    ),
  );
}
