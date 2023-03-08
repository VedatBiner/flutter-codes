import 'package:film_app/detay_sayfa.dart';
import 'package:flutter/material.dart';
import 'filmler.dart';

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
        primarySwatch: Colors.indigo,
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
  Future<List<Filmler>> fimleriGetir() async {
    var filmlerListesi = <Filmler>[];
    var f1 = Filmler(1, "Anadoluda", "anadoluda.png", 15.99);
    var f2 = Filmler(2, "Django", "django.png", 7.99);
    var f3 = Filmler(3, "Interstellar", "interstellar.png", 7.99);
    var f4 = Filmler(4, "Inception", "inception.png", 21.99);
    var f5 = Filmler(5, "The Hateful Eight", "thehatefuleight.png", 5.99);
    var f6 = Filmler(6, "The Pianist", "thepianist.png", 17.99);

    filmlerListesi.add(f1);
    filmlerListesi.add(f2);
    filmlerListesi.add(f3);
    filmlerListesi.add(f4);
    filmlerListesi.add(f5);
    filmlerListesi.add(f6);

    return filmlerListesi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filmler"),
      ),
      body: FutureBuilder<List<Filmler>>(
        future: fimleriGetir(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // filmleri alalım
            var filmlerListei = snapshot.data;
            return GridView.builder(
              itemCount: filmlerListei!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3.5,
              ),
              itemBuilder: (context, index) {
                var film = filmlerListei[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetaySayfa(
                          film: film,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("resimler/${film.filmResimAdi}"),
                        ),
                        Text(
                          film.filmAdi,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${film.filmFiat} \u{20BA}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
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
