import 'package:flutter/material.dart';
import 'package:kelime_ezber/widgets/toast_message.dart';
import '../database/db/dbhelper.dart';
import '../database/models/words.dart';
import '../methods.dart';
import '../widgets/appbar_page.dart';

class WordsPage extends StatefulWidget {
  // bu sayfaya gelindiğinde seçilen liste adı ve
  // liste Id bilinmesi gerekiyor
  final int? listID;
  final String? listName;
  const WordsPage(
    this.listID,
    this.listName, {
    Key? key,
  }) : super(key: key);

  @override
  State<WordsPage> createState() =>
      _WordsPageState(listID: listID!, listName: listName!);
}

class _WordsPageState extends State<WordsPage> {
  int listID;
  final String listName;

  _WordsPageState({
    required this.listID,
    required this.listName,
  });

  // kelimeleri tutan değişkenimiz
  List<Word> _wordList = [];

  // basma kontrolü
  bool pressController = false;
  List<bool> deleteIndexList = [];

  @override
  void initState() {
    super.initState();
    print("$listID $listName");
    getWordByList();
  }

  // kelime listesi çekelim
  void getWordByList() async {
    _wordList = await DbHelper.instance.readWordByList(listID);
    for (int i = 0; i < _wordList.length; ++i) {
      deleteIndexList.add(false);
    }
    setState(() => _wordList);
  }

  // kelime silme
  void delete() async {
    // hangi indeksteki elemanların silineceği bilinmeli
    List<int> removeIndexList = [];
    for (int i = 0; i < deleteIndexList.length; ++i) {
      if (deleteIndexList[i] == true) {
        removeIndexList.add(i);
      }
    }

    for (int i = removeIndexList.length - 1; i >= 0; --i) {
      DbHelper.instance.deleteWord(_wordList[removeIndexList[i]].id!);
      _wordList.removeAt(removeIndexList[i]);
      deleteIndexList.removeAt(removeIndexList[i]);
    }

    setState(() {
      _wordList;
      deleteIndexList;
      pressController = false;
    });

    toastMessage("Seçili kelimeler silindi");
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
          listName,
          style: const TextStyle(
            fontFamily: "Carter",
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        right: pressController != true
            ? Image.asset(
                "assets/images/logo.png",
                height: 35,
                width: 35,
              )
            : InkWell(
                onTap: delete,
                child: const Icon(
                  Icons.delete,
                  color: Colors.deepPurpleAccent,
                  size: 24,
                ),
              ),
        leftWidgetOnClick: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return wordItem(
              _wordList[index].id!,
              index,
              word_eng: _wordList[index].word_eng,
              word_tr: _wordList[index].word_tr,
              status: _wordList[index].status!,
            );
          },
          itemCount: _wordList.length,
        ),
      ),
    );
  }

  InkWell wordItem(
    int wordId,
    int index, {
    required String? word_tr,
    required String? word_eng,
    required bool status,
  }) {
    return InkWell(
      onLongPress: () {
        setState(() {
          pressController = true;
          deleteIndexList[index] = true;
        });
      },
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Card(
            // yapılan seçime göre renk değişiyor
            color: pressController != true
                ? Color(RenkMetod.HexaColorConverter("#DCD2FF"))
                : Color(RenkMetod.HexaColorConverter("#E7E3F5")),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(
              // her listeye bir checkbox eklemek için
              // column 'u Row ile sardık
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        word_tr!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: "RobotoMedium",
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30, bottom: 10),
                      child: Text(
                        word_eng!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "RobotoRegular",
                        ),
                      ),
                    ),
                  ],
                ),
                pressController != true
                    ? Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.deepPurpleAccent,
                        hoverColor: Colors.blueAccent,
                        value: status,
                        onChanged: (bool? value) {
                          _wordList[index] =
                              _wordList[index].copy(status: value);
                          if (value == true) {
                            toastMessage("Öğrenildi olarak işaretlendi");
                            DbHelper.instance.markAsLearned(
                                true, _wordList[index].id as int);
                          } else {
                            toastMessage("Öğrenilmedi olarak işaretlendi");
                            DbHelper.instance.markAsLearned(
                                false, _wordList[index].id as int);
                          }
                          setState(() {
                            _wordList;
                          });
                        },
                      )
                    : Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.deepPurpleAccent,
                        hoverColor: Colors.blueAccent,
                        value: deleteIndexList[index],
                        onChanged: (bool? value) {
                          setState(() {
                            deleteIndexList[index] = value!;
                            bool deleteProcessController = false;
                            for (var element in deleteIndexList) {
                              if (element == true) {
                                deleteProcessController = true;
                              }
                            }
                            if (!deleteProcessController) {
                              pressController = false;
                            }
                          });
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







