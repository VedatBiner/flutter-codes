/// <----- details_page.dart ----->

import 'package:flutter/material.dart';

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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.red,
                  ),
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
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
