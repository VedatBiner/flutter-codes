/// <----- details_page.dart ----->
import 'package:flutter/material.dart';

import '../models/words.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.word.sirpca,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.red,
              ),
            ),
            Text(
              widget.word.turkce,
              style: const TextStyle(
                fontSize: 40,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
