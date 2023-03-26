import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample/sayac_model.dart';
import 'ikincisayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // sınıf modellerimizi uygulamaya tanıtalım
        ChangeNotifierProvider(create: (context) => SayacModel(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Anasayfa(),
      ),
    );
  }
}

class Anasayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anasayfa"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // dinleme yapacağımız widget
            Consumer<SayacModel>(
              builder: (context, sayacModelNesne, child){
                // dinleme gerçekleşince son değeri oku
                return Text(
                  "${sayacModelNesne.sayaciOku()}",
                  style: const TextStyle(fontSize: 26),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IkinciSayfa(),
                  ),
                );
              },
              child: const Text("Geçiş Yap"),
            ),
          ],
        ),
      ),
    );
  }
}
