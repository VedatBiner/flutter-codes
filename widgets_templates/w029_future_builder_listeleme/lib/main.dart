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

  Future<List<String>> verileriGetir() async {
    // Liste veri tipinde içerikleri String olan bir metot
    var ulkeListesi = ["Türkiye", "Almanya", "Fransa", "İtalya", "Rusya", "Çin"];
    return ulkeListesi;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<String>>(
        future: verileriGetir(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            var ulkeListesi = snapshot.data;
            return ListView.builder(
              itemCount: ulkeListesi!.length,
              itemBuilder: (context, index){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Text(ulkeListesi[index]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center();
          }
        },
      ),

    );
  }
}
