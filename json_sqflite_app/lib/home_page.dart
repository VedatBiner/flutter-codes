import 'dart:convert';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    log("🔄 Veritabanından veri okunuyor...");
    final data = await DatabaseHelper.instance.getAllData();
    log("📊 SQLite 'den gelen veri sayısı: ${data.length}");

    if (data.isEmpty) {
      log("📂 Veritabanı boş, JSON 'dan veri ekleniyor...");
      setState(() {
        progress = 0.0;
        isLoading = true;
      });

      try {
        log("🟢 JSON dosyası yükleniyor...");
        final jsonString = await DefaultAssetBundle.of(
          context,
        ).loadString('assets/database/ser_tr_dict.json');
        log("✅ JSON Yükleme Başarılı!");

        final List<dynamic> jsonData = json.decode(jsonString);
        log("📝 JSON içinde ${jsonData.length} veri var.");

        for (int i = 0; i < jsonData.length; i++) {
          await DatabaseHelper.instance.insertSingleItem(jsonData[i]);

          // İlk 10 kayıt için her birinde güncelleme yap
          // 10'dan sonra her 100 kayıtta bir güncelleme yap
          if (i < 10 || i % 100 == 0 || i == jsonData.length - 1) {
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
        log("📥 JSON verisi SQLite'a kaydedildi.");
      } catch (e) {
        log("❌ Hata oluştu: \$e");
      }
    } else {
      log("📊 Veriler bulundu, ekrana yükleniyor...");
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
    log("🗑️ Veritabanı sıfırlandı!");

    await loadDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.blueAccent,
          iconTheme: const IconThemeData(color: Colors.amber),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                "Sırpça-Türkçe Sözlük",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber, // Başlık amber
                ),
              ),
              Text(
                "SQLite ($itemCount madde)",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber, // Başlık amber
                ),
              ),
            ],
          ),
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Menü',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Veritabanını Sıfırla ve Yeniden Yükle'),
                onTap: () async {
                  Navigator.of(context).pop();

                  /// Önce drawer 'ı kapat
                  await Future.delayed(const Duration(milliseconds: 300));

                  /// Küçük bir gecikme
                  await resetDatabase();

                  /// Sonra veritabanını sıfırla
                },
              ),
            ],
          ),
        ),
        body:
            isLoading
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Veriler ekleniyor... ${(progress * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(value: progress),
                  ],
                )
                : ListView.builder(
                  itemCount: dbData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(dbData[index]['sirpca']),
                      subtitle: Text(dbData[index]['turkce']),
                    );
                  },
                ),
      ),
    );
  }
}
