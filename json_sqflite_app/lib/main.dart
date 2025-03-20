import 'dart:convert';
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
  double progress = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDataFromDatabase();
  }

  Future<void> loadDataFromDatabase() async {
    print("🔄 Veritabanından veri okunuyor...");
    final data = await DatabaseHelper.instance.getAllData();
    print("📊 SQLite'den gelen veri sayısı: ${data.length}");

    if (data.isEmpty) {
      print("📂 Veritabanı boş, JSON'dan veri ekleniyor...");
      setState(() {
        progress = 0.0;
        isLoading = true;
      });

      try {
        print("🟢 JSON dosyası yükleniyor...");
        final jsonString = await DefaultAssetBundle.of(context)
            .loadString('assets/database/ser_tr_dict.json');
        print("✅ JSON Yükleme Başarılı!");

        final List<dynamic> jsonData = json.decode(jsonString);
        print("📝 JSON içinde ${jsonData.length} veri var.");

        for (int i = 0; i < jsonData.length; i++) {
          await DatabaseHelper.instance.insertSingleItem(jsonData[i]);

          // UI Güncellemesi: Her 500 kayıttan sonra ekranı güncelle
          if (i % 500 == 0 || i == jsonData.length - 1) {
            final updatedData = await DatabaseHelper.instance.getAllData();
            setState(() {
              dbData = updatedData;
              itemCount = updatedData.length;
              progress = (i + 1) / jsonData.length;
            });
          }
        }

        setState(() {
          isLoading = false;
          progress = 1.0;
        });
        print("📥 JSON verisi SQLite'a kaydedildi.");
      } catch (e) {
        print("❌ Hata oluştu: $e");
      }
    } else {
      print("📊 Veriler bulundu, ekrana yükleniyor...");
      setState(() {
        dbData = data;
        itemCount = data.length;
        progress = 1.0;
        isLoading = false;
      });
    }
  }

  Future<void> resetDatabase() async {
    await DatabaseHelper.instance.resetDatabase();
    setState(() {
      dbData = [];
      itemCount = 0;
      progress = 0.0;
      isLoading = true;
    });
    print("🗑️ Veritabanı sıfırlandı!");
    loadDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("SQLite Veri Listeleme ($itemCount madde)")),
        body: isLoading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Veriler ekleniyor... %${(progress * 100).toInt()}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            LinearProgressIndicator(value: progress),
          ],
        )
            : Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await resetDatabase();
              },
              child: Text("Veritabanını Sıfırla ve Yeniden Yükle"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dbData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dbData[index]['sirpca']),
                    subtitle: Text(
                      "Türkçe: ${dbData[index]['turkce']} \nEmail: ${dbData[index]['userEmail']}",
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
