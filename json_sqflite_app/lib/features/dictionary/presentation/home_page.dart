// <----- 📜 home_page.dart ----->
// -------------------------------

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/database/database_helper.dart';
import 'widgets/app_drawer.dart';
import 'widgets/stack_body.dart';
import 'widgets/custom_app_bar.dart';

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
  bool showLoadedMessage = false;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDataFromDatabase();
  }

  /// 📜 Veritabanından veri okuma işlemi
  ///
  Future<void> loadDataFromDatabase() async {
    log("🔄 Veritabanından veri okunuyor...");
    final data = await DatabaseHelper.instance.getAllData();
    log("📊 SQLite 'den gelen veri sayısı: \${data.length}");

    /// 📂 Veritabanı boş ise JSON 'dan veri okuma işlemi
    ///
    if (data.isEmpty) {
      log("📂 Veritabanı boş, JSON 'dan veri ekleniyor...");
      setState(() {
        progress = 0.0;
        isLoading = true;
      });

      try {
        final jsonString = await DefaultAssetBundle.of(
          context,
        ).loadString('assets/database/ser_tr_dict.json');
        final List<dynamic> jsonData = json.decode(jsonString);
        log("📝 JSON içinde \${jsonData.length} veri var.");

        for (int i = 0; i < jsonData.length; i++) {
          await DatabaseHelper.instance.insertSingleItem(jsonData[i]);

          if (i < 10 || i % 100 == 0 || i == jsonData.length - 1) {
            final updatedData = await DatabaseHelper.instance.getAllData();
            setState(() {
              dbData = updatedData;
              filteredData = updatedData;
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
        log("❌ Hata oluştu: \$e");
      }
    } else {
      setState(() {
        dbData = data;
        filteredData = data;
        itemCount = data.length;
        progress = 1.0;
        isLoading = false;
      });
    }
  }

  /// 🔍 Arama işlemi
  ///
  void filterSearchResults(String query) {
    List<Map<String, dynamic>> tempList = [];
    if (query.isNotEmpty) {
      tempList =
          dbData
              .where(
                (item) =>
            item['sirpca'].toLowerCase().contains(
              query.toLowerCase(),
            ) ||
                item['turkce'].toLowerCase().contains(query.toLowerCase()),
          )
              .toList();
    } else {
      tempList = dbData;
    }
    setState(() {
      filteredData = tempList;
    });
  }

  /// 📃 Veritabanını sıfırlama işlemi
  ///
  Future<void> resetDatabase() async {
    await DatabaseHelper.instance.resetDatabase();
    setState(() {
      dbData = [];
      filteredData = [];
      itemCount = 0;
      progress = 0.0;
      isLoading = true;
    });

    await loadDataFromDatabase();
  }

  /// 📃 veri tabanını reset 'leyen dialog kutusu
  ///
  void showResetConfirmationDialog(BuildContext drawerContext) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: const Text("Veritabanını Sıfırla"),
        content: const Text("Veritabanı silinecektir. Emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(drawerContext).pop();
            },
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

  /// ➕ Yeni kelime ekleme işlemi
  ///
  void showAddWordDialog() {
    final TextEditingController serbianController = TextEditingController();
    final TextEditingController turkishController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: const Text("Yeni Kelime Ekle"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: serbianController,
              decoration: const InputDecoration(labelText: 'Sırpça'),
            ),
            TextField(
              controller: turkishController,
              decoration: const InputDecoration(labelText: 'Türkçe'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final sirpca = serbianController.text.trim();
              final turkce = turkishController.text.trim();

              if (sirpca.isEmpty || turkce.isEmpty) return;

              final exists = dbData.any(
                    (element) =>
                element['sirpca'].toLowerCase() == sirpca.toLowerCase(),
              );

              if (exists) {
                Fluttertoast.showToast(msg: '⚠️ Bu kelime zaten var!');
                Navigator.of(context).pop();
              } else {
                final newWord = {'sirpca': sirpca, 'turkce': turkce};
                await DatabaseHelper.instance.insertSingleItem(newWord);

                Fluttertoast.showToast(msg: '✅ Kelime eklendi');

                setState(() {
                  dbData.add(newWord);
                  dbData.sort((a, b) => a['sirpca'].toString().compareTo(b['sirpca'].toString()));
                  filteredData = dbData;
                  itemCount = dbData.length;
                });

                Navigator.of(context).pop();
              }

              searchController.clear();
              filterSearchResults('');
            },
            child: const Text("Ekle"),
          ),
        ],
      ),
    );
  }

  /// 📃 Verileri Alfabetik gruplama
  ///
  Map<String, List<Map<String, dynamic>>> groupData(
      List<Map<String, dynamic>> data,
      ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var item in data) {
      final key = item['sirpca'][0].toUpperCase();
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }
    return grouped;
  }

  /// 💻 Ana ekran
  ///
  @override
  Widget build(BuildContext context) {
    final groupedData = groupData(filteredData);

    return SafeArea(
      child: Scaffold(
        /// 📌 AppBar burada oluşturuluyor
        ///
        appBar: CustomAppBar(
          isSearching: isSearching,
          searchController: searchController,
          onSearchChanged: filterSearchResults,
          onSearchToggle: () {
            setState(() {
              isSearching = !isSearching;
              if (!isSearching) {
                searchController.clear();
                filterSearchResults('');
              }
            });
          },
          itemCount: itemCount,
        ),

        /// 📌 Drawer burada oluşturuluyor
        ///
        drawer: AppDrawer(
          onResetDatabase: () => showResetConfirmationDialog(context),
        ),

        /// 📌 Body burada oluşturuluyor
        ///
        body: StackBody(
          isLoading: isLoading,
          progress: progress,
          showLoadedMessage: showLoadedMessage,
          groupedData: groupedData,
        ),

        /// 📌 FloatingActionButton burada oluşturuluyor
        ///
        floatingActionButton: FloatingActionButton(
          onPressed: showAddWordDialog,
          backgroundColor: Colors.amber,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
