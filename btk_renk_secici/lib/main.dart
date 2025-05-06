import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ColorPickerPage(),
    );
  }
}

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key});

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  final Map<Color, String> renkler = {
    Colors.red: "Kırmızı",
    Colors.green: "Yeşil",
    Colors.blue: "Mavi",
    Colors.yellow: "Sarı",
    Colors.orange: "Turuncu",
  };

  Color _secilenRenk = Colors.blue;
  bool isCircular = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Renk Seçici"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* Seçilen rengi gösteren kutu */
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: _secilenRenk,

                /// Şeklin tipini değiştir
                borderRadius: BorderRadius.circular(isCircular ? 100 : 10),
                boxShadow: [
                  BoxShadow(
                    color: _secilenRenk.withValues(alpha: 0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(renkler[_secilenRenk]!, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            /* Renk seçici açılır liste */
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<Color>(
                    value: _secilenRenk,
                    items:
                        renkler.entries
                            .map<DropdownMenuItem<Color>>(
                              (entry) => DropdownMenuItem<Color>(
                                value: entry.key,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: entry.key,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(entry.value),
                                  ],
                                ),
                              ),
                            )
                            .toList(), // ← toList() burada
                    onChanged: (renk) {
                      if (renk == null) return;
                      setState(() => _secilenRenk = renk);
                    },
                  ),
                  ElevatedButton(
                    onPressed: _rastgeleRenkSec,
                    child: const Text("Rastgele"),
                  ),
                  IconButton(
                    onPressed: _renginKodunuGoster,
                    icon: const Icon(Icons.info),
                  ),
                  IconButton(
                    onPressed: _containerSekliniDegistir,
                    icon: Icon(
                      isCircular
                          ? Icons.square_outlined
                          : Icons.circle_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _rastgeleRenkSec() {
    /// map listeye dönüştürülüyor.
    final colors = renkler.keys.toList();
    final rastgeleSayi = Random().nextInt(colors.length);
    final randomColor = colors[rastgeleSayi];
    setState(() => _secilenRenk = randomColor);
  }

  void _renginKodunuGoster() {
    Fluttertoast.showToast(
      msg: "RGB : ${_secilenRenk.r}, ${_secilenRenk.g}, ${_secilenRenk.b}",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: _secilenRenk,
      textColor: Colors.white,
      fontSize: 24.0,
    );
  }

  void _containerSekliniDegistir() {
    setState(() {
      isCircular = !isCircular;
    });
  }
}
