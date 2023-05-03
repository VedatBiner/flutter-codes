import 'package:flutter/material.dart';

import '../models/kelimeler.dart';

class DetailPage extends StatefulWidget {

  Kelimeler kelime;
  DetailPage({Key? key, required this.kelime}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detay Sayfa"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.kelime.ingilizce,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.pink
              ),
            ),
            Text(
              widget.kelime.turkce,
              style: const TextStyle(
                fontSize: 40,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
