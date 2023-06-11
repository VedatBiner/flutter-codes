import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kelime_ezber/global_variables.dart';
import '../database/db/shared_preferences.dart';
import '../widgets/toast_message.dart';
import '../database/db/dbhelper.dart';
import '../methods.dart';
import '../widgets/appbar_page.dart';
import '../database/models/words.dart';

class MultipleChoicePage extends StatefulWidget {
  const MultipleChoicePage({Key? key}) : super(key: key);

  @override
  State<MultipleChoicePage> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoicePage> {
  List<Word> _words = [];
  bool start = false;
  // kelime listesi uzunluğu kadar şık listesi
  // her şık listesinde 4 kelime olacak
  List<List<String>> optionsList = [];
  // her kelime için doğru cevaplar
  List<String> correctAnswers = [];
  // kelimeye ait şıklardan herhangi biri işaretlendi mi?
  List<bool> clickControl = [];
  // hangi şık işaretlendi
  List<List<bool>> clickControlList = [];
  // doğru cevap sayısı
  int correctCount = 0;

  /// yanlış cevap sayısı
  int wrongCount = 0;

  @override
  void initState() {
    super.initState();
    getLists().then((value) => setState(() => lists));
  }

  void getSelectedWordsOfLists(List<int> selectedListID) async {
    /// radio buton seçimlerine göre koşullar
    /// öğrenilenler isteniyorsa
    List<String> value = selectedListID.map((e) => e.toString()).toList();
    SP.write("selectedList", value);
    if (chooseQuestionType == Which.learned) {
      _words =
          await DbHelper.instance.readWordByLists(selectedListID, status: true);
    } else if (chooseQuestionType == Which.unlearned) {
      /// öğrenilmeyenler isteniyorsa
      _words = await DbHelper.instance
          .readWordByLists(selectedListID, status: false);
    } else {
      _words = await DbHelper.instance.readWordByLists(selectedListID);
    }

    /// Kelime listesi boş mu ?
    if (_words.isNotEmpty) {
      /// 4 şık için 4 kelime
      if (_words.length > 3) {
        /// listeyi karıştır
        if (listMixed) _words.shuffle();

        /// rasgele sayı üretelim
        /// doğru cevabında aralarında olduğu rasgele listelenecek
        /// bir doğru üç yanlış cevap
        Random random = Random();
        for (int i = 0; i < _words.length; ++i) {
          /// her bir kelime için cevap verilip verilmediğinin kontrolü
          clickControl.add(false);

          /// her kelime için 4 şık var. 4 şıkkında işarelenmediğini belirten
          /// 4 adet false ile doldurduk
          clickControlList.add([false, false, false, false]);
          List<String> tempOptions = [];
          while (true) {
            /// 0 ile kelime listesi uzunluğu -1 kadar değerler alır.
            int rand = random.nextInt(_words.length);
            if (rand != i) {
              bool isThereSame = false;
              for (var element in tempOptions) {
                if (chooseLang == Lang.eng) {
                  if (element == _words[rand].word_tr!) {
                    isThereSame = true;
                  }
                } else {
                  if (element == _words[rand].word_eng!) {
                    isThereSame = true;
                  }
                }
              }
              if (!isThereSame) {
                tempOptions.add(chooseLang == Lang.eng
                    ? _words[rand].word_tr!
                    : _words[rand].word_eng!);
              }
            }
            if (tempOptions.length == 3) {
              break; // while döngüsünden çık
            }
          }
          tempOptions.add(chooseLang == Lang.eng
              ? _words[i].word_tr!
              : _words[i].word_eng!);
          tempOptions.shuffle();
          correctAnswers.add(chooseLang == Lang.eng
              ? _words[i].word_tr!
              : _words[i].word_eng!);
          optionsList.add(tempOptions);
        }
        start = true;
        setState(() {
          _words;
          start;
        });
      } else {
        toastMessage("Minimum dört (4) kelime gereklidir");
      }
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
          "Çoktan Seçmeli",
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
                              text: lists[index]["name"].toString(),
                            );
                          },
                          itemCount: lists.length,
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
                                lists[selectedIndexNoOfList[i]]["list_id"]
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
                  return Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 0,
                                bottom: 16,
                              ),
                              padding: const EdgeInsets.only(
                                  left: 4, top: 4, right: 4),
                              decoration: BoxDecoration(
                                color: Color(
                                    RenkMetod.HexaColorConverter("#DCD2FF")),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    chooseLang == Lang.eng
                                        ? _words[itemIndex].word_eng!
                                        : _words[itemIndex].word_tr!,
                                    style: const TextStyle(
                                      fontFamily: "RobotoRegular",
                                      fontSize: 28,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  customRadioButtonList(
                                    itemIndex,
                                    optionsList[itemIndex],
                                    correctAnswers[itemIndex],
                                  ),
                                ],
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
                            Positioned(
                              left: 210,
                              top: 10,
                              child: Text(
                                "D: $correctCount / Y: $wrongCount",
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
  SizedBox whichRadiobutton({
    required String text,
    required Which value,
  }) {
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
          groupValue: chooseQuestionType,
          onChanged: (Which? value) {
            setState(() {
              chooseQuestionType = value;
            });

            /// seçimlerin kaydedilmesi
            switch (value) {
              case Which.learned:
                SP.write("which", 0);
                break;
              case Which.unlearned:
                SP.write("which", 1);
                break;
              case Which.all:
                SP.write("which", 2);
                break;
              default:
                break;
            }
          },
        ),
      ),
    );
  }

