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
  bool showLoadedMessage = false;

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
          showLoadedMessage = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            showLoadedMessage = false;
          });
        });

        log("📥 JSON verisi SQLite'a kaydedildi.");
      } catch (e) {
        log("❌ Hata oluştu: $e");
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

  void showResetConfirmationDialog(BuildContext drawerContext) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Veritabanını Sıfırla"),
            content: const Text("Veritabanı silinecektir. Emin misiniz?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("İptal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.of(drawerContext).pop();
                  await Future.delayed(const Duration(milliseconds: 300));
                  await resetDatabase();
                },
                child: const Text("Sil"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.blueAccent,
          iconTheme: const IconThemeData(color: Colors.amber),
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              const Text(
                "Sırpça-Türkçe Sözlük",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              Text(
                "SQLite ($itemCount madde)",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
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
        drawer: Builder(
          builder:
              (drawerContext) => Drawer(
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
                      title: const Text(
                        'Veritabanını Sıfırla ve Yeniden Yükle',
                      ),
                      onTap: () => showResetConfirmationDialog(drawerContext),
                    ),
                  ],
                ),
              ),
        ),
        body: Stack(
          children: [
            isLoading
                ? Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.all(20),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Veriler ekleniyor... "),
                              Text(
                                "${(progress * 100).toStringAsFixed(1)}%",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(value: progress),
                        ],
                      ),
                    ),
                  ),
                )
                : ListView.builder(
                  itemCount: dbData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(
                          dbData[index]['sirpca'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade800,
                          ),
                        ),
                        subtitle: Text(
                          dbData[index]['turkce'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            if (showLoadedMessage)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Card(
                    color: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        "✅ Yüklendi!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
