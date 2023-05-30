import 'package:flutter/material.dart';
import 'package:kelime_ezber/database/db/dbhelper.dart';
import 'package:kelime_ezber/widgets/appbar_page.dart';
import 'package:kelime_ezber/widgets/toat_message.dart';
import '../methods.dart';
import 'create_list.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  List<Map<String, Object?>> _lists = [];
  bool pressController = false;
  List<bool> deleteIndexList = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    _lists = await DbHelper.instance.readListsAll();
    for (int i = 0; i < _lists.length; i++) {
      deleteIndexList.add(false);
    }
    setState(() {
      _lists;
    });
  }

  void delete() async {
    List<int> removeIndexList = [];
    for (int i = 0; i < _lists.length; i++) {
      if (deleteIndexList[i] == true) {
        removeIndexList.add(i);
      }
    }
    for (int i = removeIndexList.length - 1; i >= 0; i--) {
      // veri tabanından silme işlemi
      DbHelper.instance.deleteListsAndWordByList(
          _lists[removeIndexList[i]]['list_id'] as int);
      _lists.removeAt(removeIndexList[i]);
      deleteIndexList.removeAt(removeIndexList[i]);
    }
    for (int i = 0; i > deleteIndexList.length; i++) {
      deleteIndexList[i] = false;
    }
    setState(() {
      _lists;
      deleteIndexList;
      pressController = false;
    });
    toastMessage("Seçili listeler silinmiştir.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,
          left: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 22,
          ),
          center: Image.asset("assets/images/lists.png"),
          right: pressController != true
              ? Image.asset(
                  "assets/images/logo.png",
                  height: 35,
                  width: 35,
                )
              : InkWell(
                  onTap: () {
                    delete;
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.deepPurpleAccent,
                    size: 24,
                  ),
                ),
          leftWidgetOnClick: () => {
                Navigator.pop(context),
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateList(),
            ),
          );
        },
        backgroundColor: Colors.purple.withOpacity(0.5),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return listItem(
              _lists[index]["list_id"] as int,
              index,
              listName: _lists[index]['name'].toString(),
              sumWords: _lists[index]['sum_word'].toString(),
              sumUnlearned: _lists[index]['sum_unlearned'].toString(),
            );
          },
          itemCount: _lists.length,
        ),
      ),
    );
  }

  InkWell listItem(
    int id,
    int index, {
    required String? listName,
    required String? sumWords,
    required String? sumUnlearned,
  }) {
    return InkWell(
      onTap: () {
        print(id.toString());
      },
      onLongPress: () {
        setState(() {
          pressController = true;
          deleteIndexList[index] = true;
        });
      },
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: Color(
            RenkMetod.HexaColorConverter("#DCD2FF"),
          ),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 5),
                    child: Text(
                      listName!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "RobotoMedium",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Text(
                      "${sumWords!} terim",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "RobotoRegular",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Text(
                      "${int.parse(sumWords) - int.parse(sumUnlearned!)} öğrenildi",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "RobotoRegular",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 5),
                    child: Text(
                      "$sumUnlearned öğrenilmedi",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "RobotoRegular",
                      ),
                    ),
                  ),
                ],
              ),
              pressController == true
                  ? Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.deepPurpleAccent,
                      hoverColor: Colors.blueAccent,
                      value: deleteIndexList[index],
                      onChanged: (bool? value) {
                        setState(() {
                          deleteIndexList[index] = value!;
                          bool deleteProcessController = false;
                          deleteIndexList.forEach((element) {
                            if (element == true) {
                              deleteProcessController = true;
                            }
                          });
                          // liste eski haline geri dönüyor
                          if (!deleteProcessController) {
                            pressController = false;
                          }
                        });
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