  /// Checkbox seçimi
  /// fWhat parameteresi gönderilmezse
  /// bu metod liste için kullanılacaktır.
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
            SP.write("mix", value!);
          },
        ),
      ),
    );
  }

  Container customRadioButton(
    int index,
    List<String> options,
    int order,
  ) {
    Icon uncheck = const Icon(
      Icons.radio_button_off_outlined,
      size: 16,
    );
    Icon check = const Icon(
      Icons.radio_button_checked_outlined,
      size: 16,
    );
    return Container(
      margin: const EdgeInsets.all(4),
      child: Row(
        children: [
          clickControlList[index][order] == false ? uncheck : check,
          const SizedBox(width: 10),
          Text(
            options[order],
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Column customRadioButtonList(
      int index, List<String> options, String correctAnswer) {
    Divider dV = const Divider(
      thickness: 1,
      height: 1,
    );
    return Column(
      children: [
        dV,
        InkWell(
          onTap: () => toastMessage("Seçmek için çift tıklayınız"),
          onDoubleTap: () => checker(index, 0, options, correctAnswer),
          child: customRadioButton(index, options, 0),
        ),
        dV,
        InkWell(
          onTap: () => toastMessage("Seçmek için çift tıklayınız"),
          onDoubleTap: () => checker(index, 1, options, correctAnswer),
          child: customRadioButton(index, options, 1),
        ),
        dV,
        InkWell(
          onTap: () => toastMessage("Seçmek için çift tıklayınız"),
          onDoubleTap: () => checker(index, 2, options, correctAnswer),
          child: customRadioButton(index, options, 2),
        ),
        dV,
        InkWell(
          onTap: () => toastMessage("Seçmek için çift tıklayınız"),
          onDoubleTap: () => checker(index, 3, options, correctAnswer),
          child: customRadioButton(index, options, 3),
        ),
        dV,
      ],
    );
  }

  void checker(index, order, options, correctAnswer) {
    if (clickControl[index] == false) {
      clickControl[index] == true;
      setState(() {
        clickControlList[index][order] = true;
      });
      // cevap doğru mu ?
      if (options[order] == correctAnswer) {
        correctCount++;
      } else {
        wrongCount++;
      }
      if ((correctCount + wrongCount) == _words.length) {
        toastMessage("Test bitmiştir");
      }
    }
  }
}
