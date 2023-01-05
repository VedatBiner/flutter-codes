import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GIF API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GIF API Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<String> gifUrls = [];

  // API den istenen GIF videoları okuyoruz
  Future<void> getGIFFromAPI(String word) async {
    var data = await http.get(
      Uri.parse(
        'https://api.tenor.com/v1/search?q=$word&key=LIVDSRZULELA&limit=8',
      ),
    );
    var dataParsed = jsonDecode(data.body);
    gifUrls.clear();
    for (int i = 0; i < 8; i++) {
      gifUrls.add(dataParsed['results'][i]['media'][0]['tinygif']['url']);
    }
    setState(() {});
  }

  @override
  void initState() {
    getGIFFromAPI('superman');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: TextField(
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _controller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  getGIFFromAPI(_controller.text);
                },
                child: const Text(
                  "GIF Getir",
                ),
              ),
              gifUrls.isEmpty
                  ? const CircularProgressIndicator()
                  : SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.separated(
                  itemCount: 8,
                  itemBuilder: (_, int index) {
                    return GifCard(gifUrls[index]);
                  },
                  separatorBuilder: (_, __) {
                    return const Divider(
                      color: Colors.blue,
                      thickness: 5,
                      height: 5,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GifCard extends StatelessWidget {
  final String gifUrl;
  const GifCard(this.gifUrl, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image(
      fit: BoxFit.fill,
      image: NetworkImage(gifUrl),
    );
  }
}

