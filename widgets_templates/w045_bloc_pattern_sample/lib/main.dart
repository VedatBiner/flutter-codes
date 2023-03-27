import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'anasayfa.dart';
import 'anasayfa_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AnasayfaCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Anasayfa(),
      ),
    );
  }
}
