// 📜 <----- color_picker_page.dart ----->

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/colors.dart';
import '../widgets/color_display.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key});

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color _secilenRenk = Colors.blue;
  bool isCircular = false;
  bool isShowColorName = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Renk Seçici"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                isShowColorName = !isShowColorName;
              });
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "a",
                  child: Row(
                    children: [
                      Icon(
                        isShowColorName
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      Text(
                        isShowColorName
                            ? " Renk adını gizle"
                            : " Renk adını göster",
                      ),
                    ],
                  ),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* Seçilen rengi gösteren kutu */
            ColorDisplay(secilenRenk: _secilenRenk, isCircular: isCircular),
            const SizedBox(height: 10),
            isShowColorName
                ? Text(
                  renkler[_secilenRenk] ?? "seçilen renk",
                  style: TextStyle(fontSize: 20, color: _secilenRenk),
                )
                : const SizedBox(),
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
