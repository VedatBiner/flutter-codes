import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var tfTarih = TextEditingController();
  var tfSaat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: tfSaat,
              decoration: const InputDecoration(
                hintText: "Saat giriniz ...",
              ),
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                ).then((alinanSaat) {
                  setState(() {
                    tfSaat.text = "${alinanSaat!.hour}:${alinanSaat!.minute}";
                  });
                }
                );
              }),
            TextField(
                controller: tfTarih,
                decoration: const InputDecoration(
                  hintText: "Tarih giriniz ...",
                ),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2050),
                  ).then((alinanTarih) {
                    setState(() {
                      tfTarih.text = "${alinanTarih!.day}/${alinanTarih!.month}/${alinanTarih.year}";
                    });
                  }
                  );
                }),
          ],
        ),
      ),
    );
  }
}
