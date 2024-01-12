/// <----- details_page.dart ----->
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_constants/constants.dart';
import '../models/words.dart';
import '../screens/details_page_parts/button_helper.dart';
import '../screens/details_page_parts/flag_row.dart';
import '../utils/mesaj_helper.dart';
import '../help_pages/help_parts/custom_appbar.dart';
import 'home_page_parts/drawer_items.dart';

class DetailsPage extends StatefulWidget {
  Words word;

  DetailsPage({
    Key? key,
    required this.word,
  }) : super(key: key);

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

  /// Tüm kelimelerin listesi
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

  /// Önceki kelime
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

  /// Sonraki kelime
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

  /// Kelimelerin güncellenmesi
  Future<void> _updateCurrentWord() async {
    setState(() {
      DocumentSnapshot<Map<String, dynamic>> currentDocumentSnapshot =
          _querySnapshot.docs[_currentIndex];
      widget.word = Words.fromFirestore(currentDocumentSnapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarDetailsTitle,
      ),
      drawer: buildDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildFlagRow(
              'RS',
              widget.word.sirpca,
              detailTextRed,
            ),
            buildFlagRow(
              'TR',
              widget.word.turkce,
              detailTextBlue,
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildElevatedButton(
                    onPressed: () => _loadPreviousWord(),
                    icon: Icons.arrow_left,
                    iconSize: 50,
                  ),
                  const Expanded(
                    child: SizedBox(width: 100),
                  ),
                  buildElevatedButton(
                    onPressed: () => _loadNextWord(),
                    icon: Icons.arrow_right,
                    iconSize: 50,
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
