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

  // controller tanımlaması
  var tfController = TextEditingController();
  String alinanVeri = "";

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
            // TextField : kullanıcının girdi girebildiği alan
            // TextFiled içinden bilgi okumak için controller kullanılır.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: tfController,
                obscureText: true,
                keyboardType: TextInputType.datetime,
                textAlign: TextAlign.center,
                maxLength: 8,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Yazınız ...",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20,
                  ),
                  labelText: "eMail",
                  labelStyle:TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                  filled: true,
                  fillColor: Colors.indigo,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  prefixIcon: Icon(Icons.print),
                ),
              ),
            ),
            ElevatedButton(
              child: const Text("Veriyi Al"),
              onPressed: (){
                setState(() {
                  // alınan veriyi aktarıyoruz.
                  alinanVeri = tfController.text;
                });
              },
            ),
            Text("Gelen Veri : $alinanVeri"),
          ],
        ),
      ),
    );
  }
}

