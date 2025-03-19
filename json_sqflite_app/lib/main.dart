import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> jsonData = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      final manifestJson = await rootBundle.loadString('AssetManifest.json');
      print("Manifest JSON alındı.");

      if (!manifestJson.contains('assets/database/ser_tr_dict.json')) {
        print("HATA: JSON dosyası manifest içinde bulunamadı! Dosya yolu yanlış olabilir.");
        return;
      }

      print("JSON dosyası manifest içinde bulundu! Şimdi yükleniyor...");

      final jsonString = await rootBundle.loadString('assets/database/ser_tr_dict.json');
      print("JSON Yükleniyor...");
      setState(() {
        jsonData = json.decode(jsonString);
      });
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("JSON Listeleme")),
        body: jsonData.isEmpty
            ? Center(child: Text("JSON verisi yükleniyor..."))
            : Scrollbar( // Scroll çubuğu ekledik
          thumbVisibility: true, // Kaydırma çubuğunu her zaman göster
          controller: _scrollController,
          child: ListView.builder(
            controller: _scrollController, // Scroll kontrolü ekledik
            itemCount: jsonData.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(jsonData[index]['sirpca']),
                subtitle: Text("Türkçe: ${jsonData[index]['turkce']} \nEmail: ${jsonData[index]['userEmail']}"),
              );
            },
          ),
        ),
      ),
    );
  }
}