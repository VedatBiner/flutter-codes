import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kelime_ezber/global_variables.dart';
import '../widgets/toast_message.dart';
import '../database/db/dbhelper.dart';
import '../methods.dart';
import '../widgets/appbar_page.dart';
import '../database/models/words.dart';

class WordsCardPage extends StatefulWidget {
  const WordsCardPage({Key? key}) : super(key: key);

  @override
  State<WordsCardPage> createState() => _WordsCardPageState();
}

enum Which { learned, unlearned, all }

enum forWhat { forList, forListMixed }

class _WordsCardPageState extends State<WordsCardPage> {
  Which? _chooseQuestionType = Which.learned;
  bool listMixed = true;
  List<Map<String, Object?>> _lists = [];
  List<bool> selectedListIndex = [];
  List<Word> _words = [];
  bool start = false;
  List<bool> changeLang = [];

  @override
  void initState() {
    super.initState();
    getLists();
  }

  void getLists() async {
    _lists = await DbHelper.instance.readListsAll();
    for (int i = 0; i < _lists.length; ++i) {
      selectedListIndex.add(false);
    }
    setState(() {
      _lists;
    });
  }

  void getSelectedWordsOfLists(List<int> selectedListID) async {
    // radio buton seçimlerine göre koşullar
    // öğrenilenler isteniyorsa
    if (_chooseQuestionType == Which.learned) {
      _words =
          await DbHelper.instance.readWordByLists(selectedListID, status: true);
    } else if (_chooseQuestionType == Which.unlearned) {
      // öğrenilmeyenler isteniyorsa
      _words = await DbHelper.instance
          .readWordByLists(selectedListID, status: false);
    } else {
      _words = await DbHelper.instance.readWordByLists(selectedListID);
    }
    if (_words.isNotEmpty) {
      for (int i = 0; i < _words.length; ++i) {
        changeLang.add(true);
      }
      // listeyi karıştır
      if (listMixed) _words.shuffle();
      start = true;
      setState(() {
        _words;
        start;
      });
    } else {
      toastMessage("Seçilen şartlarda liste boş ...");
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
        center: const Text(
          "Kelime Kartları",
          style: TextStyle(
            fontFamily: "Carter",
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        leftWidgetOnClick: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: start == false
            ? Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 0,
                  bottom: 16,
                ),
                padding: const EdgeInsets.only(left: 4, top: 4, right: 4),
                decoration: BoxDecoration(
                  color: Color(RenkMetod.HexaColorConverter("#DCD2FF")),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    whichRadiobutton(
                        text: "Öğrenmediklerimi sor", value: Which.unlearned),
                    whichRadiobutton(
                        text: "Öğrendiklerimi sor", value: Which.learned),
                    whichRadiobutton(text: "Hepsini sor", value: Which.all),
                    checkBox(
                        text: "Listeyi karıştır", fWhat: forWhat.forListMixed),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        // Listeler başlık
                        "Listeler",
                        style: TextStyle(
                            fontFamily: "RobotoRegular",
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ),
                    Container(
                      // Listeler bölümü
                      margin: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 10, top: 10),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Scrollbar(
                        thickness: 5,
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return checkBox(
                              index: index,
                              text: _lists[index]["name"].toString(),
                            );
                          },
                          itemCount: _lists.length,
                        ),
                      ),
                    ),
                    Container(
                      // Başla butonu
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 20),
                      child: InkWell(
                        onTap: () {
                          // hangi indeksteki liste seçildi?
                          List<int> selectedIndexNoOfList = [];
                          for (int i = 0; i < selectedListIndex.length; ++i) {
                            if (selectedListIndex[i] == true) {
                              selectedIndexNoOfList.add(i);
                            }
                          }
                          List<int> selectedListIdList = [];
                          for (int i = 0;
                              i < selectedIndexNoOfList.length;
                              ++i) {
                            selectedListIdList.add(
                                _lists[selectedIndexNoOfList[i]]["list_id"]
                                    as int);
                          }
                          if (selectedListIdList.isNotEmpty) {
                            toastMessage("Listeler getiriliyor ...");
                            getSelectedWordsOfLists(selectedListIdList);
                          } else {
                            toastMessage("Lütfen Liste seçiniz");
                          }
                        },
                        child: const Text(
                          "Başla",
                          style: TextStyle(
                            fontFamily: "RobotoRegular",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : CarouselSlider.builder(
                options: CarouselOptions(height: double.infinity),
                itemCount: _words.length,
                itemBuilder: (
                  BuildContext context,
                  int itemIndex,
                  int pageViewIndex,
                ) {
                  String word = "";
                  if (chooseLang == Lang.tr){
                    word = changeLang[itemIndex]
                        ? _words[itemIndex].word_tr!
                        : _words[itemIndex].word_eng!;
                  } else {
                    word = changeLang[itemIndex]
                        ? _words[itemIndex].word_eng!
                        : _words[itemIndex].word_tr!;
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                if (changeLang[itemIndex] == true) {
                                  changeLang[itemIndex] == false;
                                } else {
                                  changeLang[itemIndex] == true;
                                }
                                setState(() {
                                  changeLang[itemIndex];
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 0,
                                  bottom: 16,
                                ),
                                padding: const EdgeInsets.only(
                                    left: 4, top: 10, right: 4),
                                decoration: BoxDecoration(
                                  color: Color(
                                      RenkMetod.HexaColorConverter("#DCD2FF")),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: Text(
                                  word,
                                  style: const TextStyle(
                                    fontFamily: "RobotoRegular",
                                    fontSize: 28,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 30,
                              top: 10,
                              child: Text(
                                "${itemIndex + 1}/${_words.length}",
                                style: const TextStyle(
                                  fontFamily: "RobotoRegular",
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: CheckboxListTile(
                          title: const Text("Öğrendim"),
                          value: _words[itemIndex].status,
                          onChanged: (value) {
                            _words[itemIndex] =
                                _words[itemIndex].copy(status: value);
                            // kelimenin öğrenildi olarak işaretlenmesi
                            DbHelper.instance.markAsLearned(
                                value!, _words[itemIndex].id as int);
                            toastMessage(
                              value
                                  ? "Öğrenildi  olarak işaretlendi"
                                  : "Öğrenilmedi olarak işaretlendi",
                            );
                            setState(() {
                              _words[itemIndex];
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  // radioButton seçimi
  SizedBox whichRadiobutton({required String text, required Which value}) {
    return SizedBox(
      width: 290,
      height: 32,
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(
            fontFamily: "RobotoRegular",
            fontSize: 18,
          ),
        ),
        leading: Radio<Which>(
          value: value,
          groupValue: _chooseQuestionType,
          onChanged: (Which? value) {
            setState(() {
              _chooseQuestionType = value;
            });
          },
        ),
      ),
    );
  }

  // Checkbox seçimi
  // fWhat parameteresi gönderilmezse
  // bu metod liste için kullanılacaktır.
  SizedBox checkBox({
    required String text,
    int index = 0,
    forWhat fWhat = forWhat.forList,
  }) {
    return SizedBox(
      width: 270,
      height: 35,
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(
            fontFamily: "RobotoRegular",
            fontSize: 18,
          ),
        ),
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.deepPurpleAccent,
          hoverColor: Colors.blueAccent,
          value:
              fWhat == forWhat.forList ? selectedListIndex[index] : listMixed,
          onChanged: (bool? value) {
            setState(() {
              if (fWhat == forWhat.forList) {
                selectedListIndex[index] = value!;
              } else {
                listMixed = value!;
              }
            });
          },
        ),
      ),
    );
  }
}
