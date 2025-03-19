
import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> dbData = [];
  int itemCount = 0;

  @override
  void initState() {
    super.initState();
    loadDataFromDatabase();
  }

  Future<void> loadDataFromDatabase() async {
    final data = await DatabaseHelper.instance.getAllData();
    setState(() {
      dbData = data;
      itemCount = data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("SQLite Veri Listeleme ($itemCount madde)")),
        body: dbData.isEmpty
            ? Center(child: Text("Veritabanı verisi yükleniyor..."))
            : ListView.builder(
          itemCount: dbData.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(dbData[index]['sirpca']),
              subtitle: Text("Türkçe: ${dbData[index]['turkce']} \nEmail: ${dbData[index]['userEmail']}"),
            );
          },
        ),
      ),
    );
  }
}
