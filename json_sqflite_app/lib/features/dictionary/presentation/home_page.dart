import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:alphabet_list_view/alphabet_list_view.dart';

import '../../../data/database/database_helper.dart';
import '../../../widgets/word_card.dart';
import '../../../widgets/loading_card.dart';
import 'widgets/search_input.dart';

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
    log("📊 SQLite 'den gelen veri sayısı: ${data.length}");

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
        log("📝 JSON içinde ${jsonData.length} veri var.");

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
        log("❌ Hata oluştu: $e");
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

  @override
  Widget build(BuildContext context) {
    final groupedData = groupData(filteredData);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.blueAccent,
          iconTheme: const IconThemeData(color: Colors.amber),
          centerTitle: true,
          title:
              isSearching
                  ? SearchInput(
                    controller: searchController,
                    onChanged: filterSearchResults,
                  )
                  : Column(
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
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    searchController.clear();
                    filterSearchResults('');
                  }
                });
              },
            ),
          ],
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
            if (isLoading)
              LoadingCard(progress: progress)
            else
              AlphabetListView(
                items:
                    groupedData.entries.map((entry) {
                      return AlphabetListViewItemGroup(
                        tag: entry.key,
                        children:
                            entry.value
                                .map(
                                  (item) => WordCard(
                                    sirpca: item['sirpca'],
                                    turkce: item['turkce'],
                                  ),
                                )
                                .toList(),
                      );
                    }).toList(),

                /// Harfe tıklanınca görünen büyük harfin renkleri
                options: AlphabetListViewOptions(
                  overlayOptions: OverlayOptions(
                    alignment: Alignment.centerRight,
                    overlayBuilder: (context, symbol) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.green, //Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(100),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: FittedBox(
                            child: Text(
                              symbol,
                              textScaler: TextScaler.noScaling,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber //Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
