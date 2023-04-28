import 'package:flutter/material.dart';
import '../models/sertifikalar.dart';

class SertifikaDetay extends StatefulWidget {
  final Sertifikalar sertifika;
  const SertifikaDetay({Key? key, required this.sertifika}) : super(key: key);

  @override
  State<SertifikaDetay> createState() => _SertifikaDetayState();
}

class _SertifikaDetayState extends State<SertifikaDetay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sertifika Detay Sayfası"),
      ),
      body: Center(
        child: Text(widget.sertifika.sertDetay),
      ),
    );
  }
}
