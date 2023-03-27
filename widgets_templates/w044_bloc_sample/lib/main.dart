import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w_bloc_sample/sayac_cubit.dart';
import 'ikinci_sayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // sınıf modelimizi tanımlayalım
      providers: [
        BlocProvider(create: (context) => SayacCubit()),
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
            // text yapısı dinleme yapacak
            BlocBuilder<SayacCubit, int>(
              builder: (context, sayacDegeri){
                return Text(
                  "$sayacDegeri",
                  style: const TextStyle(fontSize: 36),
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

