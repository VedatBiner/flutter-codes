import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'cast_card.dart';

class CastAndCrew extends StatelessWidget {
  const CastAndCrew({Key? key, required this.casts}) : super(key: key);

  final List casts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        children: [
          Text(
            "Cast & Crew",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: kDefaultPadding),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: casts.length,
              itemBuilder: (context, index) => CastCard(cast: casts[index]),
            ),
          ),
        ],
      ),
    );
  }
}

