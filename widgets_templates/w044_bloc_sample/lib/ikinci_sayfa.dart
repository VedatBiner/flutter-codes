import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sayac_cubit.dart';

class IkinciSayfa extends StatelessWidget {
  const IkinciSayfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İkinci Sayfa"),
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
            // butonlar tetikleme yapacak
            ElevatedButton(
              onPressed: () {
                context.read<SayacCubit>().sayaciArttir();
              },
              child: const Text("Sayaç Arttır"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<SayacCubit>().sayaciAzalt(2);
              },
              child: const Text("Sayaç Azalt"),
            ),
          ],
        ),
      ),
    );
  }
}
