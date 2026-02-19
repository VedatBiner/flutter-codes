import 'package:flutter/material.dart';

import '../../models/netflix_item.dart';
import 'movie_tile.dart';

class MovieSection extends StatelessWidget {
  final List<NetflixItem> movies;
  final ExpansibleController moviesController;
  final VoidCallback onExpand;
  final ValueChanged<NetflixItem> onMovieTap;

  const MovieSection({
    super.key,
    required this.movies,
    required this.moviesController,
    required this.onExpand,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        controller: moviesController,
        onExpansionChanged: (isExpanding) {
          if (isExpanding) onExpand();
        },
        backgroundColor: isLightTheme ? Colors.indigo.shade700 : null,
        collapsedBackgroundColor: isLightTheme ? Colors.indigo : null,
        childrenPadding: isLightTheme ? const EdgeInsets.all(2) : EdgeInsets.zero,
        iconColor: isLightTheme ? Colors.white : null,
        collapsedIconColor: isLightTheme ? Colors.white : null,
        title: Text(
          "Filmler (${movies.length})",
          style: isLightTheme
              ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              : null,
        ),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: ListView.separated(
              itemCount: movies.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade300, height: 1),
              itemBuilder: (context, index) => MovieTile(
                movie: movies[index],
                isLightTheme: isLightTheme,
                onMovieTap: onMovieTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
