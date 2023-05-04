import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SertifikaGoster extends StatefulWidget {
  final String resim;

  const SertifikaGoster({Key? key, required this.resim}) : super(key: key);

  @override
  _SertifikaGosterState createState() => _SertifikaGosterState();
}

class _SertifikaGosterState extends State<SertifikaGoster> {
  late Future<Uint8List> _resimYukleme;

  @override
  void initState() {
    super.initState();
    _resimYukleme = _resimYukle();
  }

  Future<Uint8List> _resimYukle() async {
    // final adres = "assets/images/${widget.resim}";
    // final adres = "${widget.resim}";
    final adres = widget.resim;
    final ByteData veri = await rootBundle.load(adres);
    return veri.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sertifika Göster'),
      ),
      body: FutureBuilder<Uint8List>(
        future: _resimYukleme,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return Center(child: Image.memory(snapshot.data!));
          }
          return Container();
        },
      ),
    );
  }
}
