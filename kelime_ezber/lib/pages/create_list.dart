import 'package:flutter/material.dart';
import 'package:kelime_ezber/methods.dart';
import '../widgets/action_btn.dart';
import '../widgets/textfield_builder.dart';

class CreateList extends StatefulWidget {
  const CreateList({Key? key}) : super(key: key);

  @override
  State<CreateList> createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  final _listName = TextEditingController();
  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      wordTextEditingList.add(TextEditingController());
    }
    for (int i = 0; i < 5; i++) {
      wordListField.add(Row(
        children: [
          Expanded(
            child: textFieldBuilder(
                textEditingController: wordTextEditingList[2 * i]),
          ),
          Expanded(
            child: textFieldBuilder(
                textEditingController: wordTextEditingList[2 * i + 1]),
          ),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.20,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 22,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset("assets/images/logo_text.png"),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width * 0.20,
              child: Image.asset(
                "assets/images/logo.png",
                height: 35,
                width: 35,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              textFieldBuilder(
                icon: const Icon(
                  Icons.list,
                  size: 18,
                ),
                hintText: "Liste Adı",
                textEditingController: _listName,
                textAlign: TextAlign.left,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "İngilizce",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "RobotoRegular",
                      ),
                    ),
                    Text(
                      "Türkçe",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "RobotoRegular",
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: wordListField,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionBtn(addRow, Icons.add),
                  actionBtn(save, Icons.save),
                  actionBtn(deleteRow, Icons.remove),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // kelime listesine satır ekleme metodu
  void addRow() {
    // texteditngController ekleyelim
    wordTextEditingList.add(TextEditingController());
    wordTextEditingList.add(TextEditingController());
    // satır ekleyelim
    wordListField.add(
      Row(
        children: [
          Expanded(
            child: textFieldBuilder(
              textEditingController: wordTextEditingList[wordTextEditingList.length - 2],
            ),
          ),
          Expanded(
            child: textFieldBuilder(
              textEditingController: wordTextEditingList[wordTextEditingList.length - 1],
            ),
          ),
        ],
      ),
    );
    // sayfayı güncelleyelim
    setState(() => wordListField);
  }

  void save() {
    for (int i=0; i<wordTextEditingList.length / 2; i++){
      String eng = wordTextEditingList[2 * i].text;
      String tr = wordTextEditingList[2 * i + 1].text;
      if(eng.isNotEmpty || tr.isNotEmpty){
        print("$eng <<<->>> $tr");
      } else {
        print("boş bırakılan alan");
      }
    }
  }

  // kelime listesinden satır silme metodu
  void deleteRow() {
    if(wordListField.length != 1){
      // iki textEditing controller siliniyor
      wordTextEditingList.removeAt(wordTextEditingList.length-1);
      wordTextEditingList.removeAt(wordTextEditingList.length-1);
      // Son row siliniyor
      wordListField.removeAt(wordListField.length - 1);
      // sayfayı güncelleyelim
      setState(() => wordListField);
    }
  }
}
