import 'package:flutter/material.dart';

class SertifikaGoster extends StatefulWidget {
  final String resim;

  const SertifikaGoster({Key? key, required this.resim}) : super(key: key);

  @override
  _SertifikaGosterState createState() => _SertifikaGosterState();
}

class _SertifikaGosterState extends State<SertifikaGoster> {
  String adres = "assets/images/";


  @override
  Widget build(BuildContext context) {
    adres = adres + widget.resim;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sertifika Göster'),
      ),
      body: Center(
        child: Image.asset(
         // "assets/images/${widget.sertResim}",
         // "assets/images/btk-blokzincirkriptoparalar.jpg",
          adres,
        ), // Load the image
      ),
    );
  }
}
