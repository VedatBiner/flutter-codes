import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  final String sirpca;
  final String turkce;

  const WordCard({super.key, required this.sirpca, required this.turkce});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        title: Text(
          sirpca,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade800,
          ),
        ),
        subtitle: Text(
          turkce,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade600,
          ),
        ),
      ),
    );
  }
}
