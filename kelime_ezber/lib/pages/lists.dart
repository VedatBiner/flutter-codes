import 'package:flutter/material.dart';
import 'package:kelime_ezber/database/db/dbhelper.dart';
import 'package:kelime_ezber/widgets/appbar_page.dart';
import '../widgets/list_item.dart';
import 'create_list.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  List<Map<String, Object?>> _lists = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    _lists = await DbHelper.instance.readListsAll();
    setState(() {
      _lists;
    });
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
          right: Image.asset(
            "assets/images/logo.png",
            height: 35,
            width: 35,
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
}
