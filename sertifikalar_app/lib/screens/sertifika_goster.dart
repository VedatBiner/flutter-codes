import 'package:flutter/material.dart';

class SertifikaGoster extends StatefulWidget {
  final String sertResim;

  const SertifikaGoster({super.key, required this.sertResim});

  @override
  _SertifikaGosterState createState() => _SertifikaGosterState();
}

class _SertifikaGosterState extends State<SertifikaGoster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sertifika Göster'),
      ),
      body: Center(
        child: Image.asset(
          "/assets/images/${widget.sertResim}",
        ), // Load the image
      ),
    );
  }
}
