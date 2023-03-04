import 'package:flutter/material.dart';
import '../tahmin_ekrani.dart';

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
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anasayfa"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Tahmin Oyunu",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 36,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("resimler/zar.jpg"),
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                child: const Text("Başla"),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TahminEkrani()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
