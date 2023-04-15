import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../screens/details/components/title_duration_and_fab_btn.dart';
import '../../../models/movie.dart';
import '../../home/components/genres.dart';
import 'backdrop_rating.dart';
import 'cast_and_crew.dart';
import 'cast_card.dart';

class Body extends StatelessWidget {
  const Body({Key? key, required this.movie}) : super(key: key);

  final Movie movie;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackdropAndRating(size: size, movie: movie),
          const SizedBox(height: kDefaultPadding / 2),
          TitleDurationAndFabBtn(movie: movie),
          Genres(movie: movie), // hata var
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: kDefaultPadding,
            ),
            child: Text(
              "Plot summary",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              movie.plot,
              style: const TextStyle(
                color: Color(0xFF737599),
              ),
            ),
          ),
          CastAndCrew(casts: movie.cast),
        ],
      ),
    );
  }
}
