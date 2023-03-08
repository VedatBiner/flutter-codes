import 'package:flutter/material.dart';

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

  String resimAdi1 = "https://tse4.mm.bing.net/th?id=OIP.OgviVnhDy5O9mIZA4Jjo2QHaK-";
  String resimAdi2 = "https://tse4.mm.bing.net/th?id=OIP.bHgCqcyd7CvcvTmZ0uKDtgHaLH";
  String resimAdi = "https://tse4.mm.bing.net/th?id=OIP.OgviVnhDy5O9mIZA4Jjo2QHaK-";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInImage.assetNetwork(
              placeholder: "resimler/placeholder.png",
              image: "$resimAdi",
            ),
            ElevatedButton(
              child: const Text("Resim 1"),
              onPressed: (){
                setState(() {
                  resimAdi = resimAdi1;
                });
              },
            ),
            ElevatedButton(
              child: const Text("Resim 2"),
              onPressed: (){
                setState(() {
                  resimAdi = resimAdi2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
