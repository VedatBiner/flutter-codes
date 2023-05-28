import 'package:flutter/material.dart';
import 'package:kelime_ezber/methods.dart';
import 'package:kelime_ezber/widgets/appbar_page.dart';
import 'create_list.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        left: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 22,
        ),
        center: Image.asset("assets/images/lists.png"),
        right: Image.asset(
          "assets/images/logo.png",
          height: 35,
          width: 35,
        ),
        leftWidgetOnClick: () => {
          Navigator.pop(context),
        }
      ),
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
        child: Column(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                child: Card(
                  color: Color(
                    RenkMetod.HexaColorConverter("#DCD2FF"),
                  ),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15, top: 5),
                        child: const Text(
                          "Liste Adı",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "RobotoMedium",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: const Text(
                          "305 Terim",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "RobotoRegular",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: const Text(
                          "5 öğrenildi",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "RobotoRegular",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30, bottom: 5),
                        child: const Text(
                          "300 öğrenilmedi",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "RobotoRegular",
                          ),
                        ),
                      ),
                    ],
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
