import 'package:flutter/material.dart';
import '../database/db/dbhelper.dart';
import '../database/models/words.dart';
import '../widgets/action_btn.dart';
import '../widgets/appbar_page.dart';
import '../widgets/textfield_builder.dart';
import '../widgets/toast_message.dart';

class AddWordPage extends StatefulWidget {
  final int? listID;
  final String? listName;
  const AddWordPage(this.listID, this.listName, {Key? key}) : super(key: key);

  @override
  State<AddWordPage> createState() =>
      _AddWordPageState(listID: listID, listName: listName);
}

class _AddWordPageState extends State<AddWordPage> {
  int? listID;
  final String? listName;

  _AddWordPageState({
    required this.listID,
    required this.listName,
  });

  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      wordTextEditingList.add(TextEditingController());
    }
    for (int i = 0; i < 3; i++) {
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
      appBar: appBar(
        context,
        left: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 22,
        ),
        center: Text(
          listName!,
          style: const TextStyle(
            fontFamily: "Carter",
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        right: const Icon(
          Icons.add,
          color: Colors.black,
          size: 22,
        ),
        leftWidgetOnClick: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
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
              textEditingController:
              wordTextEditingList[wordTextEditingList.length - 2],
            ),
          ),
          Expanded(
            child: textFieldBuilder(
              textEditingController:
              wordTextEditingList[wordTextEditingList.length - 1],
            ),
          ),
        ],
      ),
    );
    // sayfayı güncelleyelim
    setState(() => wordListField);
  }

  // kelime ve liste kayıt metodu
  void save() async {
    // dört kelime çifti dolu mu ? kontrol edelim.
    int counter = 0;
    bool notEmptyPair = false;
    for (int i = 0; i < wordTextEditingList.length / 2; i++) {
      String eng = wordTextEditingList[2 * i].text;
      String tr = wordTextEditingList[2 * i + 1].text;
      if (eng.isNotEmpty && tr.isNotEmpty) {
        counter++;
      } else {
        notEmptyPair = true;
      }
    }
    if (counter >= 1) {
      if (!notEmptyPair) {
        for (int i = 0; i < wordTextEditingList.length / 2; i++) {
          String eng = wordTextEditingList[2 * i].text;
          String tr = wordTextEditingList[2 * i + 1].text;
          Word word = await DbHelper.instance.insertWord(
              Word(list_id: listID, word_eng: eng, word_tr: tr, status: false));
        }
        toastMessage("Kelimeler eklendi.");
        // listeyi boşaltalım. Burada for each for döngüsüne çevrildi
        for (var element in wordTextEditingList) {
          element.clear();
        }
      } else {
        toastMessage("Boş alanları doldurun veya silin");
      }
    } else {
      toastMessage("minimum bir çift dolu olmalıdır");
    }
  }

  // kelime listesinden satır silme metodu
  void deleteRow() {
    // varsayılan olarak hep 4 satır kalacak
    if (wordListField.length != 1) {
      // iki textEditing controller siliniyor
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);
      // Son row siliniyor
      wordListField.removeAt(wordListField.length - 1);
      // sayfayı güncelleyelim
      setState(() => wordListField);
    } else {
      toastMessage("Minimum bir çift gereklidir.");
    }
  }
}
