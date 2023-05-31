import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    print("$listID $listName");
    getWordByList();
  }

  // kelime listesi çekelim
  void getWordByList() async {
    _wordList = await DbHelper.instance.readWordByList(listID);
    setState(() => _wordList);
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
        right: Image.asset(
          "assets/images/logo.png",
          height: 35,
          width: 35,
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

  Center wordItem(
    int wordId,
    int index, {
    required String? word_tr,
    required String? word_eng,
    required bool status,
  }) {
    return Center(
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
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.deepPurpleAccent,
                hoverColor: Colors.blueAccent,
                value: status,
                onChanged: (bool? value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
