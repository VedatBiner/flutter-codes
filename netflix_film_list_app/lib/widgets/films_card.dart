// 📦 widgets/films_card.dart

import 'package:flutter/material.dart';

class FilmsCard extends StatelessWidget {
  final List<Map<String, String>> filmsList;

  const FilmsCard({super.key, required this.filmsList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ExpansionTile(
            initiallyExpanded: false,
            title: const Text(
              "🎬 Filmler",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filmsList.map((film) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(film['title'] ?? ''),
                          subtitle: Text("İzlenme: ${film['date']}"),
                          leading: const Icon(Icons.movie),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
