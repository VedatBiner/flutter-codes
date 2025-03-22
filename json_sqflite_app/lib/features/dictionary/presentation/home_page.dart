import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

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

  Future<void> loadDataFromDatabase() async {
    log("🔄 Veritabanından veri okunuyor...");
    final data = await DatabaseHelper.instance.getAllData();
    log("📊 SQLite 'den gelen veri sayısı: \${data.length}");

    if (data.isEmpty) {
      log("📂 Veritabanı boş, JSON 'dan veri ekleniyor...");
      setState(() {
        progress = 0.0;
        isLoading = true;
      });

      try {
        final jsonString = await DefaultAssetBundle.of(context).loadString('assets/database/ser_tr_dict.json');
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

  void filterSearchResults(String query) {
    List<Map<String, dynamic>> tempList = [];
    if (query.isNotEmpty) {
      tempList = dbData.where((item) =>
      item['sirpca'].toLowerCase().contains(query.toLowerCase()) ||
          item['turkce'].toLowerCase().contains(query.toLowerCase())).toList();
    } else {
      tempList = dbData;
    }
    setState(() {
      filteredData = tempList;
    });
  }

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

  void showResetConfirmationDialog(BuildContext drawerContext) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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

  Map<String, List<Map<String, dynamic>>> groupData(List<Map<String, dynamic>> data) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var item in data) {
      final key = item['sirpca'][0].toUpperCase();
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = groupData(filteredData);

    return SafeArea(
      child: Scaffold(
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
        drawer: AppDrawer(
          onResetDatabase: () => showResetConfirmationDialog(context),
        ),
        body: StackBody(
          isLoading: isLoading,
          progress: progress,
          showLoadedMessage: showLoadedMessage,
          groupedData: groupedData,
        ),
      ),
    );
  }
}
