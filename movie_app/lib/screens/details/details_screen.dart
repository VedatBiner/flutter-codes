import 'package:flutter/material.dart';
import '../../screens/details/components/body.dart';
import '../../models/movie.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key, required this.movie}) : super(key: key);

  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(movie: movie,),
    );
  }
}
