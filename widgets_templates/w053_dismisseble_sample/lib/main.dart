import 'package:flutter/material.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dissmising Items"),
        ),
        body: AnaEkran(),
      ),
    );
  }
}
class AnaEkran extends StatefulWidget {
  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  List ogeler = ["Bir", "İki", "Üç", "Dört", "Beş", "Altı"];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: ogeler.length,
        itemBuilder: (context, indeksNumarasi) {
          return Dismissible(
              background: Container(color: Colors.red),
              onDismissed: (direction) {
                setState(() {
                  ogeler.removeAt(indeksNumarasi);
                });
                print(
                    "Ekranın ${indeksNumarasi + 1}. sırasındaki eleman listeden çıkartıldı");
                print("Kalan elemanlar: $ogeler");
              },
              key: Key(ogeler[indeksNumarasi]),
              child: ListTile(title: Text(ogeler[indeksNumarasi])));
        });
  }
}





