import 'package:flutter/material.dart';

import '../models/____fs_words.dart_iptal';

class WordTile extends StatefulWidget {
  final FsWords word;
  final String aramaKelimesi;

  const WordTile({
    super.key,
    required this.word,
    required this.aramaKelimesi,
  });

  @override
  State<WordTile> createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {
  @override
  Widget build(BuildContext context) {
    /// arama kelimesine göre filtrele
    if (widget.aramaKelimesi.isNotEmpty &&
        !widget.word.sirpca.contains(widget.aramaKelimesi) &&
        !widget.word.turkce.contains(widget.aramaKelimesi)) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        shadowColor: Colors.green[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.word.sirpca ?? "",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Divider(color: Colors.black38),
                    Text(
                      widget.word.turkce ?? "",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
