import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/screens/home/home_screen.dart';
import 'models/NavItem.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NavItems(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recipe App',
        theme: ThemeData(
          // backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          // We apply this to our appBarTheme because most
          // of our appBar have this style
          appBarTheme: const AppBarTheme(color: Colors.white, elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
    );
  }
}
