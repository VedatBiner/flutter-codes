import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/anasayfa_cubit.dart';
import '../cubit/kisi_kayit_cubit.dart';
import '../cubit/kisi_detay_cubit.dart';
import '../screens/anasayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => KisiKayitCubit()),
        BlocProvider(create: (context) => KisiDetayCubit()),
        BlocProvider(create: (context) => AnasayfaCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Anasayfa(),
      ),
    );
  }
}

