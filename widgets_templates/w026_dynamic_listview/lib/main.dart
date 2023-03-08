import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:w026_dynamic_listview/detay_sayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var ulkeler = ["Türkiye", "Almanya", "İtalya", "Rusya", "Çin"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: ulkeler.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              // Card tıklanıyor
              onTap: () {
                //  log("${ulkeler[index]} tıklandı ...");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetaySayfa(ulkeAdi: ulkeler[index],),
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        GestureDetector(
                          // Text tıklanıyor
                          onTap: () {
                            log("Text ile ${ulkeler[index]} seçildi.");
                          },
                          child: Text(
                            ulkeler[index],
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton(
                          child: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 1,
                              child: Text("Sil"),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text("Güncelle"),
                            ),
                          ],
                          onSelected: (menuItemValue){
                            if(menuItemValue == 1){
                              log("${ulkeler[index]} silindi.");
                            }
                            if(menuItemValue == 2){
                              log("${ulkeler[index]} güncellendi.");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
