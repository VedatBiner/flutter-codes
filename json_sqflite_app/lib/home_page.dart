import 'dart:convert';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> dbData = [];
  List<Map<String, dynamic>> filteredData = [];
  int itemCount = 0;
  double progress = 0.0;
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  TextEditingController sirpcaController = TextEditingController();
  TextEditingController turkceController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDataFromDatabase();
  }

  Future<void> loadDataFromDatabase() async {
    log("🔄 Veritabanından veri okunuyor...");
    final data = await DatabaseHelper.instance.getAllData();
    log("📊 SQLite 'den gelen veri sayısı: ${data.length}");

    setState(() {
      dbData = data;
      filteredData = data;
      itemCount = data.length;
      progress = 1.0;
      isLoading = false;
    });
  }

  void filterSearchResults(String query) {
    List<Map<String, dynamic>> tempList = [];
    if (query.isNotEmpty) {
      tempList = dbData
          .where((item) => item['sirpca'].toLowerCase().contains(query.toLowerCase()) ||
          item['turkce'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      tempList = dbData;
    }
    setState(() {
      filteredData = tempList;
      itemCount = filteredData.length;
    });
  }

  Future<void> addNewWord() async {
    if (sirpcaController.text.isEmpty || turkceController.text.isEmpty || emailController.text.isEmpty) {
      return;
    }

    Map<String, dynamic> newWord = {
      'sirpca': sirpcaController.text,
      'turkce': turkceController.text,
      'userEmail': emailController.text,
    };

    await DatabaseHelper.instance.insertSingleItem(newWord);
    log("✅ Yeni veri eklendi: ${newWord['sirpca']} - ${newWord['turkce']}");

    sirpcaController.clear();
    turkceController.clear();
    emailController.clear();

    loadDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("SQLite Veri Listeleme ($itemCount madde)")),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Ara",
                  hintText: "Kelimeyi girin",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  filterSearchResults(value);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: sirpcaController,
                    decoration: InputDecoration(labelText: "Sırpça Kelime"),
                  ),
                  TextField(
                    controller: turkceController,
                    decoration: InputDecoration(labelText: "Türkçe Karşılık"),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: addNewWord,
                    child: Text("Yeni Kelime Ekle"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredData[index]['sirpca']),
                    subtitle: Text(
                      "Türkçe: ${filteredData[index]['turkce']} \nEmail: ${filteredData[index]['userEmail']}",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
