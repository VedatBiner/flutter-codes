import 'package:flutter/material.dart';
import 'package:kelime_ezber/database/db/dbhelper.dart';
import 'package:kelime_ezber/widgets/appbar_page.dart';
import 'package:kelime_ezber/widgets/toat_message.dart';
import '../database/models/lists.dart';
import '../database/models/words.dart';
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
      appBar: appBar(
        context,
        left: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 22,
        ),
        center: Image.asset("assets/images/logo_text.png"),
        right: Image.asset(
          "assets/images/logo.png",
          height: 35,
          width: 35,
        ),
        leftWidgetOnClick: () => Navigator.pop(context),
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
    // liste adı dolu mu boş mu?
    if(_listName.text.isNotEmpty){
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
      if (counter >= 4) {
        if (!notEmptyPair) {
          Lists addedList =
          await DbHelper.instance.insertList(Lists(name: _listName.text));
          for (int i = 0; i < wordTextEditingList.length / 2; i++) {
            String eng = wordTextEditingList[2 * i].text;
            String tr = wordTextEditingList[2 * i + 1].text;
            Word word = await DbHelper.instance.insertWord(Word(
                list_id: addedList.id,
                word_eng: eng,
                word_tr: tr,
                status: false));
            print(
                "${word.id} ${word.list_id} ${word.word_eng} ${word.word_tr} ${word.status}");
          }
          toastMessage("Liste oluşturuldu.");
          // listeyi boşaltalım. Burada for each for döngüsüne çevrildi
          for (var element in wordTextEditingList) {
            element.clear();
          }
          _listName.clear();
        } else {
          toastMessage("Boş alanları doldurun veya silin");
        }
      } else {
        toastMessage("minimum dört çift dolu olmalıdır");
      }
    } else {
      toastMessage("Lütfen liste adını giriniz");
    }

  }

  // kelime listesinden satır silme metodu
  void deleteRow() {
    // varsayılan olarak hep 4 satır kalacak
    if (wordListField.length != 4) {
      // iki textEditing controller siliniyor
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);
      // Son row siliniyor
      wordListField.removeAt(wordListField.length - 1);
      // sayfayı güncelleyelim
      setState(() => wordListField);
    } else {
      toastMessage("Minimum dör çift gereklidir.");
    }
  }
}
