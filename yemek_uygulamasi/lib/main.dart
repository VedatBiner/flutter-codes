import 'package:flutter/material.dart';
import 'package:yemek_uygulamasi/detay_sayfa.dart';
import '../yemekler.dart';

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
        primarySwatch: Colors.orange,
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

  Future<List<Yemekler>> yemekleriGetir() async {
    var yemekListesi = <Yemekler>[];
    // nesneleri oluşturalım.
    var y1 = Yemekler(1, "Köfte", "kofte.png", 15.99);
    var y2 = Yemekler(2, "Ayran", "ayran.png", 2.00);
    var y3 = Yemekler(3, "Fanta", "fanta.png", 3.00);
    var y4 = Yemekler(4, "Makarna", "makarna.png", 14.99);
    var y5 = Yemekler(5, "Kadayıf", "kadayif.png", 8.50);
    var y6 = Yemekler(6, "Baklava", "baklava.png", 15.99);

    // yemekleri listeye ekleyelim
    yemekListesi.add(y1);
    yemekListesi.add(y2);
    yemekListesi.add(y3);
    yemekListesi.add(y4);
    yemekListesi.add(y5);
    yemekListesi.add(y1);

    return yemekListesi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yemekler"),
      ),
      body: FutureBuilder<List<Yemekler>>(
        future: yemekleriGetir(),
        builder: (context, snapshot){
          // bilgi geldi mi?
          if(snapshot.hasData){
            var yemekListesi = snapshot.data;
            return ListView.builder(
              itemCount: yemekListesi!.length,
              itemBuilder: (context, index){
                // sanki bir döngü gibi çalışıp listeyi alır
                var yemek = yemekListesi[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => DetaySayfa(yemek: yemek),
                      ),
                    );
                  },
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 150, height: 150,
                          child: Image.asset("resimler/${yemek.yemekResimAdi}"),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              yemek.yemekAdi,
                              style: const TextStyle(fontSize: 25),
                            ),
                            const SizedBox(height: 50,),
                            Text(
                              "${yemek.yemekFiyat} \u{20BA}",
                              style: const TextStyle(
                                fontSize: 20, color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            // bilgi gelmediyse
            return const Center();
          }
        },
      ),

    );
  }
}




