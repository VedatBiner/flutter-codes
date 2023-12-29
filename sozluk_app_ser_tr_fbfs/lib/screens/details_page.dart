import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';
import '../models/words.dart';
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
  late DocumentSnapshot<Map<String, dynamic>> _currentDocumentSnapshot;

  @override
  void initState() {
    super.initState();
    _loadNextWord(); // Başlangıçta bir kelime yüklemek için
  }

  Future<void> _loadPreviousWord() async {

      setState(() {
        print("önceki kayıt");
      });

  }

  Future<void> _loadNextWord() async {
    setState(() {
      print("sonraki kayıt");
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
