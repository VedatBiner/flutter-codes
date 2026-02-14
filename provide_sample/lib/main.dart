import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  String sehir = "Adana";

  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('callback kullanımı'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: SolWidgetA(sehir: sehir,)),
            Expanded(child: SagWidgetA(sehir: sehir,))
          ],
        ),
      ),
    );
  }
}

class SolWidgetA extends StatelessWidget {


  final String sehir;

  const SolWidgetA({Key? key, required this.sehir}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellow,
        child: Column(
          children: [
            const Text(
              'Sol Widget',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Sehir: $sehir ',
              style: const TextStyle(fontSize: 20),
            )
          ],
        ));
  }
}

class SagWidgetA extends StatelessWidget {
  final String sehir;

  const SagWidgetA({Key? key, required this.sehir}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(children: [
        const Text(
          'SagWidget A',
          style: TextStyle(fontSize: 20),
        ),
        SagWidgetB(sehir: sehir,)
      ]),
    );
  }
}

class SagWidgetB extends StatelessWidget {
  final String sehir;

  const SagWidgetB({Key? key, required this.sehir}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 180,
      color: Colors.purple,
      child: Column(children: [
        const Text(
          'SagWidget B',
          style: TextStyle(fontSize: 20),
        ),
        SagWidgetC(sehir: sehir,)
      ]),
    );
  }
}

class SagWidgetC extends StatelessWidget {
  final String sehir;

  const SagWidgetC({Key? key, required this.sehir}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 150,
      width: 160,
      child: Column(children: [
        const Text(
          'SagWidget C',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Şehir: $sehir ',
          style: const TextStyle(fontSize: 20),
        ),
        const TextField(onChanged: null)
      ]),
    );
  }
}