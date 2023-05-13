import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sehir = "Adana";
  void changeCity(String newCity){
    setState(() {
      sehir = newCity;
    });
  }

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
            Expanded(child: SagWidgetA(sehir: sehir,callback: changeCity,)) // sadece fonksiyon adı olacak
          ],
        ),
      ),
    );
  }
}

class SolWidgetA extends StatelessWidget {
  const SolWidgetA({Key? key, required this.sehir}) : super(key: key);
  final String sehir;

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
  final Function callback;
  const SagWidgetA({Key? key, required this.sehir, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(children: [
        const Text(
          'SagWidget A',
          style: TextStyle(fontSize: 20),
        ),
        SagWidgetB(sehir: sehir, callback: callback,)
      ]),
    );
  }
}

class SagWidgetB extends StatelessWidget {
  final String sehir;
  final Function callback;
  const SagWidgetB({Key? key, required this.sehir, required this.callback}) : super(key: key);

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
        SagWidgetC(sehir: sehir, callback: callback,)
      ]),
    );
  }
}

class SagWidgetC extends StatelessWidget {
  final String sehir;
  final Function callback;
  const SagWidgetC({Key? key, required this.sehir, required this.callback}) : super(key: key);

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
        TextField(
            onChanged: (input){
              callback(input);
            }
        )
      ]),
    );
  }
}

