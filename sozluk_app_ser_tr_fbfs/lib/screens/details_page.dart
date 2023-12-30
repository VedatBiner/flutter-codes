/// <----- details_page.dart ----->

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';
import '../models/words.dart';
import '../utils/mesaj_helper.dart';
import '../widgets/flags_widget.dart';

class DetailsPage extends StatefulWidget {
  Words word;

  DetailsPage({
    super.key,
    required this.word,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final CollectionReference words =
      FirebaseFirestore.instance.collection("kelimeler");
  late QuerySnapshot<Map<String, dynamic>> _querySnapshot;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _loadWordList();
  }

  /// tüm kelimelerin listesi
  Future<void> _loadWordList() async {
    try {
      _querySnapshot = await words.orderBy("sirpca").get()
          as QuerySnapshot<Map<String, dynamic>>;
      _currentIndex = _querySnapshot.docs.indexWhere(
        (doc) => doc.id == widget.word.wordId,
      );
    } catch (e) {
      print("Hata: $e");
    }
  }

  /// önceki kelime
  Future<void> _loadPreviousWord() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      _updateCurrentWord();
    } else {
      MessageHelper.showSnackBar(
        context,
        message: "Bu ilk kelime, önceki kelime yok.",
      );
    }
  }

  /// sonraki kelime
  Future<void> _loadNextWord() async {
    if (_currentIndex < _querySnapshot.size - 1) {
      _currentIndex++;
      _updateCurrentWord();
    } else {
      MessageHelper.showSnackBar(
        context,
        message: "Bu son kelime, sonraki kelime yok.",
      );
    }
  }

  /// kelimelerin güncellenmesi
  Future<void> _updateCurrentWord() async {
    setState(() {
      DocumentSnapshot<Map<String, dynamic>> _currentDocumentSnapshot =
          _querySnapshot.docs[_currentIndex];
      widget.word = Words.fromFirestore(_currentDocumentSnapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Details Page",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FlagWidget(
                  countryCode: 'RS',
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.word.sirpca,
                  textAlign: TextAlign.left,
                  style: detailTextRed,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FlagWidget(
                  countryCode: 'TR',
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.word.turkce,
                  textAlign: TextAlign.left,
                  style: detailTextBlue,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        _loadPreviousWord();
                      },
                      child: const Icon(Icons.arrow_left),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(width: 100),
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        _loadNextWord();
                      },
                      child: const Icon(Icons.arrow_right),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
