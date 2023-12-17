/// <----- details_page.dart ----->

import 'package:flag/flag.dart';
import 'package:flag/flag_widget.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flag.fromCode(
                  FlagsCode.ME,
                  height: 50,
                  width: 50,
                  fit: BoxFit.fill,
                  flagSize: FlagSize.size_1x1,
                  borderRadius: 25,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.word.sirpca,
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
                Flag.fromCode(
                  FlagsCode.TR,
                  height: 50,
                  width: 50,
                  fit: BoxFit.fill,
                  flagSize: FlagSize.size_1x1,
                  borderRadius: 25,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.word.turkce,
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
